import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl(this._connection);

  final InternetConnection _connection;

  @override
  Future<bool> get isConnected => _connection.hasInternetAccess;
}
