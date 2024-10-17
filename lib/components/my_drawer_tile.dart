import 'package:flutter/material.dart';

/* 
DRAWER TILE

Simple tile for eah item in the menu drawer

To use this widget, you need:

- title (e.g "Home")
- icon (e.g Icons.home)
- function (e.g goToHomePage())
*/

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

//Build UI
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}
