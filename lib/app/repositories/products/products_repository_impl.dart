// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw_delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:dw_delivery_app/app/models/product_model.dart';
import 'package:dw_delivery_app/app/repositories/products/products_repository.dart';

import '../../core/exceptions/repository_Exception.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final CustomDio dio;
  ProductsRepositoryImpl({
    required this.dio,
  });
  @override
  Future<List<ProductModel>> findAllProducts() async {
    try {
      final result = await dio.unauth().get('/products');
      return result.data
          .map<ProductModel>(
            (p) => ProductModel.fromMap(p),
          )
          .toList();
    } on DioError catch (e, s) {
      log('Erro ao buscar produtos', error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao buscar produtos");
    }
  }
}
