import 'package:http/http.dart' as http;

void main() {
  http.read("http://www.google.com/").then(print);
}