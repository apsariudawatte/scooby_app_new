// register_service_provider.dart
import 'package:flutter/material.dart';

class RegisterServiceProvider extends StatefulWidget {
  const RegisterServiceProvider({super.key});

  @override
  State<RegisterServiceProvider> createState() => _RegisterServiceProviderState();
}

class _RegisterServiceProviderState extends State<RegisterServiceProvider> {
  final _formKey = GlobalKey<FormState>();

  final List<String> roles = ['Veterinarian', 'Groomer', 'Pet Sitter'];
  final List<String> cities = [
    'Colombo', 'Kandy', 'Galle', 'Jaffna', 'Kurunegala', 'Negombo', 'Matara'
  ];

  String? _selectedRole;
  String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create An Account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.add_a_photo, size: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  hint: const Text('Role'),
                  onChanged: (value) => setState(() => _selectedRole = value),
                  validator: (value) => value == null ? 'Role is required' : null,
                  items: roles
                      .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Phone number required';
                    if (!RegExp(r'^\d{10}\$').hasMatch(value)) return 'Enter 10 digit number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) => value!.isEmpty ? 'Address is required' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  hint: const Text('Main City'),
                  onChanged: (value) => setState(() => _selectedCity = value),
                  validator: (value) => value == null ? 'City is required' : null,
                  items: cities
                      .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || !value.contains('@')) return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) => value != null && value.length >= 8 ? null : 'Min 8 characters',
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description About Yourself'),
                  validator: (value) => value!.isEmpty ? 'Description required' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.file_upload),
                    const SizedBox(width: 8),
                    const Text('Upload Qualification (PDF or Image)', style: TextStyle(fontSize: 14)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Browse'),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Experience'),
                  validator: (value) => value!.isEmpty ? 'Experience required' : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration Pending Approval by Admin')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B0082),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                  ),
                  child: const Text('Register', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}