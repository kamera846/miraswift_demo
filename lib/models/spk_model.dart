class SpkModel {
  const SpkModel({
    required this.idSpk,
    required this.idProduct,
    required this.jmlBatch,
    required this.dateSpk,
    required this.descSpk,
    required this.statusSpk,
    required this.createdAt,
    required this.updatedAt,
    this.isChecked = false,
  });

  final String idSpk;
  final String idProduct;
  final String jmlBatch;
  final String dateSpk;
  final String descSpk;
  final String statusSpk;
  final String createdAt;
  final String updatedAt;
  final bool isChecked;

  SpkModel copyWith({
    String? idSpk,
    String? idProduct,
    String? jmlBatch,
    String? dateSpk,
    String? descSpk,
    String? statusSpk,
    String? createdAt,
    String? updatedAt,
    bool? isChecked,
  }) {
    return SpkModel(
      idSpk: idSpk ?? this.idSpk,
      idProduct: idProduct ?? this.idProduct,
      jmlBatch: jmlBatch ?? this.jmlBatch,
      dateSpk: dateSpk ?? this.dateSpk,
      descSpk: descSpk ?? this.descSpk,
      statusSpk: statusSpk ?? this.statusSpk,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  factory SpkModel.fromJson(Map<String, dynamic> json) {
    return SpkModel(
      idSpk: json['id_spk'] ?? '',
      idProduct: json['id_product'] ?? '',
      jmlBatch: json['jml_batch'] ?? '',
      dateSpk: json['date_spk'] ?? '',
      descSpk: json['desc_spk'] ?? '',
      statusSpk: json['status_spk'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_spk': idSpk,
        'id_product': idProduct,
        'jml_batch': jmlBatch,
        'date_spk': dateSpk,
        'desc_spk': descSpk,
        'status_spk': statusSpk,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
