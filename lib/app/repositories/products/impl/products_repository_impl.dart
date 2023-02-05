import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dw_delivery_app/app/models/product_model.dart';

import '../../../core/exceptions/repository_exception.dart';
import '../products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;

  ProductsRepositoryImpl({required this.dio});

  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.unauth().get('/products');
      return result.data
          .map<ProductModel>((p) => ProductModel.fromMap(p))
          .toList();
    } on DioError catch (e) {
      log('Error when find unauth products');
      throw RepositoryException('Error when find products - $e');
    }
  }
}
