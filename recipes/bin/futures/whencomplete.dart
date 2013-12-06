import 'dart:io';
import 'dart:uri';
import 'dart:math';

void processResponse(HttpClientResponse response) {
  // Not a real implementation. Randomly throws or returns an empty string.
  Random random = new Random();
  if (random.nextBool()) throw 'an aribitrary error';
}

void processError(error) => '';

main() {
  var url = new Uri('http://example.com?foo==bar');
  var httpClient = new HttpClient();

  httpClient.postUrl(url)
    .then((HttpClientRequest request) => request.close())
    .then((HttpClientResponse response) => processResponse)
    .catchError(processError)
    .whenComplete(() => httpClient.close());
}