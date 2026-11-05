enum ThemePreference { system, light, dark }

class UserSettings {
  const UserSettings({
    this.theme = ThemePreference.system,
    this.appLockEnabled = false,
  });

  final ThemePreference theme;
  final bool appLockEnabled;
}
