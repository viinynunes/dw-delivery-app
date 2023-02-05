import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/pages/home/home_state.dart';
import 'package:dw_delivery_app/app/repositories/products/products_repository.dart';

class HomeController extends Cubit<HomeState> {
  final ProductsRepository _repository;

  HomeController(this._repository) : super(const HomeState.initial());

  Future<void> loadProducts() async {
    emit(state.copyWith(status: HomeStateStatus.loading));

    try {
      final productList = await _repository.findAllProducts();

      emit(state.copyWith(
          status: HomeStateStatus.loaded, productList: productList));
    } catch (e, s) {
      log('Error when finding all products', error: e, stackTrace: s);
      emit(state.copyWith(
        status: HomeStateStatus.error,
        errorMessage: 'Error when finding all products',
      ));
    }
  }

  void addOrUpdateBag(OrderProductDto orderProduct) {
    final shoppingBag = [...state.shoppingBag];
    final orderIndex = shoppingBag
        .indexWhere((element) => element.product == orderProduct.product);

    if (orderIndex > -1) {
      if (orderProduct.amount == 0) {
        shoppingBag.removeAt(orderIndex);
      } else {
        shoppingBag[orderIndex] = orderProduct;
      }
    } else {
      shoppingBag.add(orderProduct);
    }

    emit(state.copyWith(shoppingBag: shoppingBag));
  }

  void updateBag(List<OrderProductDto> updateBag) {
    emit(state.copyWith(shoppingBag: updateBag));
  }
}
