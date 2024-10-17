/*

FOLLOW / UNFOLLOW BUTTON

This is follow and unfollow button depending on whos profile page we are currently viewing

To use this widget, u need:
- a function (e.g. toggleFollow() when button is pressed)
-isFollowing (e.g. false -> then will show follow button instead of unfollow button)

 */

import 'package:flutter/material.dart';

class MyFollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;

  const MyFollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  //Build UI
  @override
  Widget build(BuildContext context) {
    //padding outside
    return Padding(
      padding: const EdgeInsets.all(25.0),

      //curve corners
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),

        //Material button
        child: MaterialButton(
          //padding inside
          padding: const EdgeInsets.all(25),
          onPressed: onPressed,

          //color
          color: isFollowing
              ? Theme.of(context).colorScheme.primary
              : Colors.green[400],

          //text
          child: Text(
            isFollowing ? "Unfollow" : "Follow",
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
