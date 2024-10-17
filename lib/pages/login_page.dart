import 'package:flutter/material.dart';
import 'package:truckerfinal/components/my_loading_circle.dart';
import 'package:truckerfinal/services/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_text_field.dart';

/*

LOGIN PAGE

ON THIS PAGE, AN EXISTING USER CAN LOGIN WITH THEIR:

- Email
- Password

-----------------------------------------
Once the user successfully logs in, they will be redirected to the home page
If the user doesn't have an account, they can go to register page from here

 */
class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //auth service

  final _auth = AuthService();
//text controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Login method
  void login() async {
    // show loading circle
    showLoadingCircle(context);

    // attempt to login
    try {
      //trying to login
      await _auth.loginEmailPassword(
          emailController.text, passwordController.text);

      //finished loading
      if (mounted) hideLoadingCircle(context);
    }

    // Catch any error
    catch (e) {
      //finished loading
      if (mounted) hideLoadingCircle(context);
      //let user know there was an error
      //let user know the error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

//BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      //BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),
                //Welcome bakc message
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                //email textfield
                MyTextField(
                    controller: emailController,
                    hintText: 'Enter Email',
                    obscureText: false),
                const SizedBox(height: 10),
                //password textfield
                MyTextField(
                    controller: passwordController,
                    hintText: 'Enter Passwod',
                    obscureText: true),
                //forgot password?
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                //sign in button
                MyButton(
                  text: 'Login',
                  onTap: login,
                ),
                const SizedBox(height: 50),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(width: 5),
                    // User can tap on this
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
