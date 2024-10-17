import 'package:flutter/material.dart';
import 'package:truckerfinal/components/my_loading_circle.dart';
import 'package:truckerfinal/services/auth/auth_service.dart';
import 'package:truckerfinal/services/database/database_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

/*
REGISTER PAGE

On this page a user can fill out the form and create an account

The data we want from the user is:

- name
- email
- password
- confirm password

-----------------------------------------------------

Once the user successfully created an account -> they will be redirected to homepage

Also, if the user already has an account, they can go to login page from here.
 */
class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({
    super.key,
    this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // access auth and db service
  final _auth = AuthService();
  final _db = DatabaseService();

  //text controller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

// register button tapped
  void register() async {
    // password match -> creates user
    if (passwordController.text == confirmPasswordController.text) {
      //show loading circle
      showLoadingCircle(context);

      //attempt to register the user
      try {
        //trying to register
        await _auth.registerEmailPassword(
          emailController.text,
          passwordController.text,
        );

        //finished loading
        if (mounted) hideLoadingCircle(context);

        // once user is registered, create and save user profile in database
        await _db.saveUserInfoInFirebase(
            name: nameController.text, email: emailController.text);
      }
      //catch any errors
      catch (e) {
        //finished loading
        if (mounted) hideLoadingCircle(context);

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
    // password don't match -> show error

    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match"),
        ),
      );
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
            child: SingleChildScrollView(
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
                  //CREATE AN ACCOUNT
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                      controller: nameController,
                      hintText: 'Enter name',
                      obscureText: false),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true),
                  const SizedBox(height: 10),

                  //sign up button
                  MyButton(
                    text: 'Register',
                    onTap: register,
                  ),
                  const SizedBox(height: 50),
                  // already a member?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      const SizedBox(width: 5),
                      // User can tap on this to go to login page
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login Now',
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
      ),
    );
  }
}
