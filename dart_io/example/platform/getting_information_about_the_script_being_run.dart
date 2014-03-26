// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use `Platform.script` to get the absolute URI of the script being run in
/// the current isolate.

import 'dart:io' show Platform;

void main() {
  // Get the URI of the script being run.
  var uri = Platform.script;
  print(uri); // Prints something like '/Users/shailentuli/workspace/...'.

  // Convert the URI to a path.
  var path = uri.toFilePath();
  print(path); // Prints something like 'file:///Users/shailentuli/workspace/...'.
}