import 'package:dw_delivery_app/app/core/global/global_context.dart';
import 'package:dw_delivery_app/app/core/provider/application_binding.dart';
import 'package:dw_delivery_app/app/core/ui/theme/theme_config.dart';
import 'package:dw_delivery_app/app/pages/auth/login/login_router.dart';
import 'package:dw_delivery_app/app/pages/auth/register/register_router.dart';
import 'package:dw_delivery_app/app/pages/home/home_router.dart';
import 'package:dw_delivery_app/app/pages/order/order_completad_page.dart';
import 'package:dw_delivery_app/app/pages/order/order_router.dart';
import 'package:dw_delivery_app/app/pages/product_detail/product_detail_router.dart';
import 'package:dw_delivery_app/app/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

class DwDeliveryApp extends StatelessWidget {
  final _navkey = GlobalKey<NavigatorState>();
  DwDeliveryApp({super.key}) {
    GlobalContext.i.navigatorKey = _navkey;
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationBinding(
      child: MaterialApp(
        title: 'Delivery App',
        theme: ThemeConfig.theme,
        navigatorKey: _navkey,
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => HomeRouter.page,
          '/productDetail': (context) => ProductDetailRouter.page,
          '/auth/login': (context) => LoginRouter.page,
          '/auth/register': (context) => RegisterRouter.page,
          '/order': (context) => OrderRouter.page,
          '/order/completed': (context) => const OrderCompletadPage(),
        },
      ),
    );
  }
}
