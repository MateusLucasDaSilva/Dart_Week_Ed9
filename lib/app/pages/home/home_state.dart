// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final List<ProductModel> products;
  final String? erroMessege;
  final List<OrderProductDto> shoppingBag;


  const HomeState({
    required this.status,
    required this.products,
    required this.shoppingBag,
    this.erroMessege,
  });

  const HomeState.initial()
      : status = HomeStateStatus.initial,
        products = const [],
        shoppingBag = const [],
        erroMessege = null;
        
        

  @override
  List<Object?> get props => [status, products, erroMessege, shoppingBag];

  HomeState copyWith({
    HomeStateStatus? status,
    List<ProductModel>? products,
    String? erroMessege,
    List<OrderProductDto>? shoppingBag,
  }) {
    return HomeState(
      status: status ?? this.status,
      products: products ?? this.products,
      erroMessege: erroMessege ?? this.erroMessege,
      shoppingBag: shoppingBag ?? this.shoppingBag,
    );
  }
}
