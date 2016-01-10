// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `basename()`, `dirname()`, `basenameWithoutExtension()`, and
/// `extension()` methods defined in the `path` Pub package when working with
/// a file path.

import 'package:path/path.dart' as path;

import 'dart:io';

main() async {
  // Create dir/ and dir/file.txt in the system temp directory.
  var file = await new File('${Directory.systemTemp.path}/dir/myFile.txt')
      .create(recursive: true);

  print(path.basename(file.path)); // Prints 'file.txt'.
  print(path.dirname(file.path)); // Prints path ending with 'dir'.
  print(path.basenameWithoutExtension(file.path)); // Prints 'myFile'.
  print(path.extension(file.path)); // Prints '.txt'.
}
