// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the FileSystemEntity `rename()` method to change the name of a
/// file, directory or symlink. This method is inherited by
/// File, Directory, and Link.

import 'dart:io';

void main() {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // Create a file.
  new File('${systemTempDir.path}/foo.txt').create()
    .then((file) {
      print('The path is ${file.path}'); // Prints path ending with `foo.txt`.
      // Rename the file.
      return file.rename('${systemTempDir.path}/bar.txt');
    })
    .then((file) {
      print('The path is ${file.path}'); // Prints path ending with `bar.txt`.
    });
}