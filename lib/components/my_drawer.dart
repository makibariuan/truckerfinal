import 'package:flutter/material.dart';
import 'package:truckerfinal/pages/profile_page.dart';
import 'package:truckerfinal/pages/settings_page.dart';
import 'package:truckerfinal/services/auth/auth_service.dart';
import 'my_drawer_tile.dart';

// Menu drawer

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // Access auth service
  final _auth = AuthService();

  // logout method
  void logout() {
    _auth.logout();
  }

// Build UI
  @override
  Widget build(BuildContext context) {
    // Drawer
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              //App logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              //Divider line
              Divider(color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 10),
              // home list
              MyDrawerTile(
                title: 'H O M E',
                icon: Icons.home,
                onTap: () {
                  // Pop menu drawer since we are already at home
                  Navigator.pop(context);
                },
              ),
              // profile
              MyDrawerTile(
                title: "P R O F I L E",
                icon: Icons.person,
                onTap: () {
                  // Pop menu drawwer
                  Navigator.pop(context);

                  // go to profile page

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: _auth.getCurrentUid(),
                      ),
                    ),
                  );
                },
              ),
              // settings
              MyDrawerTile(
                title: 'S E T T I N G S',
                icon: Icons.person,
                onTap: () {
                  // Pop menu drawwer
                  Navigator.pop(context);

                  // go to settings page

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              // search

              const Spacer(),
              // logout
              MyDrawerTile(
                title: "L O G O U T",
                icon: Icons.logout,
                onTap: logout,
              )
            ],
          ),
        ),
      ),
    );
  }
}
