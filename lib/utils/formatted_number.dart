import 'package:intl/intl.dart';

String formattedNumber(double number) {
  var formatNumber = NumberFormat('#,##0.0', 'id_ID');
  var totalScales = formatNumber.format(number);
  return totalScales;
}
