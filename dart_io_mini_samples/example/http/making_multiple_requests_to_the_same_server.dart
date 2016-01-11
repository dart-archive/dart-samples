// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `Client` class in the http Pub package for making multiple requests
/// to the same server. Using `Client` keeps keep a persistent connection open
/// to the server and is better than making multiple single requests.

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

main() async {
  var url = 'http://www.google.com/';
  var client = new http.Client();
  try {
    var response = await client.get('${url}/search');
    printResponseBody(response);
    response = await client.get('${url}/doodles');
    printResponseBody(response);
  } finally {
    client.close();
  }
}
