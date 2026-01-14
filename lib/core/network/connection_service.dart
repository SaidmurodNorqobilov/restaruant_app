import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionService {
  // Faqat bitta tekshirish (Ilova ochilganda)
  static Future<bool> isConnected() async {
    var result = await (Connectivity().checkConnectivity());
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }

  // Doimiy eshitib turish (Stream)
  static Stream<List<ConnectivityResult>> get connectionStream =>
      Connectivity().onConnectivityChanged;
}