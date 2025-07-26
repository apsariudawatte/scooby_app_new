import 'package:flutter/material.dart';

class GroomerScreen extends StatelessWidget {
  const GroomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Groomer Booking')),
      body: const Center(child: Text('Schedule a pet grooming session.')),
    );
  }
}
