import 'package:flutter/material.dart';
import 'package:truckerfinal/components/my_drawer.dart';

class Tracks extends StatefulWidget {
  const Tracks({super.key});

  @override
  State<Tracks> createState() => _TracksState();
}

class _TracksState extends State<Tracks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("MAP HERE")),
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'T R U C K E R',
          style: TextStyle(
            color: Color(0xFF6D9886),
          ),
        ),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
