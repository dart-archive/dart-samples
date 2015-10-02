// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `list()` method to list a directory's contents.  The method recurses
/// into subdirectories if the `recursive` argument is `true` (default is
/// `false`). It does not follow symlinks if the `followLinks` argument is
/// `false` (default is `true`).

import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // List directory contents, recursing into sub-directories, but not following
  // symbolic links.
  Stream<FileSystemEntity> entityList =
      systemTempDir.list(recursive: true, followLinks: false);
  await for (FileSystemEntity entity in entityList) print(entity.path);
}
