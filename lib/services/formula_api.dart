import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswift_demo/models/formula_model.dart';
import 'package:miraswift_demo/services/api.dart';

class FormulaApi {
  Future<List<FormulaModel>?> list({
    required String idProduct,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<FormulaModel>? data)? onCompleted,
  }) async {
    List<FormulaModel>? data;
    try {
      final url = Uri.https(baseUrl, 'api/formula', {'id_product': idProduct});
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
                ?.map((item) => FormulaModel.fromJson(item))
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
    required String id,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(FormulaModel? data)? onCompleted,
  }) async {
    FormulaModel? data;
    try {
      final url = Uri.https(baseUrl, 'api/formula/$id');
      final response = await http.get(
        url,
        headers: headerSetup,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.data != null) {
            data = FormulaModel.fromJson(apiResponse.data!);
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
    required String productId,
    required String code,
    required String name,
    required String target,
    required String fine,
    required String time,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/formula');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode(
          {
            'id_product': productId,
            'target_formula': target,
            'fine_formula': fine,
            'kode_material': code,
            'name_material': name,
            'time_target': time,
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
    required String id,
    required String productId,
    required String code,
    required String name,
    required String target,
    required String fine,
    required String time,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/formula/$id');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode(
          {
            'id_product': productId,
            'target_formula': target,
            'fine_formula': fine,
            'kode_material': code,
            'name_material': name,
            'time_target': time,
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
    required String id,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/formula/$id');
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
