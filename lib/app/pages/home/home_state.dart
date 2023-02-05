import 'package:equatable/equatable.dart';
import 'package:match/match.dart';

import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/models/product_model.dart';

part 'home_state.g.dart';

@match
enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  final HomeStateStatus status;
  final List<ProductModel> productList;
  final List<OrderProductDto> shoppingBag;
  final String? errorMessage;

  const HomeState({
    required this.status,
    required this.productList,
    required this.errorMessage,
    required this.shoppingBag
  });

  const HomeState.initial()
      : status = HomeStateStatus.initial,
        productList = const [],
        shoppingBag = const [],
        errorMessage = null;

  @override
  List<Object?> get props => [status, productList, errorMessage, shoppingBag];

  HomeState copyWith({
    HomeStateStatus? status,
    List<ProductModel>? productList,
    String? errorMessage,
    List<OrderProductDto>? shoppingBag,
  }) {
    return HomeState(
      status: status ?? this.status,
      productList: productList ?? this.productList,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingBag: shoppingBag ?? this.shoppingBag,
    );
  }
}
