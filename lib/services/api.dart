const baseUrl = 'bizlink.topmortarindonesia.com';
const headerSetup = {'Content-Type': 'application/json'};
const failedRequestText = 'Failed fetch data.';

class ApiResponse {
  final int code;
  final String status;
  final String msg;
  final Map<String, dynamic>? data;
  final List<dynamic>? listData;

  ApiResponse({
    required this.code,
    required this.status,
    required this.msg,
    this.data,
    this.listData,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      msg: json['msg'] ?? '',
      data: json['data'],
    );
  }

  factory ApiResponse.fromJsonList(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      msg: json['msg'] ?? '',
      listData: json['data'],
    );
  }
}