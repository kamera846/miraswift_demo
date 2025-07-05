const baseUrl = 'bizlink.topmortarindonesia.com';
const headerSetup = {'Content-Type': 'application/json'};
const failedRequestText = 'Failed fetch data.';

class ApiResponse {
  final int code;
  final String status;
  final String msg;
  final String? totalEquipmentTime;
  final String? totalMaterialTime;
  final Map<String, dynamic>? data;
  final List<dynamic>? listData;
  final Map<String, dynamic>? detail;
  final List<dynamic>? listDetail;
  final List<dynamic>? dataEquipment;
  final List<dynamic>? dataScales;
  final Map<String, dynamic>? dataProduct;
  final Map<String, dynamic>? spk;
  final Map<String, dynamic>? product;
  final Map<String, dynamic>? formula;

  ApiResponse({
    required this.code,
    required this.status,
    required this.msg,
    this.totalEquipmentTime,
    this.totalMaterialTime,
    this.data,
    this.listData,
    this.detail,
    this.listDetail,
    this.dataEquipment,
    this.dataScales,
    this.dataProduct,
    this.spk,
    this.product,
    this.formula,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      msg: json['msg'] ?? '',
      data: json['data'],
      detail: json['detail'],
      spk: json['spk'],
      product: json['product'],
      formula: json['formula'],
    );
  }

  factory ApiResponse.fromJsonList(Map<String, dynamic> json) {
    return ApiResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      msg: json['msg'] ?? '',
      totalEquipmentTime: json['totalEquipmentTime'] ?? '',
      totalMaterialTime: json['totalMaterialTime'] ?? '',
      listData: json['data'],
      listDetail: json['detail'],
      dataEquipment: json['dataEquipment'],
      dataScales: json['dataTimbang'],
      dataProduct: json['dataProduct'],
    );
  }
}
