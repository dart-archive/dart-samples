// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the Directory `create()` method to create a directory.
/// To create intermediate directories, set the `recursive` argument to `true`
/// (default is `false`).

import 'dart:io';

void main() {
  // Creates dir/ and dir/subdir/.
  new Directory('dir/subdir').create(recursive: true)
    // The created directory is returned as a Future.
    .then((Directory directory) {
      print(directory.path);
  });
}