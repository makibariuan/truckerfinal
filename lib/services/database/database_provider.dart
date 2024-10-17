import 'package:flutter/material.dart';
import 'package:truckerfinal/components/models/comment.dart';
import 'package:truckerfinal/components/models/post.dart';
import 'package:truckerfinal/components/models/user.dart';
import 'package:truckerfinal/services/auth/auth_service.dart';
import 'package:truckerfinal/services/database/database_service.dart';

/*

DATABASE PROVIDER

This provider is to separate the firestore data handling and the UI of our app.

--------------------------------------------------------------------------------

- The database service class handles data to and from firebase
- The database provider class processes the data to display in our app

this is to make sure our code much more modular, cleaner and easier to read and test.
Particularly as the number of pages grow, we need this provider to properly manage
the different states of the app

- Also, if one day, we decide to change our backend from another,
then it's much easier to manage and switch out different databases



 */

class DatabaseProvider extends ChangeNotifier {
/*
  
SERVICES

 */

// get db and auth service

  final _db = DatabaseService();
  final _auth = AuthService();

  /*
  
  USER PROFILE

   */
  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);

  /*
  POST
   */

  // local list of post
  List<Post> _allPosts = [];

  // get posts
  List<Post> get allPost => _allPosts;

  // post message
  Future<void> postMessage(String message) async {
    // post message in firebase
    await _db.postMessageInFirebase(message);

    // reload data from firebase
    await loadAllPosts();
  }

  // fetch all posts
  Future<void> loadAllPosts() async {
    // get all post from firebase
    final allPosts = await _db.getAllPostFromFirebase();

    //get blocked user id's
    final blockedUserIds = await _db.getBlockedUidsFromFirebase();

    //filter out blocked users posts & update locally
    _allPosts =
        allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

    //initialize local like data
    initializeLikeMap();

    // update UI
    notifyListeners();
  }

  // filter and return post given uid
  List<Post> filterUserPost(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  //delete post
  Future<void> deletePost(String postId) async {
    //delete from firebase
    await _db.deletePostFromFirebase(postId);

    //reload data from firebase
    await loadAllPosts();
  }

/*

LIKES
*/

//Local map to track the like counts for each post
  Map<String, int> _likeCounts = {
    //for each post id: like count
  };

  //Local list to track post liked by current user
  List<String> _likedPosts = [];

  //does the current user this post?
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  //get like count of post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  //initialize like map locally
  void initializeLikeMap() {
    //get current uid
    final currentUserID = _auth.getCurrentUid();

    //clear liked post (new user signs in, clear local data)
    _likedPosts.clear();

    //like data for each post
    for (var post in _allPosts) {
      //update like count map
      _likeCounts[post.id] = post.likeCount;

      //if the current user already likes this post
      if (post.likedBy.contains(currentUserID)) {
        //add this post id to local list of liked post
        _likedPosts.add(post.id);
      }
    }
  }

  //toggle like
  Future<void> toggleLike(String postId) async {
    /*

    This first part will update the local values first so that the UI feels immediate and responsive.
    we will update the ui optimistically and revert back if anything goes wrong while writing the database

    Optimistically updating the local values like this is important because:
    reading and writing from the database takes some time (1-2 seconds, depending on the internet connection). 
    So we dont want to give the user a slow lagged experience.

    */

    // store the original values in case it fails
    final likedPostOriginal = _likedPosts;
    final likedCountsOriginal = _likeCounts;

    //perform like / unlike
    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    //update the ui locally
    notifyListeners();

    /*

    Now lets try to update it in our database
    
     */

    //attemp to like in database
    try {
      await _db.toggleLikeInFirebase(postId);
    }

    //revert back to initial state if uodate fails
    catch (e) {
      _likedPosts = likedPostOriginal;
      _likeCounts = likedCountsOriginal;

      //update ui again
      notifyListeners();
    }
  }

/*
COMMENTS

{

postId1: [comment1, comment2, ...],
postId2: [comment1, comment2, ...],
postId3: [comment1, comment2, ...],

}
 */

  //local list of comments
  final Map<String, List<Comment>> _comments = {};

  //get comments locally
  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  //fetch comments from database for a post
  Future<void> loadComments(String postId) async {
    //get all comments for this post
    final allComments = await _db.getCommentsFromFirebase(postId);

    //update local data
    _comments[postId] = allComments;

    //update UI
    notifyListeners();
  }

  //add a comment
  Future<void> addComment(String postId, message) async {
    //add comment in firebase
    await _db.addCommentInFirebase(postId, message);

    //reload comments
    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String commentId, postId) async {
    //delete comment in firebase
    await _db.deleteCommentInFirebase(commentId);

    //reload comments
    await loadComments(postId);
  }

/*

ACCOUNT STUFF

 */

//local list of blocked users
  List<UserProfile> _blockedUsers = [];

//get list of blocked users
  List<UserProfile> get blockedUsers => _blockedUsers;

//fetch blocked users
  Future<void> loadBlockedUsers() async {
    //get list of blocked user ids
    final blockedUserIds = await _db.getBlockedUidsFromFirebase();

    //get full user details using uids
    final blockedUsersData = await Future.wait(
        blockedUserIds.map((id) => _db.getUserFromFirebase(id)));

    //return as a list
    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();

    //Update UI
    notifyListeners();
  }

// block user
  Future<void> blockUser(String userId) async {
    //perform block in firebase
    await _db.blockUserInFirebase(userId);

    //reload blocked users
    await loadBlockedUsers();

    //reload data
    await loadAllPosts();

    //update UI
    notifyListeners();
  }

//unblock user
  Future<void> unblockUser(String blockedUserId) async {
    //perform unblock in firebase
    await _db.unblockUserInFirebase(blockedUserId);

    //reload blocked users
    await loadBlockedUsers();

    //reload data
    await loadAllPosts();

    //update UI
    notifyListeners();
  }

//report user & post
  Future<void> reportUser(String postId, userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }

/*

FOLLOW
Everything here is done with uids (String)
----------------------------------------------

Each user id has a list of:
-followers uid
-following uid

 */

//local map
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followerCount = {};
  final Map<String, int> _followingCount = {};

//get counts for followers and following locally: given uid
  int getFollowerCount(String uid) => _followerCount[uid] ?? 0;
  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

//load followers
  Future<void> loadUserFollowers(String uid) async {
    //get the list of follower uids from firebase
    final listOfFollowerUids = await _db.getFollowerUidsFromFirebase(uid);

    //update local data
    _followers[uid] = listOfFollowerUids;
    _followerCount[uid] = listOfFollowerUids.length;

    //update UI
    notifyListeners();
  }

//load following
  Future<void> loadUserFollowing(String uid) async {
    //get the list of follower uids from firebase
    final listOfFollowingUids = await _db.getFollowingUidsFromFirebase(uid);

    //update local data
    _following[uid] = listOfFollowingUids;
    _followingCount[uid] = listOfFollowingUids.length;

    //update UI
    notifyListeners();
  }

//follow user
  Future<void> followUser(String targetUserId) async {
    /*
      currently logged in user wants to follow target user
     */

    //get current uid
    final currentUserId = _auth.getCurrentUid();

    //initialize with empty list if null
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    /*
    Optimistic UI changes: update the local data and revert back if firebase request fails
     */

    //follow if the current user is not one of the target users followers
    if (!_followers[targetUserId]!.contains(currentUserId)) {
      //add current user to target users follower list
      _followers[targetUserId]?.add(currentUserId);

      //update follower count
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      //then add target user to current user following
      _following[currentUserId]?.add(targetUserId);

      //update following
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;
    }

    //update UI
    notifyListeners();

    /*
    UI has been optimistically update above with local data
    Now lets try to make this request to our database.

    */

    try {
      //follow user in firebase
      await _db.followUserInFirebase(targetUserId);

      //reload current user in followers
      await loadUserFollowers(currentUserId);

      //reload current users following
      await loadUserFollowing(currentUserId);
    }
    //catche if there is an error, revert back to original
    catch (e) {
      //remove current user from target users followers
      _followers[targetUserId]?.remove(currentUserId);

      //update follower count
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) - 1;

      //remove from current users following
      _following[currentUserId]?.remove(targetUserId);

      //update following count
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) - 1;

      //update UI
      notifyListeners();
    }
  }

