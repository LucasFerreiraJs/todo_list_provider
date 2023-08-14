import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (err, s) {
      print(err);
      print(s);

      throw AuthException(message: err.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (err, s) {
      print(err);
      print(s);

      if (err.code == 'wrong-password') {
        throw AuthException(message: 'Email ou Senha inválidos');
      }
      throw AuthException(message: err.message ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(message: 'Cadastro realizado com o google');
      } else {
        throw AuthException(message: 'Email não cadastrado');
      }
    } on PlatformException catch (err, s) {
      print(err);
      print(s);
      throw AuthException(message: 'Erro ao resetar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSingIn = GoogleSignIn();
      final googleUser = await googleSingIn.signIn();
      if (googleUser != null) {
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);

        if (loginMethods.contains('password')) {
          throw AuthException(message: 'E-mail ja utilizado em outro cadastro, clique em "Esqueci a senha" para recuperar seu acesso');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          var userCredencial = await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredencial.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(message: '''Login não permitido, talvez você tenha se registrado com outro provedor!
                Algumas possibilidades:
                ${loginMethods?.join(',')}
                ''');
      } else {
        throw AuthException(message: 'Erro ao realizar login');
      }
    }
  }
}
