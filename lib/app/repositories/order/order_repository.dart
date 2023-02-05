import 'package:dw_delivery_app/app/dto/order_dto.dart';

import '../../models/payment_type_model.dart';

abstract class OrderRepository {
  Future<List<PaymentTypeModel>> getAllPaymentsType();

  Future<void> saveOrder(OrderDto order);
}
