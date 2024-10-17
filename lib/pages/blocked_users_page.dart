/*

BLOCKED USERS PAGE
This page displays a list of users that have been blocked.
- you can unblock users from this page.

 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truckerfinal/services/database/database_provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  //Providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  //on start up
  @override
  void initState() {
    super.initState();

    //load blocked users
    loadBlockedUsers();
  }

  //load blocked users
  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  //show confirm unblock box
  void _showUnblockConfirmationBox(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          //unblock button
          TextButton(
            onPressed: () async {
              //unblock user
              await databaseProvider.unblockUser(userId);

              //close box
              Navigator.pop(context);

              //let user know it was successfully reported
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User unblocked")));
            },
            child: const Text("Unblock"),
          )
        ],
      ),
    );
  }

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //listen to blocked users
    final blockedUsers = listeningProvider.blockedUsers;

    //SCAFFOLD
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,

        //App Bar
        title: const Text('Blocked Users'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      //Body
      body: blockedUsers.isEmpty
          ? const Center(
              child: Text("No blocked users"),
            )
          : ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                //get each user
                final user = blockedUsers[index];

                //return as ListTile UI
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('@${user.username}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.block),
                    onPressed: () => _showUnblockConfirmationBox(user.uid),
                  ),
                );
              },
            ),
    );
  }
}
