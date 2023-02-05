import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw_delivery_app/app/core/exceptions/repository_exception.dart';
import 'package:dw_delivery_app/app/core/exceptions/unautorized_exception.dart';
import 'package:dw_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dw_delivery_app/app/models/auth_model.dart';

import './auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CustomDio dio;

  AuthRepositoryImpl({required this.dio});

  @override
  Future<AuthModel> login(
      {required String email, required String password}) async {
    try {
      final result = await dio.unauth().post('/auth', data: {
        'email': email,
        'password': password,
      });

      return AuthModel.fromMap(result.data);
    } on DioError catch (e, s) {
      if (e.response?.statusCode == 403) {
        log('Permissao negada', error: e, stackTrace: s);
        throw UnautorizedException();
      }

      log('Login Error', error: e, stackTrace: s);
      throw RepositoryException('Login Error');
    }
  }

  @override
  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await dio.unauth().post('/users',
          data: {'name': name, 'email': email, 'password': password});
    } on DioError catch (e, s) {
      log('Register user error', error: e, stackTrace: s);
      throw RepositoryException('Register user error');
    }
  }
}
