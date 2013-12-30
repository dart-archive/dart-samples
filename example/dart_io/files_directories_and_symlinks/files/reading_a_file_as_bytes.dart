// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the File `readAsBytes()` method to read file contents as bytes.

import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';

void main() {
  new File('file.txt').readAsBytes().then((bytes) {
    // Do something with the bytes. For example, convert to base64.
    String base64 = CryptoUtils.bytesToBase64(bytes);
    // ...
  });
}