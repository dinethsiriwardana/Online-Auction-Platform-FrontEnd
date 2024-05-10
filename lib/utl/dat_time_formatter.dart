import 'package:intl/intl.dart';

class DayTimeFormatter {
  String formatLocalTime(DateTime dateTime) {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.S");
    return dateFormat.format(dateTime);
  }
}
