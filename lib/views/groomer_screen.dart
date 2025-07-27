import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service_provider_details_screen.dart'; // Shared detail screen

class GroomerScreen extends StatelessWidget {
  const GroomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Groomer Booking')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_providers')
            .where('providerRole', isEqualTo: 'Pet Groomer')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No groomers found.'));
          }

          final groomers = snapshot.data!.docs;

          return ListView.builder(
            itemCount: groomers.length,
            itemBuilder: (context, index) {
              final groomerData = groomers[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(groomerData['name'] ?? 'No Name'),
                subtitle: Text(groomerData['city'] ?? 'No City'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceProviderDetailsScreen(data: groomerData),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
