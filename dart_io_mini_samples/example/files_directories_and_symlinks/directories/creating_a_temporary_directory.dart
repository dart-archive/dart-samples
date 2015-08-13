// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the Directory `createTemp()` method to create a temporary directory.
/// This method appends random characters to the name of the directory to
/// produce a unique directory name.

import 'dart:io';

main() async {
  var directory = await Directory.systemTemp.createTemp('my_temp_dir');
  print(directory.path);
}
