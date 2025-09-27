class Time {
  static DateTime parseTime(String time) {
    return DateTime.parse('2025-01-01 $time');
  }

  static String addDays(String day, days) {
    DateTime date = DateTime.parse(
      "$day 14:00:00.000",
    ).add(Duration(days: days));
    final yearStr = date.year.toString();
    final monthStr = date.month.toString().padLeft(2, '0');
    final dayStr = date.day.toString().padLeft(2, '0');
    return '$yearStr-$monthStr-$dayStr';
  }

  static int difference(String time1, String time2) {
    return (parseTime(time1).difference(parseTime(time2))).inMinutes;
  }

  static String addMinutes(String time, int minutesToAdd) {
    final dateTime = parseTime(time);
    final updated = dateTime.add(Duration(minutes: minutesToAdd));
    return updated.toString().substring(11, 16); // returns 'HH:mm'
  }
}
