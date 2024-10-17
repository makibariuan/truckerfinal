import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truckerfinal/components/navigate.dart';
import 'package:truckerfinal/services/auth/login_or_register.dart';

/*
AUTH GATE

This is to check  if the user is logged in or not

------------------------------------------------------------------------

if user is logged in -> go to home page
if user is not logged in -> go to login or register page
 */

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return const FirstPage();
          }
          // user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
