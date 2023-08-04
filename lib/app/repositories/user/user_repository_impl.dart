import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_provider/app/core/exception/auth_exception.dart';
import 'package:todo_list_provider/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth}) : this._firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } on FirebaseAuthException catch (err, s) {
      print(err);
      print(s);

      if (err.code == 'email-already-in-use') {
        final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);

        if (loginTypes.contains('password')) {
          throw new AuthException(message: 'E-mail já cadastrado');
        } else {
          throw new AuthException(message: 'E-mail cadastrado pelo Google');
        }
      } else {
        throw new AuthException(message: err.message ?? 'Erro ao cadastrar usuário');
      }
    }
  }
}
