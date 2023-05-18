import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  String toLocalFormat() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String toDatewithMonthFormat() {
    return DateFormat('d MMM yy').format(this);
  }

  String toTimeFormat() {
    return DateFormat('hh:mm a').format(this);
  }

  String toDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toDocumentNameDateFormat() {
    return DateFormat('yyyyMMddHHmm').format(this);
  }

  String toDocumentDateFormat() {
    return DateFormat('dd-MM-yyyy').format(this);
  }

  String toDateTime() {
    return DateFormat.yMMMMd().add_jm().format(this);
  }

  String toLocalDateTime() {
    return DateFormat('dd-MM-yyyy hh:mm a').format(this);
  }

  DateTime addTime(DateTime time) =>
      DateTime(year, month, day, time.hour, time.minute);
}
