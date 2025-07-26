import 'package:flutter/material.dart';
import 'package:scooby_app_new/services/auth_services.dart';

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
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _roles = ['Veterinarian', 'Pet Sitter', 'Pet Groomer'];
  String? _selectedRole;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a role')),
        );
        return;
      }

      final user = await AuthService().registerServiceProvider(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        city: _cityController.text,
        email: _emailController.text,
        password: _passwordController.text,
        // Removed profileImage here
        role: _selectedRole!,
        experience: _experienceController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (user != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully. Please log in.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register as Service Provider')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Removed image picker widget here

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Phone number is required' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) => value!.isEmpty ? 'Address is required' : null,
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  validator: (value) => value!.isEmpty ? 'City is required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Service Role'),
                  items: _roles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedRole = value),
                  validator: (value) => value == null ? 'Role is required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Service Description'),
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Description is required' : null,
                ),
                TextFormField(
                  controller: _experienceController,
                  decoration: const InputDecoration(labelText: 'Experience (e.g. 2 years)'),
                  validator: (value) => value!.isEmpty ? 'Experience is required' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty ? 'Email is required' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
