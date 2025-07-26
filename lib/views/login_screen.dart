// ignore_for_file: use_build_context_synchronously


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scooby_app_new/services/auth_services.dart';
import 'package:scooby_app_new/services/google_auth_service.dart';
import 'package:scooby_app_new/views/home_screen.dart';
import 'package:scooby_app_new/views/register_pet_owner.dart';
import 'package:scooby_app_new/views/register_service_provider.dart';
import 'package:scooby_app_new/views/service_provider_home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  bool _isLoading = false;

  
  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);

    final user = await _googleAuthService.signInWithGoogle();

    setState(() => _isLoading = false);

    if (user != null) {
      if (!mounted) return;

      // Show popup dialog with logged in email
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Successful'),
          content: Text('Logged in as ${user.email ?? 'Unknown'}'),
        ),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/petOwnerHome');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In failed')),
        );
      }
    }
  }

  Future<void> _loginAndRoute(User user) async {
  try {
    final petOwnerDoc = await FirebaseFirestore.instance
        .collection('pet_owners')
        .doc(user.uid)
        .get();

    final serviceProviderDoc = await FirebaseFirestore.instance
        .collection('service_providers')
        .doc(user.uid)
        .get();

    if (petOwnerDoc.exists) {
      // Navigate to Pet Owner Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (serviceProviderDoc.exists) {
      // Navigate to Service Provider Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ServiceProviderHomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found in either collection.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error retrieving user role: $e")),
    );
  }
}

  

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Scooby Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Welcome to Scooby Pet Care',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val != null && val.contains('@')
                    ? null
                    : 'Please enter a valid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val != null && val.length >= 8
                    ? null
                    : 'Password must be at least 8 characters',
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);

                        try {
                          final UserCredential userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          final user = userCredential.user;

                          if (user != null) {
                            await _loginAndRoute(user);
                          }
                        } on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message ?? 'Login failed')),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 20),
              const Text('OR'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Navigate to Pet Owner Register Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterPetOwner(),
                    ),
                  );
                },
                child: const Text('Register as Pet Owner'),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to Service Provider Register Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterServiceProvider(),
                    ),
                  );
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
