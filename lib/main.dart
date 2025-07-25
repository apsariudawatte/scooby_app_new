import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:scooby_app_new/firebase_options.dart';
import 'package:scooby_app_new/views/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setLanguageCode('en'); // Avoids X-Firebase-Locale warnings
  runApp(const ScoobyApp());
}


class ScoobyApp extends StatelessWidget {
  const ScoobyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scooby App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const Wrapper(),  

/* commented the below for routes management but used
      home: const Wrapper(),  // which decides which screen to show
      initialRoute: '/',  // Splash Screen will show first
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/registerPetOwner': (context) => const RegisterPetOwner(),
        '/registerServiceProvider': (context) => const RegisterServiceProvider(),
        '/petOwnerHome': (context) => const HomeScreen(),  
        '/serviceProviderHome': (context) => const ServiceProviderHomeScreen(),
      },
*/
    );
  }
}
