import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:dw_delivery_app/app/core/rest_client/interceptors/auth_interceptor.dart';

import '../config/env/env.dart';

class CustomDio extends DioForNative {
  late AuthInterceptor _althInterceptor;
  CustomDio()
      : super(BaseOptions(
            baseUrl: Env.i['backend_base_url'] ?? '',
            connectTimeout: 5000,
            receiveTimeout: 60000)) {
    interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
    _althInterceptor = AuthInterceptor(this);
  }

  CustomDio auth() {
    interceptors.add(_althInterceptor);
    return this;
  }

  CustomDio unauth() {
    interceptors.remove(_althInterceptor);
    return this;
  }
}
