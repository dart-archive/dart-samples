// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `bodyBytes` field on the Response object to get the response
/// in bytes.

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

void main() {
  var url = "https://www.dartlang.org/logos/dart-logo.png";
  http.get(url).then((response) {
    List<int> bytes = response.bodyBytes;
    // Do something with the bytes. For example, convert to base64.
    String base64 = CryptoUtils.bytesToBase64(bytes);
    // ...
  });
}