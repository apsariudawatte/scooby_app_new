import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:scooby_app_new/services/auth_services.dart';

class RegisterPetOwner extends StatefulWidget {
  const RegisterPetOwner({super.key});

  @override
  State<RegisterPetOwner> createState() => _RegisterPetOwnerState();
}

class _RegisterPetOwnerState extends State<RegisterPetOwner> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  // ignore: unused_field
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  File? _image;
  final List<String> _cities = [
    'Colombo', 'Kandy', 'Galle', 'Jaffna', 'Anuradhapura', 'Kurunegala'
  ];
  String? _selectedCity;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _register() async {
  if (_formKey.currentState!.validate() && _image != null) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = await _authService.registerPetOwner(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _selectedCity ?? '',
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        profileImage: _image!,
      );

      if (!mounted) return;
      Navigator.pop(context); // Remove loading indicator

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Try again.')),
        );
      }
    } catch (e, stacktrace) {
      Navigator.pop(context); // Remove loading indicator if error

      print('Registration error: $e');
      print('Stacktrace: $stacktrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields and select an image.')),
    );
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
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? const Icon(Icons.add_a_photo) : null,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (val) {
                  if (val == null || val.length != 10 || int.tryParse(val) == null) {
                    return 'Enter valid 10-digit number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedCity,
                items: _cities
                    .map((city) => DropdownMenuItem(
                        value: city, child: Text(city)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCity = val),
                decoration: const InputDecoration(labelText: 'Main City'),
                validator: (val) => val == null ? 'Select city' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val == null || !val.contains('@') ? 'Invalid email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val != null && val.length < 8 ? 'Min 8 characters' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}