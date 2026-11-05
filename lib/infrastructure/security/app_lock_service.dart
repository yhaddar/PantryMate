import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  AppLockService({LocalAuthentication? authentication})
    : _authentication = authentication ?? LocalAuthentication();

  static const _enabledKey = 'app_lock_enabled';
  static const _storage = FlutterSecureStorage();

  final LocalAuthentication _authentication;

  Future<bool> isEnabled() async =>
      (await _storage.read(key: _enabledKey)) == 'true';

  Future<bool> isAvailable() async {
    try {
      return await _authentication.isDeviceSupported() &&
          await _authentication.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setEnabled(bool enabled) async {
    if (enabled && !await isAvailable()) return false;
    await _storage.write(key: _enabledKey, value: enabled.toString());
    return true;
  }

  Future<bool> authenticate() async {
    try {
      return await _authentication.authenticate(
        localizedReason: 'Unlock PantryMate to view household data',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      return false;
    }
  }
}
