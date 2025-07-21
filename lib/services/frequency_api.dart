import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:miraswiftdemo/models/frequency_model.dart';
import 'package:miraswiftdemo/services/api.dart';

class FrequencyApi {
  Future<FrequencyModel?> detail({
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function(FrequencyModel? data)? onCompleted,
  }) async {
    FrequencyModel? data;
    try {
      final url = Uri.https(baseUrl, 'api/frequency');
      final response = await http.get(url, headers: headerSetup);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiResponse = ApiResponse.fromJson(responseBody);

        if (apiResponse.code == 200) {
          if (apiResponse.data != null) {
            data = FrequencyModel.fromJson(apiResponse.data!);
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

  Future<void> save({
    required FrequencyModel item,
    Function(String msg)? onSuccess,
    Function(String msg)? onError,
    Function()? onCompleted,
  }) async {
    try {
      final url = Uri.https(baseUrl, 'api/frequency/save');
      final response = await http.post(
        url,
        headers: headerSetup,
        body: jsonEncode({
          'id_frequency': item.idFrequency,
          'semen_high': item.semenHigh,
          'semen_low': item.semenLow,
          'kapur_high': item.kapurHigh,
          'kapur_low': item.kapurLow,
          'pasir_kasar_high': item.pasirKasarHigh,
          'pasir_kasar_low': item.pasirKasarLow,
          'pasir_halus_high': item.pasirHalusHigh,
          'pasir_halus_low': item.pasirHalusLow,
          'semen_putih_high': item.semenPutihHigh,
          'semen_putih_low': item.semenLow,
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
        }
        return;
      } else {
        if (onError != null) {
          onError('$failedRequestText. Status Code: ${response.statusCode}');
        }
        return;
      }
    } catch (e) {
      if (onError != null) {
        onError('$failedRequestText. Exception: $e');
      }
      return;
    } finally {
      if (onCompleted != null) {
        onCompleted();
      }
    }
  }
}
