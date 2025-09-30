import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  late StreamSubscription _connectivityChangeSubscription;
  late ConnectivityResult _connectivity;

  Future bootstrap() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    _connectivity = connectivityResults.isNotEmpty
        ? connectivityResults.first
        : ConnectivityResult.none;
    _connectivityChangeSubscription =
        onConnectivityChange(_onConnectivityChange);
  }

  void dispose() {
    _connectivityChangeSubscription.cancel();
  }

  StreamSubscription onConnectivityChange(
      Function(ConnectivityResult) onConnectivityChange) {
    return Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final connectivity =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      onConnectivityChange(connectivity);
    });
  }

  ConnectivityResult getConnectivity() {
    return _connectivity;
  }

  void _onConnectivityChange(ConnectivityResult connectivity) {
    _connectivity = connectivity;
  }
}