//unfollow user
  Future<void> unfollowUser(String targetUserId) async {
    /*
    currently logged in user wants to unfollow target user
     */

    //get current uid
    final currentUserId = _auth.getCurrentUid();

    //initialize list if they dont exist
    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(currentUserId, () => []);

    /*
    Optimistic UI changes:Update the local data first & revert back if the data request failed.

     */

    //unfollow if current user is one of the target users following
    if (_followers[targetUserId]!.contains(currentUserId)) {
      //remove current user from target users following
      _followers[targetUserId]?.remove(currentUserId);

      //update follower count
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 1) - 1;

      //remove target user from current user's following list
      _following[currentUserId]?.remove(targetUserId);

      //update following count
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 1) - 1;
    }

    //update UI
    notifyListeners();

    /*
    UI has been updated will local data above.
    now lets try to make this request to our database.
     */

    try {
      //unfollow target user in firebase
      await _db.unFollowUserInFirebase(targetUserId);

      //reload user followers
      await loadUserFollowers(currentUserId);

      //reload users following
      await loadUserFollowing(currentUserId);
    }
    //if there is an error, revert back to original
    catch (e) {
      //add current user back into target users followers
      _followers[targetUserId]?.add(currentUserId);

      //update follower count
      _followerCount[targetUserId] = (_followerCount[targetUserId] ?? 0) + 1;

      //add target user back into current users following list
      _following[currentUserId]?.add(targetUserId);

      //update following count
      _followingCount[currentUserId] =
          (_followingCount[currentUserId] ?? 0) + 1;

      //update UI
      notifyListeners();
    }
  }

//is current user following target user?
  bool isFollowing(String uid) {
    final currentUserId = _auth.getCurrentUid();
    return _followers[uid]?.contains(currentUserId) ?? false;
  }
}
