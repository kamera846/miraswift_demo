import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswiftdemo/models/equipment_model.dart';
import 'package:miraswiftdemo/services/api.dart';

class EquipmentApiService {
  Future<List<EquipmentModel>?> getEquipments({
    String? category,
    required Function(String msg) onSuccess,
    required Function(String msg) onError,
    required Function(List<EquipmentModel>? data) onCompleted,
  }) async {
    List<EquipmentModel>? data;
    Map<String, String> withFilter = {};
    if (category != null) {
      withFilter = {'name': category};
    }
    try {
      final url = Uri.https(baseUrl, 'api/equipment-status', withFilter);
      final response = await http.get(url, headers: headerSetup);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJsonList(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.listData != null) {
            data = apiResponse.listData
                ?.map((item) => EquipmentModel.fromJson(item))
                .toList();
          }
          onSuccess(apiResponse.msg);
          return data;
        }

        onError(apiResponse.msg);
        return data;
      } else {
        onError('$failedRequestText. Status Code: ${response.statusCode}');
        return data;
      }
    } catch (e) {
      onError('$failedRequestText. Exception: $e');
      return data;
    } finally {
      onCompleted(data);
    }
  }
}
