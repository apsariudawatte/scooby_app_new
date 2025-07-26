import 'package:flutter/material.dart';
//import 'package:scooby/screens/service_provider_details_screen';

class VetScreen extends StatelessWidget {
  const VetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veterinarian Booking')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Navigator.push(
            //  context,
            //  MaterialPageRoute(
              //  builder: (_) => const ServiceProviderDetailsScreen(),
             // ),
          //  );
          },
          child: const Text('Select'),
        ),
      ),
    );
  }
}
