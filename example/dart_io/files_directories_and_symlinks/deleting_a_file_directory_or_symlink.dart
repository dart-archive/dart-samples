// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the FilesSystemEntity `delete()` method to delete a file, directory, or
/// symlink. This method is inherited by File, Directory, and Link.


import 'dart:io';

void main() {
  // Create a temporary directory.
  Directory.systemTemp.createTemp('my_temp_dir')
    .then((directory) {
      // Confirm it exists.
      directory.exists().then(print); // Prints 'true'.
      // Delete the directory.
      return directory.delete();
    })
    .then((directory) {
      // Confirm it no longer exists.
      directory.exists().then(print); // Prints 'false'
    });
}
