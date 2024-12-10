class FormulaModel {
  const FormulaModel({
    required this.idFormula,
    required this.idProduct,
    required this.targetFormula,
    required this.fineFormula,
    required this.kodeMaterial,
    required this.nameMaterial,
    required this.timeTarget,
    required this.createdAt,
    required this.updatedAt,
  });

  final String idFormula;
  final String idProduct;
  final String targetFormula;
  final String fineFormula;
  final String kodeMaterial;
  final String nameMaterial;
  final String timeTarget;
  final String createdAt;
  final String updatedAt;

  factory FormulaModel.fromJson(Map<String, dynamic> json) {
    return FormulaModel(
      idFormula: json['id_formula'] ?? '',
      idProduct: json['id_product'] ?? '',
      targetFormula: json['target_formula'] ?? '',
      fineFormula: json['fine_formula'] ?? '',
      kodeMaterial: json['kode_material'] ?? '',
      nameMaterial: json['name_material'] ?? '',
      timeTarget: json['time_target'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id_formula': idFormula,
        'id_product': idProduct,
        'target_formula': targetFormula,
        'fine_formula': fineFormula,
        'kode_material': kodeMaterial,
        'name_material': nameMaterial,
        'time_target': timeTarget,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
