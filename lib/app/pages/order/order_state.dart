// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:match/match.dart';
import 'package:dw_delivery_app/app/dto/order_product_dto.dart';
import 'package:dw_delivery_app/app/models/payment_types_model.dart';

part 'order_state.g.dart';

@match
enum OrderStatus {
  initial,
  loading,
  loaded,
  error,
  updatOrder,
  confirmRemoveProduct,
  emptyBag,
  success,
}

class OrderState extends Equatable {
  final OrderStatus status;
  final List<OrderProductDto> orderProducts;
  final List<PaymentTypesModel> paymentTypes;
  final String? errorMessage;

  const OrderState({
    required this.paymentTypes,
    required this.status,
    required this.orderProducts,
    this.errorMessage,
  });

  const OrderState.initial()
      : status = OrderStatus.initial,
        orderProducts = const [],
        paymentTypes = const [],
        errorMessage = null;

  double get totalOrder => orderProducts.fold(
      0.0, (previousValue, element) => previousValue + element.totalPrice);

  @override
  List<Object?> get props => [status, orderProducts, paymentTypes, errorMessage];

  OrderState copyWith({
    OrderStatus? status,
    List<OrderProductDto>? orderProducts,
    List<PaymentTypesModel>? paymentTypes,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orderProducts: orderProducts ?? this.orderProducts,
      paymentTypes: paymentTypes ?? this.paymentTypes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class OrderConfirmDeleteProductState extends OrderState {
  final OrderProductDto orderProduct;
  final int index;

  const OrderConfirmDeleteProductState({
    required this.orderProduct,
    required this.index,
    required super.paymentTypes,
    required super.status,
    required super.orderProducts,
    super.errorMessage,
  });
}