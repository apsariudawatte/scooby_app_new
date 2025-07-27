import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scooby_app_new/services/auth_services.dart';
import 'package:scooby_app_new/views/login_screen.dart';

class RegisterPetOwner extends StatefulWidget {
  const RegisterPetOwner({super.key});

  @override
  State<RegisterPetOwner> createState() => _RegisterPetOwnerState();
}

class _RegisterPetOwnerState extends State<RegisterPetOwner> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  File? _image;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerPetOwner() async {
  if (_emailController.text.isEmpty ||
      _passwordController.text.isEmpty ||
      _nameController.text.isEmpty ||
      _phoneController.text.isEmpty ||
      _addressController.text.isEmpty ||
      _cityController.text.isEmpty ||
      _image == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields and pick an image")),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final result = await AuthService().registerPetOwner(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      profileImage: _image,
    );
    if (!mounted) return;

    if (result.user != null) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please log in.')),
      );

      // Navigate to LoginScreen (imported at top)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      // This is unlikely because if user == null, an error should be thrown
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed. Please try again.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register as Pet Owner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone")),
              TextField(controller: _addressController, decoration: const InputDecoration(labelText: "Address")),
              TextField(controller: _cityController, decoration: const InputDecoration(labelText: "City")),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: _image != null
                    ? CircleAvatar(backgroundImage: FileImage(_image!), radius: 40)
                    : const CircleAvatar(radius: 40, child: Icon(Icons.add_a_photo)),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerPetOwner,
                      child: const Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
