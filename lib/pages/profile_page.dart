/*
  UBICACIÓN: lib/pages/profile_page.dart
*/
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_service.dart';
import '../components/my_bio_box.dart';
import '../components/my_input_alert_box.dart';
import '../components/my_post_tile.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _databaseService = DatabaseService();
  final _authService = AuthService();

  UserProfile? user;
  bool _isLoading = true;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await _databaseService.getUserFromFirebase(widget.uid);
    
    if (widget.uid != _authService.getCurrentUid()) {
      _isFollowing = await _databaseService.isFollowing(widget.uid);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleFollow() async {
    if (_isFollowing) {
      await _databaseService.unfollowUser(widget.uid);
    } else {
      await _databaseService.followUser(widget.uid);
    }

    setState(() {
      _isFollowing = !_isFollowing;
    });
  }

  void _blockUser() async {
    await _databaseService.blockUser(widget.uid);
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Usuario bloqueado")));
       Navigator.pop(context);
    }
  }

  void _showEditBioBox() {
    TextEditingController bioController = TextEditingController();
    showDialog(
      context: context, 
      builder: (context) => MyInputAlertBox(
        textController: bioController, 
        hintText: "Edita tu biografía...", 
        onPressed: () async {
          await _databaseService.updateBioInFirebase(bioController.text);
          loadUser();
        }, 
        onPressedText: "Guardar"
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = _authService.getCurrentUid();
    bool isOwnProfile = widget.uid == currentUserId;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_isLoading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (!isOwnProfile && !_isLoading)
             PopupMenuButton(
               itemBuilder: (context) => [
                 PopupMenuItem(
                   value: 'block',
                   child: const Text("Bloquear usuario"),
                   onTap: _blockUser,
                 ),
               ]
             )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              // 1. Username
              Center(
                child: Text(
                  '@${user!.username}',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(height: 25),

              // 2. Foto de Perfil
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // 3. Botón Seguir / Editar
              if (isOwnProfile)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Bio", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      GestureDetector(
                        onTap: _showEditBioBox,
                        child: Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                )
              else 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: ElevatedButton(
                    onPressed: _toggleFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_isFollowing ? "Siguiendo" : "Seguir"),
                  ),
                ),

              const SizedBox(height: 10),

              // 4. Bio Box
              MyBioBox(text: user!.bio),
              
              const SizedBox(height: 25),

              // 5. Contadores
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<int>(
                      stream: _databaseService.getFollowerCount(widget.uid),
                      builder: (context, snapshot) => Text("Seguidores: ${snapshot.data ?? 0}"),
                    ),
                    const SizedBox(width: 20),
                    StreamBuilder<int>(
                      stream: _databaseService.getFollowingCount(widget.uid),
                      builder: (context, snapshot) => Text("Siguiendo: ${snapshot.data ?? 0}"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 6. Título "Publicaciones"
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  "Publicaciones",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(height: 10),

              // 7. LISTA DE POSTS DEL USUARIO
              StreamBuilder<List<Post>>(
                stream: _databaseService.getPostsByUser(widget.uid),
                builder: (context, snapshot) {
                  // DETECCIÓN DE ERRORES (Aquí está la clave)
                  if (snapshot.hasError) {
                    print(snapshot.error); // Esto imprime el error en la consola
                    return Center(
                      child: Text(
                        "Error cargando posts. Revisa la consola para crear el índice.",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Aún no hay publicaciones.",
                          style: TextStyle(color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    );
                  }

                  final posts = snapshot.data!;

                  return ListView.builder(
                    itemCount: posts.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return MyPostTile(post: post);
                    },
                  );
                },
              ),
              
              const SizedBox(height: 50),
            ],
          ),
    );
  }
}