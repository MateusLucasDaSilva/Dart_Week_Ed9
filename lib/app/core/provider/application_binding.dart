import 'package:dw_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dw_delivery_app/app/repositories/auth/auth_repository.dart';
import 'package:dw_delivery_app/app/repositories/auth/auth_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApplicationBinding extends StatelessWidget {
  final Widget child;
  const ApplicationBinding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => CustomDio(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(dio: context.read()),
        ),
      ],
      child: child,
    );
  }
}
