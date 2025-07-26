import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'service_provider_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  Future<String?> getUserRole(String uid) async {
    final petOwnerDoc = await FirebaseFirestore.instance.collection('pet_owners').doc(uid).get();
    if (petOwnerDoc.exists) return 'pet_owner';

    final serviceProviderDoc = await FirebaseFirestore.instance.collection('service_providers').doc(uid).get();
    if (serviceProviderDoc.exists) return 'service_provider';

    return null; // user not found in either collection
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          } else {
            return FutureBuilder<String?>(
              future: getUserRole(user.uid),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final role = roleSnapshot.data;

                if (role == 'service_provider') {
                  return const ServiceProviderHomeScreen();
                } else if (role == 'pet_owner') {
                  return const HomeScreen();
                } else {
                  // User not found in either collection, force logout or show error
                  return const LoginScreen();
                }
              },
            );
          }
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
