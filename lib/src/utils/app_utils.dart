import 'package:intl/intl.dart';

class AppUtils {
  static String newChatIdGenerator(String a, String b) {
    var tempIds = [a, b];
    tempIds.sort();
    return '${tempIds[0]}-${tempIds[1]}';
  }

  static String dateToString(DateTime date) =>
      DateFormat.jm().addPattern(', d MMM y').format(date);
}
