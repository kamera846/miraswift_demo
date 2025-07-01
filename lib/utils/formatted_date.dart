import 'package:intl/intl.dart';

String formattedDate({
  required String dateStr,
  String inputFormat = 'yyyy-MM-dd',
  String outputFormat = 'dd MMMM yyyy',
}) {
  try {
    var date = DateFormat(inputFormat).parse(dateStr);
    String formattedDate = DateFormat(outputFormat, "id_ID").format(date);

    return formattedDate;
  } catch (e) {
    return '-';
  }
}
