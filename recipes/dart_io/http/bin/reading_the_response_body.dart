import 'package:http/http.dart' as http;

void main() {
  http.read("http://httpbin.org/").then(print);
}