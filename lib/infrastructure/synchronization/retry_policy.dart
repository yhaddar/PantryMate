Duration retryDelay(
  int attempt, {
  Duration base = const Duration(seconds: 2),
  Duration maximum = const Duration(minutes: 15),
}) {
  var delay = base;
  for (var index = 1; index < attempt && delay < maximum; index++) {
    final remaining = maximum - delay;
    if (delay >= remaining) return maximum;
    delay *= 2;
  }
  return delay > maximum ? maximum : delay;
}
