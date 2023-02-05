import 'package:dw_delivery_app/app/models/auth_model.dart';

abstract class AuthRepository {
  Future<void> register(
      {required String name, required String email, required String password});

  Future<AuthModel> login({required String email, required String password});
}
