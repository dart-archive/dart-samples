// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// An HTTP request may return a response, or it may generate an error.
import 'package:http/http.dart' as http;

handleSuccess(http.Response response) {
  print('something went wrong');
  print(response.body);
}

handleFailure(error) {
  print('Something went wrong.');
  print(error.message);
}

main() async {
  try {
    var response = await http.get("http://some_bogus_website.org");
    handleSuccess(response);
  } catch (e) {
    handleFailure(e);
  }
}
