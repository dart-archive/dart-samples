// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the http package `get()` function to make a GET request.

import 'package:http/http.dart' as http;

void main() {
  var url = 'http://httpbin.org/';
  http.get(url).then((response) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
  });
}