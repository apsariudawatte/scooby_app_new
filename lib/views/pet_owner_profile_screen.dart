import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scooby_app_new/models/pet_owner_model.dart';

class PetOwnerProfileScreen extends StatelessWidget {
  const PetOwnerProfileScreen({super.key});

  Future<PetOwner?> _fetchPetOwner() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('pet_owners').doc(uid).get();

    if (doc.exists) {
      return PetOwner.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF6A0DAD),
      ),
      body: FutureBuilder<PetOwner?>(
        future: _fetchPetOwner(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text("No user data found."));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
                const SizedBox(height: 20),
                Text("Name: ${user.name}", style: const TextStyle(fontSize: 18)),
                Text("Email: ${user.email}", style: const TextStyle(fontSize: 18)),
                Text("Phone: ${user.phone}", style: const TextStyle(fontSize: 18)),
                Text("City: ${user.city}", style: const TextStyle(fontSize: 18)),
                Text("Address: ${user.address}", style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
