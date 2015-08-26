// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the File `readAsBytes()` method to read file contents as bytes.

import 'dart:io';

import 'package:crypto/crypto.dart';

main() async {
  var bytes = await new File('file.txt').readAsBytes();
  // Do something with the bytes. For example, convert to base64.
  String base64 = CryptoUtils.bytesToBase64(bytes);
  print(base64);
}
