import 'package:intl/intl.dart';

String dateFormatted(date) {
  var parsedDate = DateTime.parse(date);
  var formatter = DateFormat("d.MM.y");
  String formatted = formatter.format(parsedDate);
  return formatted;
}