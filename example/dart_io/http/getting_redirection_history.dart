// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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