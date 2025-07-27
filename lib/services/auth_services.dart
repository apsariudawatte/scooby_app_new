import 'dart:developer';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signInWithPassword(email: email, password: password);
      return res;
    } catch (e) {
      log('Login error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> registerPetOwner({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String email,
    required String password,
    File? profileImage,
  }) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final user = res.user;
      if (user == null) throw Exception('User creation failed');

      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadImage(user.id, profileImage, 'pet_owners');
      }

      await _client.from('pet_owners').insert({
        'user_id': user.id,
        'name': name,
        'phone_number': phone,
        'address': address,
        'city': city,
        'email': email,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });
      return res;
    } catch (e) {
      log('Register PetOwner error: $e');
      rethrow;
    }
  }

  Future<AuthResponse> registerServiceProvider({
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
  }) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final user = res.user;
      if (user == null) throw Exception('User creation failed');

      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadImage(user.id, profileImage, 'service_providers');
      }

      await _client.from('service_providers').insert({
        'user_id': user.id,
        'name': name,
        'phone_no': phone,
        'address': address,
        'city': city,
        'email': email,
        'role': role,
        'service_description': description,
        'experience': experience,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      return res;
    } catch (e) {
      log('Register ServiceProvider error: $e');
      rethrow;
    }
  }

  Future<String> _uploadImage(String userId, File file, String folder) async {
    final String fileName = '${const Uuid().v4()}.jpg';
    final path = '$folder/$userId/$fileName';
    final bytes = await file.readAsBytes();

    final storageRes = await _client.storage.from('profile_images').uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(contentType: 'image/jpeg'),
    );

    if (storageRes.isEmpty) throw Exception('Image upload failed');

    final publicUrl = _client.storage.from('profile_images').getPublicUrl(path);
    return publicUrl;
  }
}
