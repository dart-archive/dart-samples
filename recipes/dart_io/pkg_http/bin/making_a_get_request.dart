import 'package:http/http.dart' as http;

void main() {
  var url = 'http://httpbin.org/';
  http.get(url).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}