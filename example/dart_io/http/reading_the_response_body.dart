/// Read the response body using the `read()` function defined in the http Pub
/// package.

import 'package:http/http.dart' as http;

void main() {
  http.read("http://www.google.com/").then(print);
}
