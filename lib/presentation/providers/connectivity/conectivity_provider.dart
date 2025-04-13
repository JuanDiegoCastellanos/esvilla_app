import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esvilla_app/presentation/providers/connectivity/connectivity_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityNotifier(this._connectivity) : super(ConnectivityStatus.initial()) {
    _init();
  }
  void _init() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final result = results.first;
        state = ConnectivityStatus(
          isConnected: result == ConnectivityResult.mobile || 
                       result == ConnectivityResult.wifi,
          connectionType: _mapConnectivityResult(result)
        );
      },
      onError: (error) {
        state = ConnectivityStatus(
          isConnected: false, 
          connectionType: ConnectionType.none,
          error: error.toString()
        );
      },
    );

    // Initial check
    _checkConnectivity();
  }
  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      state = ConnectivityStatus(
        isConnected: result.contains(ConnectivityResult.mobile) || 
                     result.contains(ConnectivityResult.wifi),
        connectionType: _mapConnectivityResult(result.first)
      );
    } catch (e) {
      state = ConnectivityStatus(
        isConnected: false, 
        connectionType: ConnectionType.none,
        error: e.toString()
      );
    }
  }
  ConnectionType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.bluetooth:
        return ConnectionType.bluetooth;
      case ConnectivityResult.ethernet:
        return ConnectionType.ethernet;
      case ConnectivityResult.none:
      default:
        return ConnectionType.none;
    }
  }
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
enum ConnectionType { mobile, wifi, bluetooth, ethernet, none }

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>((ref) {
  return ConnectivityNotifier(Connectivity());
});
