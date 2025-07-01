import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/models/product_model.dart';
import 'package:miraswift_demo/services/api.dart';

class BatchApiService {
  Future<List<BatchModel>?> batchs({
    String? batch,
    String? date,
    String? product,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<BatchModel>? data)? onCompleted,
  }) async {
    List<BatchModel>? data;
    try {
      Map<String, String> params = {};

      if (batch != null || date != null || product != null) {
        if (batch != null) params['batch'] = batch;
        if (date != null) params['date'] = date;
        if (product != null) params['prd'] = product;
      }

      var url = Uri.https(baseUrl, 'api/batch');
      if (params.isNotEmpty) {
        url = Uri.https(baseUrl, 'api/batch', params);
      }
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
                ?.map((item) => BatchModel.fromJson(item))
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

  Future<List<BatchModel>?> batchFastest({
    String? idProduct,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<BatchModel>? data)? onCompleted,
  }) async {
    List<BatchModel>? data;
    try {
      var url = Uri.https(baseUrl, 'api/batch/fastest/$idProduct');
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
                ?.map((item) => BatchModel.fromJson(item))
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
    required String batchNumber,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(
      List<BatchModel>? dataEquipment,
      List<BatchModel>? dataScales,
      ProductModel? dataProduct,
      String? totalEquipmentTime,
      String? totalMaterialTime,
    )? onCompleted,
  }) async {
    List<BatchModel>? dataEquipment;
    List<BatchModel>? dataScales;
    ProductModel? dataProduct;
    String? totalEquipmentTime;
    String? totalMaterialTime;
    try {
      final url = Uri.https(baseUrl, 'api/batch/detail/$batchNumber');
      final response = await http.get(
        url,
        headers: headerSetup,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJsonList(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.dataScales != null) {
            dataScales = apiResponse.dataScales
                ?.map((item) => BatchModel.fromJson(item))
                .toList();
          }
          if (apiResponse.dataEquipment != null) {
            dataEquipment = apiResponse.dataEquipment
                ?.map((item) => BatchModel.fromJson(item))
                .toList();
          }
          if (apiResponse.dataProduct != null) {
            dataProduct = ProductModel.fromJson(apiResponse.dataProduct!);
          }
          totalEquipmentTime = apiResponse.totalEquipmentTime;
          totalMaterialTime = apiResponse.totalMaterialTime;
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
        onCompleted(
          dataEquipment,
          dataScales,
          dataProduct,
          totalEquipmentTime,
          totalMaterialTime,
        );
      }
    }
  }
}
