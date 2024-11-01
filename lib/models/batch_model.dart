class BatchModel {
  const BatchModel({
    required this.noBatch,
    required this.nameEquipment,
    required this.timeOn,
    required this.timeOff,
    required this.timeElapsed,
    required this.desc,
  });

  final String noBatch;
  final String nameEquipment;
  final String timeOn;
  final String timeOff;
  final String timeElapsed;
  final String desc;

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      noBatch: json['no_batch'] ?? '',
      nameEquipment: json['name_equipment'] ?? '',
      timeOn: json['time_on'] ?? '',
      timeOff: json['time_off'] ?? '',
      timeElapsed: json['time_elapsed'] ?? '',
      desc: json['desc'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'no_batch': noBatch,
        'name_equipment': nameEquipment,
        'time_on': timeOn,
        'time_off': timeOff,
        'time_elapsed': timeElapsed,
        'desc': desc,
      };
}
