import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truckerfinal/components/models/post.dart';
import 'package:truckerfinal/components/my_comment_tile.dart';
import 'package:truckerfinal/components/my_post_tile.dart';
import 'package:truckerfinal/helper/navigate_pages.dart';
import 'package:truckerfinal/services/database/database_provider.dart';

/*
POST PAGE

This page displays:

- individual post 
- comments on this post

 */

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({
    super.key,
    required this.post,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  //providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  //BUILD UI
  @override
  Widget build(BuildContext context) {
    //listen to all comments for this post
    final allComments = listeningProvider.getComments(widget.post.id);

    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      //Body
      body: ListView(
        children: [
          // Post
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),

          // Comments on this post
          allComments.isEmpty
              ?
              //no comments yet
              const Center(
                  child: Text("No comments yet."),
                )
              :

              //comments exists
              ListView.builder(
                  itemCount: allComments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // get each comment
                    final comment = allComments[index];

                    //return as comment tile UI
                    return MyCommentTile(
                      comment: comment,
                      onUserTap: () => goUserPage(context, comment.uid),
                    );
                  },
                )
        ],
      ),
    );
  }
}
