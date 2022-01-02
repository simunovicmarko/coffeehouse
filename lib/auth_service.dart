import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Successfull";
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
