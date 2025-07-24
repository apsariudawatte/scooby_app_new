import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterServiceProviderScreen extends StatefulWidget {
  const RegisterServiceProviderScreen({super.key});

  @override
  State<RegisterServiceProviderScreen> createState() =>
      _RegisterServiceProviderScreenState();
}

class _RegisterServiceProviderScreenState
    extends State<RegisterServiceProviderScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedRole;
  String? _selectedCity;
  bool _isLoading = false;

  final List<String> roles = ['Veterinarian', 'Groomer', 'Pet Sitter'];
  final List<String> cities = [
    'Colombo', 'Kandy', 'Galle', 'Jaffna', 'Kurunegala', 'Negombo', 'Matara'
  ];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
      );

      // 2. Save extra info in Firestore
      await FirebaseFirestore.instance.collection('serviceProviders').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'role': _selectedRole,
        'city': _selectedCity,
        'description': _descriptionController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/serviceProviderHome');
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Service Provider Registration'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                onChanged: (val) => setState(() => _selectedRole = val),
                validator: (val) => val == null ? 'Select role' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.length != 10 || int.tryParse(val) == null) {
                    return 'Enter valid 10-digit phone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(labelText: 'City'),
                items: cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                onChanged: (val) => setState(() => _selectedCity = val),
                validator: (val) => val == null ? 'Select city' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val != null && val.length >= 6 ? null : 'Min 6 characters',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description About Yourself'),
                maxLines: 3,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _register,
                      child: const Text('Register as Service Provider'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
