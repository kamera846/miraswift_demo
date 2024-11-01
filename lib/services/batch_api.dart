import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswift_demo/models/batch_model.dart';
import 'package:miraswift_demo/services/api.dart';

class BatchApiService {
  Future<List<BatchModel>?> batchs({
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<BatchModel>? data)? onCompleted,
  }) async {
    List<BatchModel>? data;
    try {
      final url = Uri.https(baseUrl, 'api/batch');
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

  Future<List<BatchModel>?> detail({
    required String batchNumber,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<BatchModel>? data)? onCompleted,
  }) async {
    List<BatchModel>? data;
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
}
