import 'package:miraswiftdemo/models/formula_model.dart';
import 'package:miraswiftdemo/models/product_model.dart';
import 'package:miraswiftdemo/models/spk_model.dart';

class BatchModel {
  const BatchModel({
    required this.noBatch,
    required this.nameEquipment,
    required this.timeOn,
    required this.timeOff,
    required this.timeElapsed,
    required this.desc,
    required this.idTimbang,
    required this.kodeBahan,
    required this.nameBahan,
    required this.actualTimbang,
    required this.statusTimbang,
    required this.dateTimbang,
    required this.timeTimbang,
    required this.createdAt,
    required this.dateEquipment,
    required this.materialTime,
    required this.totalEquipmentTime,
    this.formula,
    this.product,
    this.spk,
  });

  final String noBatch;
  final String nameEquipment;
  final String timeOn;
  final String timeOff;
  final String timeElapsed;
  final String desc;
  final String idTimbang;
  final String kodeBahan;
  final String nameBahan;
  final String actualTimbang;
  final String statusTimbang;
  final String dateTimbang;
  final String timeTimbang;
  final String createdAt;
  final String dateEquipment;
  final String materialTime;
  final String totalEquipmentTime;
  final FormulaModel? formula;
  final ProductModel? product;
  final SpkModel? spk;

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      noBatch: json['no_batch'] ?? '',
      nameEquipment: json['name_equipment'] ?? '',
      timeOn: json['time_on'] ?? '',
      timeOff: json['time_off'] ?? '',
      timeElapsed: json['time_elapsed'] ?? '',
      desc: json['desc'] ?? '',
      idTimbang: json['id_timbang'] ?? '',
      kodeBahan: json['kode_bahan'] ?? '',
      nameBahan: json['name_bahan'] ?? '',
      actualTimbang: json['actual_timbang'] ?? '',
      statusTimbang: json['status_timbang'] ?? '',
      dateTimbang: json['date_timbang'] ?? '',
      timeTimbang: json['time_timbang'] ?? '',
      createdAt: json['created_at'] ?? '',
      dateEquipment: json['date_equipment'] ?? '',
      materialTime: json['materialTime'] ?? '',
      totalEquipmentTime: json['totalEquipmentTime'] ?? '',
      formula: json['formula'] != null
          ? FormulaModel.fromJson(json['formula'])
          : null,
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      spk: json['spk'] != null && json['spk'] is Map && json['spk'] is! List
          ? SpkModel.fromJson(json['spk'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'no_batch': noBatch,
    'name_equipment': nameEquipment,
    'time_on': timeOn,
    'time_off': timeOff,
    'time_elapsed': timeElapsed,
    'desc': desc,
    'id_timbang': idTimbang,
    'kode_bahan': kodeBahan,
    'name_bahan': nameBahan,
    'actual_timbang': actualTimbang,
    'status_timbang': statusTimbang,
    'date_timbang': dateTimbang,
    'time_timbang': timeTimbang,
    'created_at': createdAt,
    'date_equipment': dateEquipment,
    'materialTime': materialTime,
    'totalEquipmentTime': totalEquipmentTime,
    'formula': formula,
    'product': product,
    'spk': spk,
  };
}
