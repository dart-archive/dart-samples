import 'package:http/http.dart' as http;

void main() {
  var url = 'http://httpbin.org/';
  http.get(url).then((response) {

    // Get the headers map.
    print(response.headers.keys);

    // Get header values.
    print(response.headers['access-control-allow-origin']);
    print(response.headers['content-type']);
    print(response.headers['date']);
    print(response.headers['content-length']);
    print(response.headers['connection']);
  });
}