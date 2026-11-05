class ReminderPlan {
  const ReminderPlan({required this.scheduledAt, this.snoozedUntil});

  final DateTime scheduledAt;
  final DateTime? snoozedUntil;
}

DateTime scheduleExpirationReminder({
  required DateTime expirationDate,
  required int leadDays,
  required DateTime localNow,
  int hour = 9,
  int minute = 0,
}) {
  final date = DateTime(
    expirationDate.year,
    expirationDate.month,
    expirationDate.day,
  ).subtract(Duration(days: leadDays));
  var scheduled = DateTime(date.year, date.month, date.day, hour, minute);
  if (scheduled.isBefore(localNow)) scheduled = localNow;
  return scheduled;
}

DateTime snoozeExpirationReminder(DateTime currentReminder) =>
    currentReminder.add(const Duration(days: 1));

bool isWithinQuietHours(
  DateTime localTime, {
  int startHour = 22,
  int endHour = 8,
}) {
  final hour = localTime.hour;
  return startHour > endHour
      ? hour >= startHour || hour < endHour
      : hour >= startHour && hour < endHour;
}
