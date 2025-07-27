import 'package:flutter/material.dart';
import 'confirm_booking_screen.dart'; // import booking screen

class ServiceProviderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const ServiceProviderDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(data['name'] ?? 'Service Provider')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (data['imageUrl'] != null)
              Image.network(data['imageUrl'], height: 200),
            const SizedBox(height: 16),
            Text(
              '${data['name']}\n'
              '${data['providerRole']}\n'
              '${data['experience']} experience\n'
              '${data['description'] ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text('Email: ${data['email']}'),
            Text('Phone: ${data['phone']}'),
            Text('City: ${data['city']}'),
            Text('Address: ${data['address']}'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ConfirmBookingScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                ),
                child: const Text('Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
