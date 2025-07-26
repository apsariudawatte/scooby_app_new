import 'package:flutter/material.dart';

class SitterScreen extends StatelessWidget {
  const SitterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Sitter Booking')),
      body: const Center(child: Text('Find and book a pet sitter.')),
    );
  }
}
