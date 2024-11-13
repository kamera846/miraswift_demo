class EquipmentModelMonitoring {
  const EquipmentModelMonitoring({
    this.all,
    this.valve,
    this.jetflo,
    this.mixer,
    this.screw,
    this.scales,
  });

  final String? all;
  final String? valve;
  final String? jetflo;
  final String? mixer;
  final String? screw;
  final double? scales;

  Map<String, dynamic> toJson() => {
        'all': all,
        'valve': valve,
        'jetflo': jetflo,
        'mixer': mixer,
        'screw': screw,
        'timbangan': scales,
      };

  factory EquipmentModelMonitoring.fromJson(Map<String, dynamic> json) {
    return EquipmentModelMonitoring(
      all: json['all'] == '' ? null : json['all'],
      valve: json['valve'] == '' ? null : json['valve'],
      jetflo: json['jetflo'] == '' ? null : json['jetflo'],
      mixer: json['mixer'] == '' ? null : json['mixer'],
      screw: json['screw'] == '' ? null : json['screw'],
      scales: json['timbangan'] == '' ? null : json['timbangan'],
    );
  }
}
