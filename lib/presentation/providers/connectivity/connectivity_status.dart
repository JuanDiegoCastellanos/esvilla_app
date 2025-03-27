import 'package:esvilla_app/presentation/providers/connectivity/conectivity_provider.dart';

class ConnectivityStatus {
  final bool isConnected;
  final ConnectionType connectionType;
  final String? error;

  ConnectivityStatus({
    required this.isConnected, 
    this.connectionType = ConnectionType.none,
    this.error
  });

  factory ConnectivityStatus.initial() => ConnectivityStatus(
    isConnected: false, 
    connectionType: ConnectionType.none
  );
}
