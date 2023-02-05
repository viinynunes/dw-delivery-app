import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dw_delivery_app/app/core/exceptions/unautorized_exception.dart';
import 'package:dw_delivery_app/app/pages/auth/login/login_state.dart';
import 'package:dw_delivery_app/app/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends Cubit<LoginState> {
  LoginController(this._authRepository) : super(const LoginState.initial());

  final AuthRepository _authRepository;

  Future<void> login({required String email, required String password}) async {
    try {
      emit(state.copyWith(status: LoginStatus.login));

      final authModel =
          await _authRepository.login(email: email, password: password);

      final sp = await SharedPreferences.getInstance();

      sp.setString('accessToken', authModel.accessToken);
      sp.setString('refreshToken', authModel.refreshToken);

      emit(state.copyWith(status: LoginStatus.success));
    } on UnautorizedException catch (e, s) {
      log('User not autorized', error: e, stackTrace: s);
      emit(state.copyWith(
          status: LoginStatus.error, errorMessage: 'Login ou senha inválidos'));
    } catch (e, s) {
      log('User not autorized', error: e, stackTrace: s);
      emit(state.copyWith(
          status: LoginStatus.error, errorMessage: 'Erro ao realizar o login'));
    }
  }
}
