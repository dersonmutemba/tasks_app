import 'dart:io';

class DataConnectionChecker {
  Future<bool> get hasConnection async {
    try {
      final result = await InternetAddress.lookup('https://www.opendns.com/');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException {
      return false;
    }
    return false;
  }
}
