import 'package:flutter/material.dart';
import '../../pages/login_page.dart';
import '../../pages/register_page.dart';

/*
LOGIN OR REGISTER PAGE

This determines wheter to show login or register page
 */
class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
// Initially show login page
  bool showLoginPage = true;

  // Toggle between login & register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

//BUILD UI
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
