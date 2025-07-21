class FrequencyModel {
  const FrequencyModel({
    required this.idFrequency,
    required this.semenHigh,
    required this.semenLow,
    required this.kapurHigh,
    required this.kapurLow,
    required this.pasirKasarHigh,
    required this.pasirKasarLow,
    required this.pasirHalusHigh,
    required this.pasirHalusLow,
    required this.semenPutihHigh,
    required this.semenPutihLow,
    required this.createdAt,
    required this.updatedAt,
  });

  final String idFrequency;
  final String semenHigh;
  final String semenLow;
  final String kapurHigh;
  final String kapurLow;
  final String pasirKasarHigh;
  final String pasirKasarLow;
  final String pasirHalusHigh;
  final String pasirHalusLow;
  final String semenPutihHigh;
  final String semenPutihLow;
  final String createdAt;
  final String updatedAt;

  factory FrequencyModel.fromJson(Map<String, dynamic> json) {
    return FrequencyModel(
      idFrequency: json['id_frequency'] ?? '-',
      semenHigh: json['semen_high'] ?? '-',
      semenLow: json['semen_low'] ?? '-',
      kapurHigh: json['kapur_high'] ?? '-',
      kapurLow: json['kapur_low'] ?? '-',
      pasirKasarHigh: json['pasir_kasar_high'] ?? '-',
      pasirKasarLow: json['pasir_kasar_low'] ?? '-',
      pasirHalusHigh: json['pasir_halus_high'] ?? '-',
      pasirHalusLow: json['pasir_halus_low'] ?? '-',
      semenPutihHigh: json['semen_putih_high'] ?? '-',
      semenPutihLow: json['semen_putih_low'] ?? '-',
      createdAt: json['created_at'] ?? '-',
      updatedAt: json['updated_at'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() => {
    'id_frequency': idFrequency,
    'semen_high': semenHigh,
    'semen_low': semenLow,
    'kapur_high': kapurHigh,
    'kapur_low': kapurLow,
    'pasir_kasar_high': pasirKasarHigh,
    'pasir_kasar_low': pasirKasarLow,
    'pasir_halus_high': pasirHalusHigh,
    'pasir_halus_low': pasirHalusLow,
    'semen_putih_high': semenPutihHigh,
    'semen_putih_low': semenPutihLow,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
