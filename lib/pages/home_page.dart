import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truckerfinal/components/models/post.dart';
import 'package:truckerfinal/components/my_drawer.dart';
import 'package:truckerfinal/components/my_input_alert_box.dart';
import 'package:truckerfinal/components/my_post_tile.dart';
import 'package:truckerfinal/helper/navigate_pages.dart';
import 'package:truckerfinal/services/database/database_provider.dart';

/*

HOME PAGE

This is the main page of this app : it disply

 */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // text controller
  final _messageController = TextEditingController();

  // on startup

  @override
  void initState() {
    super.initState();

    // let's load all post
    loadAllPost();
  }

  // load all post
  Future<void> loadAllPost() async {
    await databaseProvider.loadAllPosts();
  }

  // show post message dialog box
  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textcontroller: _messageController,
        hintText: "What's on your mind?",
        onPressed: () async {
          // post in db
          await postMessage(_messageController.text);
        },
        onPressedText: "Post",
      ),
    );
  }

  // user want to post message
  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),

      // APP BAR
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'T R U C K E R',
          style: TextStyle(
            color: Color(0xFF6D9886),
          ),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        backgroundColor: const Color(0xFF6D9886),
        child: const Icon(Icons.add),
      ),

      // Body : list of all posts
      body: _buildPostList(listeningProvider.allPost),
    );
  }

  // Build list UI given a list of posts
  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ?
        // post list empty
        const Center(
            child: Text("Nothing here..."),
          )
        // post list !empty
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // get each individual post
              final post = posts[index];

              // return Post Tile Ui
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
