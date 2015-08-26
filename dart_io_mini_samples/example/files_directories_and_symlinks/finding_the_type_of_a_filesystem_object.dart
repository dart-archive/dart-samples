// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `FileSystemEntity.type()` method to get the type of a file system
/// object. This method is inherited by File, Directory, and Link.

import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // List the contents of the system temp directory.
  Stream<FileSystemEntity> entityList =
      Directory.systemTemp.list(recursive: true, followLinks: false);

  await for (FileSystemEntity entity in entityList) {
    // Get the type of the FileSystemEntity, apply the appropiate label, and
    // print the entity path.
    FileSystemEntityType type = await FileSystemEntity.type(entity.path);

    String label;
    switch (type) {
      case FileSystemEntityType.DIRECTORY:
        label = 'D';
        break;
      case FileSystemEntityType.FILE:
        label = 'F';
        break;
      case FileSystemEntityType.LINK:
        label = 'L';
        break;
      default:
        label = 'UNKNOWN';
    }
    print('$label: ${entity.path}');
  }
}
