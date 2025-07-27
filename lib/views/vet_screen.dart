import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooby_app_new/views/service_provider_details_screen.dart';

class VetScreen extends StatelessWidget {
  const VetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Veterinarian Booking'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('service_providers')
            .where('providerRole', isEqualTo: 'Veterinarian')
            .where('status', isEqualTo: 'approved') // ✅ Important fix
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No approved veterinarians found.'));
          }

          final vets = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vets.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final vetData = vets[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.deepPurple[100],
                    child: const Icon(Icons.pets, color: Colors.white, size: 30),
                  ),
                  title: Text(
                    vetData['name'] ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
