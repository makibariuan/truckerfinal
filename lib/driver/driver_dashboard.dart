import 'package:flutter/material.dart';
import 'package:truckerfinal/components/my_drawer.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("welcome driver")),
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
