// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the File `readAsString()` method to read a file as a string.

import 'dart:async';
import 'dart:io';

void main() {
  new File('file.txt').readAsString().then((String contents) {
    // Do something with the file contents.
  });
}