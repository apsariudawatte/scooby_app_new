import '../services/auth_services.dart';

class PetOwnerController {
  final AuthService _authService = AuthService();

  Future register({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String email,
    required String password,
  }) {
    return _authService.registerPetOwner(
      name: name,
      phone: phone,
      address: address,
      city: city,
      email: email,
      password: password,
      profileImage: null,
    );
  }
}
