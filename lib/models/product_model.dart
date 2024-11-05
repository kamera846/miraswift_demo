class ProductModel {
  const ProductModel({
    required this.idProduct,
    required this.kodeProduct,
    required this.nameProduct,
    required this.createdAt,
    required this.updatedAt,
  });

  final String idProduct;
  final String kodeProduct;
  final String nameProduct;
  final String createdAt;
  final String updatedAt;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProduct: json['id_product'] ?? '',
      kodeProduct: json['kode_product'] ?? '',
      nameProduct: json['name_product'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_product': idProduct,
        'kode_product': kodeProduct,
        'name_product': nameProduct,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
