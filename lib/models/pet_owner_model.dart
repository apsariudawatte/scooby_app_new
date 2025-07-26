class PetOwner {
  final String uid;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String email;
  final String role;

  PetOwner({
    required this.uid,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.email,
    this.role = 'pet_owner',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'email': email,
      'role': role,
    };
  }

  factory PetOwner.fromMap(Map<String, dynamic> map) {
    return PetOwner(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'pet_owner',
    );
  }
}
