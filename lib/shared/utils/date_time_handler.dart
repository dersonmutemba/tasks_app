class DateTimeHandler {
  static String resolveDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (now.month == dateTime.month && now.year == dateTime.year) {
      if (now.day == dateTime.day) return 'Today';
      if (now.day == dateTime.day - 1) return 'Tomorrow';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}