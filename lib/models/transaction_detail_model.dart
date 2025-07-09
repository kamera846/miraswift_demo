import 'package:miraswiftdemo/models/spk_model.dart';

class TransactionDetailModel {
  const TransactionDetailModel({
    required this.idTransactionDetail,
    required this.idTransaction,
    required this.idSpk,
    required this.statusTransactionDetail,
    required this.createdAt,
    required this.updatedAt,
    this.spk,
  });

  final String idTransactionDetail;
  final String idTransaction;
  final String idSpk;
  final String statusTransactionDetail;
  final String createdAt;
  final String updatedAt;
  final SpkModel? spk;

  TransactionDetailModel copyWith({
    String? idTransactionDetail,
    String? idTransaction,
    String? idSpk,
    String? statusTransactionDetail,
    String? createdAt,
    String? updatedAt,
    SpkModel? spk,
  }) {
    return TransactionDetailModel(
      idTransactionDetail: idTransactionDetail ?? this.idTransactionDetail,
      idTransaction: idTransaction ?? this.idTransaction,
      idSpk: idSpk ?? this.idSpk,
      statusTransactionDetail:
          statusTransactionDetail ?? this.statusTransactionDetail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      spk: spk ?? this.spk,
    );
  }

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    return TransactionDetailModel(
      idTransactionDetail: json['id_transaction_detail'] ?? '',
      idTransaction: json['id_transaction'] ?? '',
      idSpk: json['id_spk'] ?? '',
      statusTransactionDetail: json['status_transaction_detail'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      spk: SpkModel.fromJson(json['spk']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id_transaction': idTransaction,
    'id_spk': idSpk,
    'status_transaction_detail': statusTransactionDetail,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'spk': spk,
  };
}
