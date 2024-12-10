class MaterialModel {
  const MaterialModel({
    required this.no,
    required this.name,
    required this.id,
  });

  final String no;
  final String name;
  final int id;

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      no: json['no'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() => {
        'no': no,
        'name': name,
        'id': id,
      };
}
