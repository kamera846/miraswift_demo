import 'package:miraswift_demo/models/transaction_detail_model.dart';

class TransactionModel {
  const TransactionModel({
    required this.idTransaction,
    required this.dateTransaction,
    required this.statusTransaction,
    required this.createdAt,
    required this.updatedAt,
    this.detail,
  });

  final String idTransaction;
  final String dateTransaction;
  final String statusTransaction;
  final String createdAt;
  final String updatedAt;
  final List<TransactionDetailModel>? detail;

  TransactionModel copyWith({
    String? idTransaction,
    String? dateTransaction,
    String? statusTransaction,
    String? createdAt,
    String? updatedAt,
    List<TransactionDetailModel>? detail,
  }) {
    return TransactionModel(
      idTransaction: idTransaction ?? this.idTransaction,
      dateTransaction: dateTransaction ?? this.dateTransaction,
      statusTransaction: statusTransaction ?? this.statusTransaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      detail: detail ?? this.detail,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      idTransaction: json['id_transaction'] ?? '',
      dateTransaction: json['date_transaction'] ?? '',
      statusTransaction: json['status_transaction'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      detail: json['detail'] != null
          ? (json['detail'] as List)
              .map((e) => TransactionDetailModel.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_transaction': idTransaction,
        'date_transaction': dateTransaction,
        'status_transaction': statusTransaction,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'detail': detail,
      };
}
