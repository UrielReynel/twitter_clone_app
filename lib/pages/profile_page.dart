import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_service.dart';
import '../components/my_bio_box.dart';
import '../components/my_input_alert_box.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Servicios
  late final DatabaseService _databaseService = DatabaseService();

  // Usuario a mostrar
  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  // Estado de carga
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    user = await _databaseService.getUserFromFirebase(widget.uid);
    setState(() {
      _isLoading = false;
    });
  }

  // Mostrar cuadro de diálogo para editar Bio
  void _showEditBioBox() {
    TextEditingController bioController = TextEditingController();
    
    showDialog(
      context: context, 
      builder: (context) => MyInputAlertBox(
        textController: bioController, 
        hintText: "Edita tu biografía...", 
        onPressed: () async {
          // Guardar en base de datos
          await _databaseService.updateBioInFirebase(bioController.text);
          // Recargar usuario para ver cambios
          loadUser();
        }, 
        onPressedText: "Guardar"
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determinar si es mi propio perfil (para mostrar botón editar)
    bool isOwnProfile = widget.uid == currentUserId;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(_isLoading ? '' : user?.name ?? 'Usuario'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : user == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Usuario no encontrado en la base de datos."),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Crear perfil con datos básicos del usuario actual
                    final currentUser = AuthService().getCurrentUser();
                    if (currentUser != null) {
                      await _databaseService.saveUserInfoInFirebase(
                        name: currentUser.email?.split('@')[0] ?? 'Usuario',
                        email: currentUser.email ?? '',
                      );
                      // Recargar
                      loadUser();
                    }
                  },
                  child: const Text("Crear mi perfil ahora"),
                ),
              ],
            ),
          )
        : ListView(
            children: [
              // Username handle
              Center(
                child: Text(
                  '@${user!.username}',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              const SizedBox(height: 25),

              // Foto de perfil (Icono por ahora)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Texto "Bio" y botón editar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bio",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                    ),
                    // Solo mostrar botón si es mi perfil
                    if (isOwnProfile)
                      GestureDetector(
                        onTap: _showEditBioBox,
                        child: Icon(
                          Icons.settings, 
                          color: Theme.of(context).colorScheme.primary
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Caja de Bio
              MyBioBox(text: user!.bio),

              const SizedBox(height: 25),
              
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  "Publicaciones",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),

              // Lista de Posts del usuario (Esto lo conectaremos después)
              // Por ahora dejamos un espacio
              const SizedBox(height: 20),
            ],
          ),
    );
  }
}