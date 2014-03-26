// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Read the response body using the `read()` function defined in the http Pub
/// package.

import 'package:http/http.dart' as http;

void main() {
  http.read("http://www.google.com/").then(print);
}
