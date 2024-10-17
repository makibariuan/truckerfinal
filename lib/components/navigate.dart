import 'package:flutter/material.dart';
import 'package:truckerfinal/components/navbar.dart';
import 'package:truckerfinal/pages/home_page.dart';
import 'package:truckerfinal/pages/tracks.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [const Tracks(), const HomePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[selectedIndex],
    );
  }
}
