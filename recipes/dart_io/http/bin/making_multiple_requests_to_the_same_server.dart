import 'package:http/http.dart' as http;

printResponseBody(response) {
  print(response.body.length);
  if (response.body.length > 100) {
    print(response.body.substring(0, 100));
  } else {
    print(response.body);
  }
  print('...\n');
}

void main() {
   var url = 'http://httpbin.org';
   var client = new http.Client();
   client.get('${url}/foo')
       .then((response) {
         printResponseBody(response);
         return client.get('${url}/bar');
        })
       .then(printResponseBody)

       // Close the connection when done.
       .whenComplete(client.close);
}