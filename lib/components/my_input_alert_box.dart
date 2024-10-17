import 'package:flutter/material.dart';

/*
INPUT ALERT BOX

This is an alert dialog box that has a textfield where the user can type in. We
will use this for things like editing bio, posting message and etc.

------------------------------------------------------------------------------

To use this widget, you need:
- text controller (to access what the user type)
- hint text (e.g empty bio)
- a function (e.g. savebio())
- text for button (e.g. "Save")

 */
class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textcontroller;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({
    super.key,
    required this.textcontroller,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
  });

// BUILD UI
  @override
  Widget build(BuildContext context) {
    //alert dialog
    return AlertDialog(
      // curver corner
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      // color
      backgroundColor: Theme.of(context).colorScheme.surface,

      // textfield (user types here)
      content: TextField(
        controller: textcontroller,
        // limit text characters
        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
          // border when textfield is unselected
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),

          // border when textfield is selected
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),

          // hint text
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

          // color inside of text field
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          // counter style
          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      // buttons
      actions: [
        // cancel button
        TextButton(
          onPressed: () {
            // close the box
            Navigator.pop(context);
            // clear controller
            textcontroller.clear();
          },
          child: const Text("Cancel"),
        ),
        // save button
        TextButton(
          onPressed: () {
            // close box
            Navigator.pop(context);

            // execute the function
            onPressed!();

            // clear controller
            textcontroller.clear();
          },
          child: const Text("Save"),
        )
      ],
    );
  }
}
