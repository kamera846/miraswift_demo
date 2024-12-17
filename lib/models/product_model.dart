class ProductModel {
  const ProductModel({
    required this.idProduct,
    required this.kodeProduct,
    required this.nameProduct,
    required this.createdAt,
    required this.updatedAt,
  })  : id = -1,
        no = '',
        name = '';
  const ProductModel.accurate({
    required this.id,
    required this.no,
    required this.name,
  })  : idProduct = '',
        kodeProduct = '',
        nameProduct = '',
        createdAt = '',
        updatedAt = '';

  final String idProduct;
  final String kodeProduct;
  final String nameProduct;
  final String createdAt;
  final String updatedAt;
  final int id;
  final String no;
  final String name;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProduct: json['id_product'] ?? '',
      kodeProduct: json['kode_product'] ?? '',
      nameProduct: json['name_product'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
  factory ProductModel.fromJsonAccurate(Map<String, dynamic> json) {
    return ProductModel.accurate(
      id: json['id'] ?? -1,
      no: json['no'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_product': idProduct,
        'kode_product': kodeProduct,
        'name_product': nameProduct,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'id': id,
        'no': no,
        'name': name,
      };
}
