class EquipmentModel {
  const EquipmentModel({
    required this.idEquipmentStatus,
    required this.noBatch,
    required this.statusEquipment,
    required this.nameEquipment,
    required this.dateEquipment,
    required this.timeEquipment,
    required this.createdAt,
  });

  final String idEquipmentStatus;
  final String noBatch;
  final String statusEquipment;
  final String nameEquipment;
  final String dateEquipment;
  final String timeEquipment;
  final String createdAt;

  Map<String, dynamic> toJson() => {
        'id_equipment_status': idEquipmentStatus,
        'no_batch': noBatch,
        'status_equipment': statusEquipment,
        'name_equipment': nameEquipment,
        'date_equipment': dateEquipment,
        'time_equipment': timeEquipment,
        'created_at': createdAt,
      };

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      idEquipmentStatus: json['id_equipment_status'],
      noBatch: json['no_batch'],
      statusEquipment: json['status_equipment'],
      nameEquipment: json['name_equipment'],
      dateEquipment: json['date_equipment'],
      timeEquipment: json['time_equipment'],
      createdAt: json['created_at'],
    );
  }
}
