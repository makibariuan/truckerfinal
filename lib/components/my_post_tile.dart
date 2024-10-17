import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truckerfinal/components/models/post.dart';
import 'package:truckerfinal/components/my_input_alert_box.dart';
import 'package:truckerfinal/services/auth/auth_service.dart';
import 'package:truckerfinal/services/database/database_provider.dart';

/*
POST TILE

All post will be displayed using this post tile widget.

-------------------------------------------------------------------------------

To use this widget, you need:

- The post
- a function for onPostTap( go to the individual post to see more info (e.g comments/likes) )

- a function for onUserTap (Go to user profile page)
 */

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  //provider
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  //on startup,
  @override
  void initState() {
    super.initState();

    //load comment for this post
    _loadComments();
  }

  /*
      LIKES

      */

  //user tapped like (or unlike)
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  /*

    COMMENTS

    */

  //comments text controller
  final _commentController = TextEditingController();

  //open comment box -> user wants to type new comment
  void _openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textcontroller: _commentController,
        hintText: "Write Comment",
        onPressed: () async {
          // add post in db
          await _addComment();
        },
        onPressedText: "Post",
      ),
    );
  }

  //user tapped post to add comment
  Future<void> _addComment() async {
    //does nothing if theres nothing in the textfield
    if (_commentController.text.trim().isEmpty) return;

    //attempt to post comment
    try {
      await databaseProvider.addComment(
          widget.post.id, _commentController.text.trim());
    } catch (e) {
      print(e);
    }
  }

  //load comments
  Future<void> _loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
  }

  /*

  SHOW OPTIONS

  case1: This post belongs to current user
  - Delete
  - Cancel
  
  case2: This post does NOT belong to current user
  -Report
  -Block
  -Cancel
  */

  //show options for post
  void _showOptions() {
    //check if post is owned by the user or not
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    //show options
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              //THIS POST BELONGS TO CURRENT USER
              if (isOwnPost)

                // delete message button
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    //pop the option box
                    Navigator.pop(context);

                    //handle the delete action
                    await databaseProvider.deletePost(widget.post.id);
                  },
                )

              //THIS POST DOESNT BELONG TO CURRENT USER
              else ...[
                //report post button
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    //pop the option box
                    Navigator.pop(context);

                    // handle report action
                    _reportPostConfirmationBox();
                  },
                ), //ListTile

                //block user button
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    //pop the option box
                    Navigator.pop(context);

                    //handle block action
                    _blockUserConfirmationBox();
                  },
                ) //ListTile
              ],

              //cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  //report post confirmation
  void _reportPostConfirmationBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Insight"),
        content: const Text("Are you sure you want to report this insight?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          //report button
          TextButton(
            onPressed: () async {
              //report user
              await databaseProvider.reportUser(
                  widget.post.id, widget.post.uid);

              //close box
              Navigator.pop(context);

              //let user know it was successfully reported
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("insight reported!")));
            },
            child: const Text("Report"),
          )
        ],
      ),
    );
  }

  //block user confirmation
  void _blockUserConfirmationBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User?"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          //block button
          TextButton(
            onPressed: () async {
              //block user
              await databaseProvider.blockUser(widget.post.uid);

              //close box
              Navigator.pop(context);

              //let user know user was successfully blocked
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("User Blocked.")));
            },
            child: const Text("Block"),
          )
        ],
      ),
    );
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    //doest the current user like this post?
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    //listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // listen to comment count
    int commentCount = listeningProvider.getComments(widget.post.id).length;

    //container
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        // padding outside
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

        // padding inside
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color of post tile
          color: Theme.of(context).colorScheme.secondary,

          // curve
          borderRadius: BorderRadius.circular(8),
        ),

        // Column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Top Section : Profile pic/name/username
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // profile pic
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  const SizedBox(width: 10),

                  // name
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 5),
                  // Username handle
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),

                  //buttons -> more options: delete
                  GestureDetector(
                    onTap: _showOptions,
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // message
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 20),

            //buttons -> like, comment
            Row(
              children: [
                //LIKE SECTION
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      //like button
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // like count
                      Text(
                        likeCount != 0 ? likeCount.toString() : '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),

                //COMMENT SECTIONS
                Row(
                  children: [
                    //comment button
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(width: 5),

                    //comment count
                    Text(
                      commentCount != 0 ? commentCount.toString() : '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
