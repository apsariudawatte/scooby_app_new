import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  get stacktrace => null;

 
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      ('Login Error: $e');
      return null;
    }
  }

  //  Register Pet Owner
  Future<User?> registerPetOwner({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String email,
    required String password,
    required File profileImage,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        String imageUrl = await _uploadImage(user.uid, profileImage);

        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'role': 'pet_owner',
          'name': name,
          'phone': phone,
          'address': address,
          'city': city,
          'email': email,
          'imageUrl': imageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        return user;
      }
    } catch (e) {
       log('Register PetOwner Error: $e');
      log('Stacktrace: $stacktrace');
}
    return null;
  } 

  //  Register Service Provider
  Future<User?> registerServiceProvider({
    required String name,
    required String role,
    required String phone,
    required String address,
    required String city,
    required String email,
    required String password,
    required String description,
    required String experience,
    File? profileImage,
    File? qualificationFile,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        String? imageUrl;
        String? qualificationUrl;

        if (profileImage != null) {
          imageUrl = await _uploadImage(user.uid, profileImage);
        }

        if (qualificationFile != null) {
          qualificationUrl = await _uploadFile(user.uid, qualificationFile);
        }

        await _firestore.collection('service_providers').doc(user.uid).set({
          'uid': user.uid,
          'role': 'service_provider',
          'name': name,
          'providerRole': role,
          'phone': phone,
          'address': address,
          'city': city,
          'email': email,
          'description': description,
          'experience': experience,
          'imageUrl': imageUrl,
          'qualificationUrl': qualificationUrl,
          'status': 'pending', // Admin approval pending
          'createdAt': FieldValue.serverTimestamp(),
        });

        return user;
      }
    } catch (e) {
      ('Register ServiceProvider Error: $e');
    }
    return null;
  }

  //  Image Upload Helper
  Future<String> _uploadImage(String uid, File file) async {
    final ref = _storage.ref().child('profile_images/$uid.jpg');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // File Upload Helper
  Future<String> _uploadFile(String uid, File file) async {
    final ref = _storage.ref().child('qualifications/$uid-${file.path.split('/').last}');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
