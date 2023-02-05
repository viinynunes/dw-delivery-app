import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dw_delivery_app/app/dto/order_dto.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/repositories/order/order_repository.dart';
import 'package:flutter/src/widgets/editable_text.dart';

import 'order_state.dart';

class OrderController extends Cubit<OrderState> {
  OrderController(this._orderRepository) : super(const OrderState.initial());

  final OrderRepository _orderRepository;

  void load(List<OrderProductDto> orderProducts) async {
    try {
      emit(state.copyWith(status: OrderStatus.loading));

      final paymentTypes = await _orderRepository.getAllPaymentsType();

      emit(state.copyWith(
        orderProducts: orderProducts,
        status: OrderStatus.loaded,
        paymentTypes: paymentTypes,
      ));
    } catch (e, s) {
      log('Erro ao carregar a pagina', error: e, stackTrace: s);
      emit(state.copyWith(
          status: OrderStatus.error,
          errorMessage: 'Erro ao carregar a pagina'));
    }
  }

  void incrementProduct(int index) {
    final orders = [...state.orderProducts];

    final order = orders[index];

    orders[index] = order.copyWith(amount: order.amount + 1);

    emit(
        state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void decrementProduct(int index) {
    final orders = [...state.orderProducts];
    final order = orders[index];
    final amount = order.amount;

    if (amount == 1) {
      if (state.status != OrderStatus.confirmRemoveProduct) {
        emit(
          OrderConfirmDeleteProductState(
              status: OrderStatus.confirmRemoveProduct,
              orderProducts: state.orderProducts,
              paymentTypes: state.paymentTypes,
              orderProduct: order,
              index: index),
        );
        return;
      } else {
        orders.removeAt(index);
      }
    } else {
      orders[index] = order.copyWith(amount: order.amount - 1);
    }

    if (orders.isEmpty) {
      emit(state.copyWith(status: OrderStatus.emptyBag));
    }

    emit(
        state.copyWith(orderProducts: orders, status: OrderStatus.updateOrder));
  }

  void cancelDeleteProcess() {
    emit(state.copyWith(status: OrderStatus.loaded));
  }

  void emptyBag() {
    emit(state.copyWith(status: OrderStatus.emptyBag));
  }

  Future<void> saveOrder(
      {required TextEditingController address,
      required TextEditingController document,
      required int paymentMethodId}) async {
    emit(state.copyWith(status: OrderStatus.loading));

    await _orderRepository.saveOrder(
      OrderDto(
          products: state.orderProducts,
          address: address.text,
          document: document.text,
          paymentMethodId: paymentMethodId),
    );
    emit(state.copyWith(status: OrderStatus.success));

  }
}
