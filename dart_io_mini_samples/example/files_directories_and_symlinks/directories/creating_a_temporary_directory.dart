// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the Directory `createTemp()` method to create a temporary directory.
/// This method appends random characters to the name of the directory to
/// produce a unique directory name.

import 'dart:io';

void main() {
  // Create a temporary directory in the system temp directory.
  Directory.systemTemp.createTemp('my_temp_dir')
    .then((directory) {
      print(directory.path);
    });
}
