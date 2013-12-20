/// Use the `HttpClient` class in the 'dart:io' library to make a request, and
/// use the Response `redirects` property to get a list of the redirects.

import "dart:io" show HttpClient, RedirectInfo;

main() {
  var client = new HttpClient();
  client.getUrl(Uri.parse('http://google.com'))
    .then((request) => request.close())
    .then((response) {
      // Get a list of all redirects.
      List<RedirectInfo> redirects = response.redirects;
      redirects.forEach((redirect) {
        print(redirect.location); // Prints 'http://www.google.com'.
      });
    });
}