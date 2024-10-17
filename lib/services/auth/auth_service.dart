import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:truckerfinal/services/database/database_service.dart';
/*
AUTHENTICATION SERVICE

This handles everything to do with the authentication in firebase

-----------------------------------------------------------------

- Login
- Register
- Logout
- Delete Account


 */

class AuthService {
  // get instance of the auth
  final _auth = FirebaseAuth.instance;
  final dbRef = Firebase;

  //get current user and uid
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;
  // login -> email and pw
  Future<UserCredential> loginEmailPassword(String email, password) async {
    // attempt to login
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }
    //catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Register -> email & pw
  Future<UserCredential> registerEmailPassword(String email, password) async {
    // attempt to register
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    }
    //catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Delete account
  Future<void> deleteAccount() async {
    //get current user id
    User? user = getCurrentUser();

    if (user != null) {
      //delete user's data from firestore
      await DatabaseService().deleteUserInfoFromFirebase(user.uid);

      //delete the users auth record
      await user.delete();
    }
  }

  //sign in with google
  /*SignInwithGoogle() async{
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }*/
}
