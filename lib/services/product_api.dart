import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/services/api.dart';

class ProductApi {
  Future<List<ProductModel>?> list({
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<ProductModel>? data)? onCompleted,
  }) async {
    List<ProductModel>? data;
    try {
      final url = Uri.https(baseUrl, 'api/product');
      final response = await http.get(
        url,
        headers: headerSetup,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJsonList(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.listData != null) {
            data = apiResponse.listData
                ?.map((item) => ProductModel.fromJson(item))
                .toList();
          }
          if (onSuccess != null) {
            onSuccess(apiResponse.msg);
          }
          return data;
        }

        if (onError != null) {
          onError(apiResponse.msg);
        }
        return data;
      } else {
        if (onError != null) {
          onError('$failedRequestText. Status Code: ${response.statusCode}');
        }
        return data;
      }
    } catch (e) {
      if (onError != null) {
        onError('$failedRequestText. Exception: $e');
      }
      return data;
    } finally {
      if (onCompleted != null) {
        onCompleted(data);
      }
    }
  }

  Future<void> detail({
    required String productId,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(ProductModel? data)? onCompleted,
  }) async {
    ProductModel? data;
    try {
      final url = Uri.https(baseUrl, 'api/product/$productId');
      final response = await http.get(
        url,
        headers: headerSetup,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.data != null) {
            data = ProductModel.fromJson(apiResponse.data!);
          }
          if (onSuccess != null) {
            onSuccess(apiResponse.msg);
          }
          return;
        }

        if (onError != null) {
          onError(apiResponse.msg);
          return;
        }
      } else {
        if (onError != null) {
          onError('$failedRequestText. Status Code: ${response.statusCode}');
          return;
        }
      }
    } catch (e) {
      if (onError != null) {
        onError('$failedRequestText. Exception: $e');
        return;
      }
    } finally {
      if (onCompleted != null) {
        onCompleted(data);
      }
    }
  }

  Future<void> create({
    required String productCode,
    required String productName,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/product');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode(
          {
            'kode_product': productCode,
            'name_product': productName,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (onSuccess != null) {
            onSuccess(apiResponse.msg);
          }
          return;
        }

        if (onError != null) {
          onError(apiResponse.msg);
          return;
        }
      } else {
        if (onError != null) {
          onError('$failedRequestText. Status Code: ${response.statusCode}');
          return;
        }
      }
    } catch (e) {
      if (onError != null) {
        onError('$failedRequestText. Exception: $e');
        return;
      }
    } finally {
      if (onCompleted != null) {
        onCompleted();
      }
    }
  }

  Future<void> edit({
    required String productId,
    required String productCode,
    required String productName,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/product/$productId');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode(
          {
            'kode_product': productCode,
            'name_product': productName,
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (onSuccess != null) {
            onSuccess(apiResponse.msg);
          }
          return;
        }

        if (onError != null) {
          onError(apiResponse.msg);
          return;
        }
      } else {
        if (onError != null) {
          onError('$failedRequestText. Status Code: ${response.statusCode}');
          return;
        }
      }
    } catch (e) {
      if (onError != null) {
        onError('$failedRequestText. Exception: $e');
        return;
      }
    } finally {
      if (onCompleted != null) {
        onCompleted();
      }
    }
  }

  Future<void> delete({
    required String productId,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/product/$productId');
      final response = await http.delete(
        url,
        headers: headerSetup,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (onSuccess != null) {
            onSuccess(apiResponse.msg);
          }
          return;
        }

        if (onError != null) {
          onError(apiResponse.msg);
          return;
        }
      } else {
        if (onError != null) {
          onError('$failedRequestText. Status Code: ${response.statusCode}');
          return;
        }
      }
    } catch (e) {
      if (onError != null) {
        onError('$failedRequestText. Exception: $e');
        return;
      }
    } finally {
      if (onCompleted != null) {
        onCompleted();
      }
    }
  }
}
