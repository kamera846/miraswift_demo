import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswiftdemo/models/logmsg_model.dart';
import 'package:miraswiftdemo/services/api.dart';

class LogMessageApi {
  Future<List<LogMessageModel>?> list({
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(List<LogMessageModel>? data)? onCompleted,
  }) async {
    List<LogMessageModel>? data;
    try {
      final url = Uri.https(baseUrl, 'api/log-msg');
      final response = await http.get(url, headers: headerSetup);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJsonList(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.listData != null) {
            data = apiResponse.listData
                ?.map((item) => LogMessageModel.fromJson(item))
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
