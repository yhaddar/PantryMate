import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Coordinates retries with the device's connectivity lifecycle.
///
/// The caller supplies a real sync operation that selects the authenticated
/// household and invokes [OutboxSyncEngine]. The coordinator does not
/// manufacture a remote success response when Supabase is unavailable or not
/// configured.
class ConnectivitySyncCoordinator {
  ConnectivitySyncCoordinator({
    required Future<void> Function() sync,
    Connectivity? connectivity,
  }) : _sync = sync,
       _connectivity = connectivity ?? Connectivity();

  final Future<void> Function() _sync;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _running = false;
  bool _syncing = false;

  bool get isRunning => _running;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (_hasConnection(results)) unawaited(syncNow());
    });
    final current = await _connectivity.checkConnectivity();
    if (_hasConnection(current)) await syncNow();
  }

  Future<void> syncNow() async {
    if (!_running || _syncing) return;
    _syncing = true;
    try {
      await _sync();
    } finally {
      _syncing = false;
    }
  }

  Future<void> stop() async {
    _running = false;
    await _subscription?.cancel();
    _subscription = null;
  }

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);
}
