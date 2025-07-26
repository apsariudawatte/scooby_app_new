import 'package:flutter/material.dart';
import 'package:scooby_app_new/controllers/home_controller.dart';
import 'package:scooby_app_new/views/adoption_screen.dart';
import 'package:scooby_app_new/views/community_screen.dart';
import 'package:scooby_app_new/views/pet_owner_profile_screen.dart';

import 'package:scooby_app_new/views/services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('Welcome')), 
    const ServicesScreen(),
    const AdoptionScreen(),
    const CommunityScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller.fetchPetOwnerData();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PetOwnerProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0DAD),
        title: StreamBuilder<String>(
          stream: _controller.ownerNameStream,
          builder: (context, snapshot) {
            final name = snapshot.data ?? 'Scooby';
            return Text('Welcome, $name');
          },
        ),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
          ),
          onPressed: _goToProfile,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _controller.showLogoutDialog(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF6A0DAD),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Adoption'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
        ],
      ),
    );
  }
}
