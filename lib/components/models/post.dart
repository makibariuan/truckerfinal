import 'package:cloud_firestore/cloud_firestore.dart';

/*

POST MODEL
THIS IS WHAT POST SHOULD HAVE

 */

class Post {
  final String id; // id of this post
  final String uid; // uid of the poster
  final String name; // name of the poster
  final String username; // username of the poster
  final String message; // message of the post
  final Timestamp timestamp; // timestamp of the post
  final int likeCount; // likeCount of this post
  final List<String> likedBy; // list of user IDs who liked this post

  Post({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.likeCount,
    required this.likedBy,
  });

  /*  
    firebase -> app
    convert firestore document to a user profile (so that we can use it in our app)
  */
  factory Post.fromDocment(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      likeCount: doc['likes'],
      likedBy: List<String>.from(doc['likedBy'] ?? []),
    );
  }

  /*
  app -> firebase
  convert user profile to a map (so that we can store in firebase)
  */

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likes': likeCount,
      'likedBy': likedBy,
    };
  }
}
