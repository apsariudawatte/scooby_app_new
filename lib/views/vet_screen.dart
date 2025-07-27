import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooby_app_new/views/service_provider_details_screen.dart';
 

class VetScreen extends StatelessWidget {
  const VetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veterinarian Booking')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_providers')
            .where('providerRole', isEqualTo: 'Veterinarian')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No veterinarians found.'));
          }

          final vets = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vets.length,
            itemBuilder: (context, index) {
              final vetData = vets[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(vetData['name'] ?? 'No Name'),
                subtitle: Text(vetData['city'] ?? 'No City'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceProviderDetailsScreen(data: vetData),
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
