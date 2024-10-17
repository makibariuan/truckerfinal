import 'package:flutter/material.dart';

/*
USER BIO BOX

This is a simple box with text inside. We will use this for user bio on their 
profile pages.

-------------------------------------------------------------------------------

To use this widget, you just need:

- text


 */

class MyBioBox extends StatelessWidget {
  final String text;
  const MyBioBox({
    super.key,
    required this.text,
  });

// BUILD UI
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding outside
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      // Padding inside
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          //Color
          color: Theme.of(context).colorScheme.secondary,
          // curve corner
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        text.isNotEmpty ? text : "Empty Bio",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}
