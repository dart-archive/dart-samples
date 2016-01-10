// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the FilesSystemEntity `delete()` method to delete a file, directory, or
/// symlink. This method is inherited by File, Directory, and Link.

import 'dart:io';

main() async {
  // Create a temporary directory.
  var dir = await Directory.systemTemp.createTemp('my_temp_dir');

  // Confirm it exists.
  print(await dir.exists());

  // Delete the directory.
  await dir.delete();

  // Confirm it no longer exists.
  print(await dir.exists());
}
