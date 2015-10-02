// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the FileSystemEntity `parent` property to get the parent of a
/// file, directory, or symlink. This property is inherited by File, Directory,
/// and Link.

import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // List the contents of the system temp directory.
  Stream<FileSystemEntity> entityList =
      Directory.systemTemp.list(recursive: true, followLinks: false);

  await for (FileSystemEntity entity in entityList) print(entity.parent.path);
}
