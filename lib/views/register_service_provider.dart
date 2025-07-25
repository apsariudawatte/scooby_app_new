import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooby_app_new/views/login_screen.dart';

class RegisterServiceProvider extends StatefulWidget {
  const RegisterServiceProvider({super.key});

  @override
  State<RegisterServiceProvider> createState() => _RegisterServiceProviderState();
}

class _RegisterServiceProviderState extends State<RegisterServiceProvider> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();

  File? _selectedImage;
  File? _selectedQualification;
  String? _selectedCity;

  final List<String> _cities = ['Colombo', 'Kandy', 'Galle', 'Jaffna'];

  Future<void> _pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _pickQualificationFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedQualification = File(picked.path));
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null || _selectedQualification == null || _selectedCity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fields including image, qualification and city.')),
        );
        return;
      }

      try {
        final auth = FirebaseAuth.instance;
        final userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final uid = userCredential.user!.uid;

        final profileRef = FirebaseStorage.instance.ref('profiles/$uid.jpg');
        await profileRef.putFile(_selectedImage!);
        final profileUrl = await profileRef.getDownloadURL();

        final qualificationRef = FirebaseStorage.instance.ref('qualifications/$uid.jpg');
        await qualificationRef.putFile(_selectedQualification!);
        final qualificationUrl = await qualificationRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'role': 'service_provider',
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
          'email': _emailController.text.trim(),
          'city': _selectedCity,
          'description': _descriptionController.text.trim(),
          'experience': _experienceController.text.trim(),
          'profileImage': profileUrl,
          'qualificationFile': qualificationUrl,
        });

        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register as Service Provider")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Phone is required' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Address is required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(labelText: 'City'),
                items: _cities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
                validator: (value) => value == null ? 'City is required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) => value!.length < 6 ? 'Password must be 6+ chars' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Service Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Description required' : null,
              ),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Experience'),
                validator: (value) => value!.isEmpty ? 'Experience required' : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickProfileImage,
                child: const Text('Upload Profile Image'),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(_selectedImage!, height: 100),
                ),
              ElevatedButton(
                onPressed: _pickQualificationFile,
                child: const Text('Upload Qualification File'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  child: const Text("Register"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
