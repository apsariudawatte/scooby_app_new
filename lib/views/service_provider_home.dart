import 'package:flutter/material.dart';

class ServiceProviderHomeScreen extends StatelessWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Home'),
      ),
      body: const Center(
        child: Text(
          'Welcome, Service Provider!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
