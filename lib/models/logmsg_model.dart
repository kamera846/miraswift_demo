class LogMessageModel {
  const LogMessageModel({
    required this.idLogMsg,
    required this.toName,
    required this.toNumber,
    required this.message,
    required this.dateMsg,
    required this.statusMsg,
    required this.responseMsg,
    required this.createdAt,
    required this.updatedAt,
  });

  final String idLogMsg;
  final String toName;
  final String toNumber;
  final String message;
  final String dateMsg;
  final String statusMsg;
  final String responseMsg;
  final String createdAt;
  final String updatedAt;

  factory LogMessageModel.fromJson(Map<String, dynamic> json) {
    return LogMessageModel(
      idLogMsg: json['id_log_msg'] ?? '',
      toName: json['to_name'] ?? '',
      toNumber: json['to_number'] ?? '',
      message: json['message'] ?? '',
      dateMsg: json['date_msg'] ?? '',
      statusMsg: json['status_msg'] ?? '',
      responseMsg: json['response_msg'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_log_msg': idLogMsg,
        'to_name': toName,
        'to_number': toNumber,
        'message': message,
        'date_msg': dateMsg,
        'status_msg': statusMsg,
        'response_msg': responseMsg,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
