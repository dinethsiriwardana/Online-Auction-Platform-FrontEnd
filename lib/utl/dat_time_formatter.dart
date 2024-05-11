import 'package:intl/intl.dart';

class DayTimeFormatter {
  String formatLocalTime(DateTime dateTime) {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.S");
    return dateFormat.format(dateTime);
  }

  //time to duration converter as Duration - yyyy-MM-ddTHH:mm:ss.S
  Duration timeToDuration(String time) {
    // DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.S");
    DateTime dateTime = DateTime.parse(time);
    return dateTime.difference(DateTime.now());
  }
}
