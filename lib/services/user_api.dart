import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswiftdemo/models/user_model.dart';
import 'package:miraswiftdemo/services/api.dart';

class UserApi {
  Future<List<UserModel>?> list({
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<UserModel>? data)? onCompleted,
  }) async {
    List<UserModel>? data;
    try {
      final url = Uri.https(baseUrl, 'api/user');
      final response = await http.get(url, headers: headerSetup);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJsonList(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.listData != null) {
            data = apiResponse.listData
                ?.map((item) => UserModel.fromJson(item))
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
    Function(UserModel? data)? onCompleted,
  }) async {
    UserModel? data;
    try {
      final url = Uri.https(baseUrl, 'api/user/$id');
      final response = await http.get(url, headers: headerSetup);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.data != null) {
            data = UserModel.fromJson(apiResponse.data!);
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
    required String nameUser,
    required String phoneUser,
    required String isActive,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/user');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode({
          'name_user': nameUser,
          'phone_user': phoneUser,
          'is_active': isActive,
        }),
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
    required String nameUser,
    required String phoneUser,
    required String isActive,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/user/$id');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode({
          'name_user': nameUser,
          'phone_user': phoneUser,
          'is_active': isActive,
        }),
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
      final url = Uri.https(baseUrl, 'api/user/$id');
      final response = await http.delete(url, headers: headerSetup);

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
