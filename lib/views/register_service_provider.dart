import 'package:flutter/material.dart';

class RegisterServiceProviderScreen extends StatefulWidget {
  const RegisterServiceProviderScreen({super.key});

  @override
  State<RegisterServiceProviderScreen> createState() =>
      _RegisterServiceProviderScreenState();
}

class _RegisterServiceProviderScreenState
    extends State<RegisterServiceProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

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
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (val) => setState(() => email = val),
                validator: (val) =>
                    val != null && val.contains('@') ? null : 'Enter valid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (val) => setState(() => password = val),
                validator: (val) =>
                    val != null && val.length >= 6 ? null : 'Min 6 characters',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                   
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registering...')),
                    );
                  }
                },
                child: const Text('Register as Service Provider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
