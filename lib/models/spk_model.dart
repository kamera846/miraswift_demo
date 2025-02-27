class SpkModel {
  const SpkModel({
    required this.idSpk,
    required this.idProduct,
    required this.jmlBatch,
    required this.dateSpk,
    required this.descSpk,
    required this.orderingSpk,
    required this.createdAt,
    required this.updatedAt,
  });

  final String idSpk;
  final String idProduct;
  final String jmlBatch;
  final String dateSpk;
  final String descSpk;
  final String orderingSpk;
  final String createdAt;
  final String updatedAt;

  factory SpkModel.fromJson(Map<String, dynamic> json) {
    return SpkModel(
      idSpk: json['id_spk'] ?? '',
      idProduct: json['id_product'] ?? '',
      jmlBatch: json['jml_batch'] ?? '',
      dateSpk: json['date_spk'] ?? '',
      descSpk: json['desc_spk'] ?? '',
      orderingSpk: json['ordering_spk'] ?? '',
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
        'ordering_spk': orderingSpk,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
