import 'dart:developer';

import 'package:dw_delivery_app/app/pages/auth/register/register_state.dart';
import 'package:dw_delivery_app/app/repositories/auth/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterController extends Cubit<RegisterState> {
  RegisterController(this._authRepository) : super(const RegisterState.initial());

  final AuthRepository _authRepository;

  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      emit(state.copyWith(status: RegisterStatus.register));
      await _authRepository.register(
          name: name, email: email, password: password);
      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e, s) {
      log('Error registering user', error: e, stackTrace: s);
      emit(state.copyWith(status: RegisterStatus.error));
    }
  }
}
