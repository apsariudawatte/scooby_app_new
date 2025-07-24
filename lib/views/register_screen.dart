import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPetOwner extends StatefulWidget {
  const RegisterPetOwner({super.key});
  @override
  State<RegisterPetOwner> createState() => _RegisterPetOwnerState();
}

class _RegisterPetOwnerState extends State<RegisterPetOwner> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedCity;
  bool _isLoading = false;

  final List<String> _cities = ['Colombo', 'Kandy', 'Galle', 'Jaffna', 'Anuradhapura', 'Kurunegala'];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
      );

      // 2. Save extra info in Firestore
      await FirebaseFirestore.instance.collection('petOwners').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity,
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/petOwnerHome');
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Pet Owner')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (val) => val == null || val.isEmpty ? 'Required' : null),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, validator: (val) => val == null || val.length != 10 ? 'Enter 10-digit phone' : null),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address'), validator: (val) => val == null || val.isEmpty ? 'Required' : null),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                onChanged: (val) => setState(() => _selectedCity = val),
                validator: (val) => val == null ? 'Select city' : null,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email'), validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null),
              TextFormField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true, validator: (val) => val != null && val.length >= 8 ? null : 'Min 8 characters'),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _register, child: const Text('Register')),
            ],
          ),
        ),
      ),
    );
  }
}
