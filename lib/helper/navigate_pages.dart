import 'package:flutter/material.dart';
import 'package:truckerfinal/components/models/post.dart';
import 'package:truckerfinal/pages/blocked_users_page.dart';
import 'package:truckerfinal/pages/post_page.dart';
import 'package:truckerfinal/pages/profile_page.dart';

import '../pages/account_settings_page.dart';

// go to user page
void goUserPage(BuildContext context, String uid) {
  // navigate to the profile page
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(uid: uid),
      ));
}

// go to post page
void goPostPage(BuildContext context, Post post) {
  // navigate to the post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post),
    ),
  );
}

//go to blocked user page
void goBlockedUsersPage(BuildContext context) {
  //navigate to page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BlockedUsersPage(),
    ),
  );
}

//go to account settings page
void goAccountSettingsPage(BuildContext context) {
  //navigate to page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AccountSettingsPage(),
    ),
  );
}
