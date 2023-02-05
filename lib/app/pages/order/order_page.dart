import 'package:dw_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw_delivery_app/app/core/ui/base_state/base_state.dart';
import 'package:dw_delivery_app/app/core/ui/styles/text_styles.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_app_bar.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw_delivery_app/app/dto/order_dto.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/models/payment_type_model.dart';
import 'package:dw_delivery_app/app/pages/order/order_controller.dart';
import 'package:dw_delivery_app/app/pages/order/order_state.dart';
import 'package:dw_delivery_app/app/pages/order/widget/payments_types_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import 'widget/order_field.dart';
import 'widget/order_product_tile.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final documentController = TextEditingController();
  int? paymentTypeId;
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    super.onReady();

    final orderProducts =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;

    controller.load(orderProducts);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
            'Deseja excluir o produto ${state.orderProduct.product.name}?'),
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.of(context).pop();
              controller.cancelDeleteProcess();
            }),
            child: Text(
              'Cancelar',
              style: context.textStyles.textBold.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.decrementProduct(state.index);
            },
            child: Text(
              'Confirmar',
              style: context.textStyles.textBold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: ((context, state) {
        state.status.matchAny(
          any: (() => hideLoader()),
          loading: () => showLoader(),
          error: (() {
            hideLoader();
            showError(message: state.errorMessage ?? 'Erro não informado');
          }),
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            hideLoader();
            showInfo(
                message:
                    'Sua sacola esta vazia, por favor selecione um produto para realizar um pedido');
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            hideLoader();
            Navigator.of(context).popAndPushNamed('/order/completed',
                result: <OrderProductDto>[]);
          },
        );
      }),
      child: WillPopScope(
        onWillPop: (() async {
          Navigator.pop(context, controller.state.orderProducts);
          return false;
        }),
        child: Scaffold(
          appBar: DeliveryAppBar(),
          body: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Carrinho',
                          style: context.textStyles.textTitle,
                        ),
                        IconButton(
                            onPressed: controller.emptyBag,
                            icon: Image.asset('assets/images/trashRegular.png'))
                      ],
                    ),
                  ),
                ),
                BlocSelector<OrderController, OrderState,
                    List<OrderProductDto>>(
                  selector: (state) => state.orderProducts,
                  builder: (context, orderProducts) => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = orderProducts[index];

                        return Column(
                          children: [
                            OrderProductTile(
                              index: index,
                              orderProduct: product,
                            ),
                            const Divider(
                              color: Colors.grey,
                            )
                          ],
                        );
                      },
                      childCount: orderProducts.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total do pedido',
                              style: context.textStyles.textExtraBold
                                  .copyWith(fontSize: 16),
                            ),
                            BlocSelector<OrderController, OrderState, double>(
                                selector: ((state) => state.totalOrder),
                                builder: (_, totalOrder) {
                                  return Text(
                                    totalOrder.currencyPTBR,
                                    style: context.textStyles.textExtraBold
                                        .copyWith(fontSize: 16),
                                  );
                                })
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'Endereço de entrega',
                        controller: addressController,
                        validator:
                            Validatorless.required('Endereço Obrigatório'),
                        hintText: 'Digite um endereço',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OrderField(
                        title: 'CPF',
                        controller: documentController,
                        validator: Validatorless.required('CPF Obrigatório'),
                        hintText: 'Digite o CPF',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocSelector<OrderController, OrderState,
                          List<PaymentTypeModel>>(
                        selector: ((state) => state.paymentTypes),
                        builder: ((context, paymentTypes) =>
                            ValueListenableBuilder(
                              valueListenable: paymentTypeValid,
                              builder: ((_, paymentTypeValidValue, child) =>
                                  PaymentsTypesField(
                                    paymentTypes: paymentTypes,
                                    valueChanged: (value) {
                                      paymentTypeId = value;
                                    },
                                    valid: paymentTypeValidValue,
                                    selected: paymentTypeId.toString(),
                                  )),
                            )),
                      )
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DeliveryButton(
                          width: double.infinity,
                          height: 48,
                          label: 'Finalizar',
                          onPressed: () {
                            final valid =
                                formKey.currentState?.validate() ?? false;
                            final paymentTypeSelected = paymentTypeId != null;
                            paymentTypeValid.value = paymentTypeSelected;
                            if (valid && paymentTypeSelected) {
                              controller.saveOrder(
                                  address: addressController,
                                  document: documentController,
                                  paymentMethodId: paymentTypeId!);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
