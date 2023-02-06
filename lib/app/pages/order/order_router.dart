import 'package:dw_delivery_app/app/pages/order/order_controller.dart';
import 'package:dw_delivery_app/app/pages/order/order_page.dart';
import 'package:dw_delivery_app/app/repositories/order/ordder_repository_impl.dart';
import 'package:dw_delivery_app/app/repositories/order/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderRouter {
  OrderRouter();

  static Widget get page => MultiProvider(
        providers: [
          Provider<OrderRepository>(
            create: (context) => OrdderRepositoryImpl(dio: context.read()),
          ),
          Provider(
            create: (context) => OrderController(context.read()),
          )
        ],
        child: const OrderPage(),
      );
}
