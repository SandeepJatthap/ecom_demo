import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';
import '../../models/product/product_model.dart';
import '../../models/product/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts(FilterProductParams params);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts(params) =>
      _getProductFromUrl('$baseUrl/products');

  Future<List<ProductModel>> _getProductFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return List<ProductModel>.from(
          json.decode(response.body).map((x) => ProductModel.fromJson(x)));
    } else {
      throw ServerException();
    }
  }
}
