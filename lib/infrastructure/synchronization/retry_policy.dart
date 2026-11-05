import 'dart:math' as math;

Duration retryDelay(
  int attempt, {
  Duration base = const Duration(seconds: 2),
  Duration maximum = const Duration(minutes: 15),
}) {
  final exponent = math.max(0, attempt - 1);
  final delay = base * math.pow(2, exponent).toInt();
  return delay > maximum ? maximum : delay;
}
