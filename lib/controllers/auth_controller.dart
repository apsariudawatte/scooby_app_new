import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userChanges => _auth.authStateChanges();

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  String? getUserId() {
    return _auth.currentUser?.uid;
  }
}
