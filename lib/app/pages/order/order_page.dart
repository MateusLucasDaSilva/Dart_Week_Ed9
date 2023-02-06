import 'package:dw_delivery_app/app/core/extensions/formatter_extension.dart';
import 'package:dw_delivery_app/app/core/text_styles.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_appbar.dart';
import 'package:dw_delivery_app/app/core/ui/widgets/delivery_button.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/models/payment_types_model.dart';
import 'package:dw_delivery_app/app/pages/order/order_controller.dart';
import 'package:dw_delivery_app/app/pages/order/order_state.dart';
import 'package:dw_delivery_app/app/pages/order/widget/order_field.dart';
import 'package:dw_delivery_app/app/pages/order/widget/order_product_tile.dart';
import 'package:dw_delivery_app/app/pages/order/widget/payment_types_fild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validatorless/validatorless.dart';

import '../../core/ui/base_state/base_state.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends BaseState<OrderPage, OrderController> {
  final formKey = GlobalKey<FormState>();
  final addressEC = TextEditingController();
  final documentEC = TextEditingController();
  int? paymentTypeId;
  final paymentTypeValid = ValueNotifier<bool>(true);

  @override
  void onReady() {
    final products =
        ModalRoute.of(context)!.settings.arguments as List<OrderProductDto>;
    controller.load(products);
  }

  void _showConfirmProductDialog(OrderConfirmDeleteProductState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Deseja excluir o produto ${state.orderProduct.product.name}'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.cancelDeleteProcess();
                },
                child: Text(
                  'Cancelar',
                  style: context.textStyles.textExtraBold
                      .copyWith(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.decrementProduct(state.index);
                },
                child: Text(
                  'Confirmar',
                  style: context.textStyles.textExtraBold,
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderController, OrderState>(
      listener: (context, state) {
        state.status.matchAny(
          any: () => hideLoader(),
          loading: () => showLoader(),
          error: () {
            hideLoader();
            showError(state.errorMessage ?? 'Erro ao carregar página');
          },
          confirmRemoveProduct: () {
            hideLoader();
            if (state is OrderConfirmDeleteProductState) {
              _showConfirmProductDialog(state);
            }
          },
          emptyBag: () {
            showInfo(
                'Sua sacola esta vazia, por favor selecione um produto para realizar seu pedido');
            Navigator.pop(context, <OrderProductDto>[]);
          },
          success: () {
            
            hideLoader();
            Navigator.of(context).popAndPushNamed('/order/completed', result: <OrderProductDto>[]);
          },
        );
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(controller.state.orderProducts);
          return false;
        },
        child: Scaffold(
            appBar: DeliveryAppbar(),
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
                            onPressed: () => controller.empytBag(),
                            icon: Image.asset(
                              'assets/images/trashRegular.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocSelector<OrderController, OrderState,
                      List<OrderProductDto>>(
                    selector: (state) => state.orderProducts,
                    builder: (context, orderProducts) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: orderProducts.length,
                          (context, index) {
                            final orderProduct = orderProducts[index];
                            return Column(
                              children: [
                                OrderProductTile(
                                  index: index,
                                  orderProduct: orderProduct,
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total do Pedido',
                                style:
                                    context.textStyles.textExtraBold.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              BlocSelector<OrderController, OrderState, double>(
                                selector: (state) => state.totalOrder,
                                builder: (context, totalorder) {
                                  return Text(
                                    totalorder.currencyPTBR,
                                    style: context.textStyles.textExtraBold
                                        .copyWith(
                                      fontSize: 20,
                                    ),
                                  );
                                },
                              ),
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
                          title: 'Endereço da Entrega',
                          controller: addressEC,
                          validator:
                              Validatorless.required('Endereço Obgatório'),
                          hintText: 'Digite um endereço',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        OrderField(
                          title: 'CPF',
                          controller: documentEC,
                          validator: Validatorless.required('CPF Obgatório'),
                          hintText: 'Digite o CPF',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BlocSelector<OrderController, OrderState,
                            List<PaymentTypesModel>>(
                          selector: (state) => state.paymentTypes,
                          builder: (context, paymentTypes) {
                            return ValueListenableBuilder(
                              valueListenable: paymentTypeValid,
                              builder: (_, paymentTypeValidValue, child) {
                                return PaymentTypesFild(
                                  paymentTypes: paymentTypes,
                                  valueChanged: (value) {
                                    paymentTypeId = value;
                                  },
                                  valid: paymentTypeValidValue,
                                  valueSelected: paymentTypeId.toString(),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Divider(color: Colors.grey),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DeliveryButton(
                            height: 48,
                            width: double.infinity,
                            label: 'FINALIZAR',
                            onPressed: () {
                              final valid =
                                  formKey.currentState?.validate() ?? false;
                              final paymentTypeSelected = paymentTypeId != null;
                              paymentTypeValid.value = paymentTypeSelected;
                              if (valid && paymentTypeSelected) {
                                controller.saveOrder(
                                  address: addressEC.text,
                                  document: documentEC.text,
                                  paymentMethodId: paymentTypeId!,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
