import 'package:intl/intl.dart';

String moonDateConverter(pickedDate, context) {
  String formattedDate = DateFormat.yMMMMEEEEd().format(pickedDate);
  return formattedDate;
}
