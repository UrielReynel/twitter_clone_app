import 'package:flutter/material.dart';
import 'package:twitter_clone_app/components/my_drawer_tile.dart';
import 'package:twitter_clone_app/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            //App logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: Icon(Icons.person,
              size:72,
              color: Theme.of(context).colorScheme.primary,
              ),
            ),
        
            //Divider Line
            Divider(
            color: Theme.of(context).colorScheme.secondary),

            const SizedBox(height: 10),
        
            //home list tile
            MyDrawerTile(
              title: "H O M E",
              icon: Icons.home,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            //profile list tile
        
            //search list tile
        
            //settings list tile
            MyDrawerTile(
              title: "S E T T I N G S",
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                //go to settings page
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SettingsPage()));
              },
            ),
            //logout list tile
          ],
        ),
      ),
    );
  }
}