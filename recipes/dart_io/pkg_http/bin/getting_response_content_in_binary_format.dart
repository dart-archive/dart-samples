import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

void main() {
  var url = "https://www.dartlang.org/logos/dart-logo.png";
  http.get(url).then((response) {
    List<int> bytes = response.bodyBytes;
    // Do something with the bytes.
    String base64 = CryptoUtils.bytesToBase64(bytes);
  });
}