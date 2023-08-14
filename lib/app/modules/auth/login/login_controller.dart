// change notifier
import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/exception/auth_exception.dart';
import 'package:todo_list_provider/app/core/ui/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({required UserService userService}) : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> googleLogin() async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      final user = await _userService.googleLogin();

      if (user != null) {
        success();
      } else {
        _userService.logout();
        setError('Erro ao realizar login com o google');
      }
    } on AuthException catch (err) {
      _userService.logout();
      setError(err.message);
    } finally {
      hideLoading();

      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      final user = await _userService.login(email, password);

      if (user != null) {
        success();
      } else {
        setError('Usuário ou senha inválidos');
      }
    } on AuthException catch (err) {
      setError(err.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      infoMessage = null;
      showLoadingAndResetState();
      notifyListeners();

      await _userService.forgotPassword(email);
      infoMessage = 'Reset de senha enviado para seu email';
    } on AuthException catch (err) {
      setError(err.message);
    } catch (err) {
      setError('Erro ao resetar senha');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
