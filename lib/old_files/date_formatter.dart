import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();
  var formatter = new DateFormat("EEEE H:m, MMM d, y");
  String formatted = formatter.format(now);
  return formatted;
}