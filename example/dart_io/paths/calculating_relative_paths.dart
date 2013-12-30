// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `relative()` function in the `path` Pub package to calculate
/// relative paths.  This function calculates the relative path from the current
/// directory by default. To calculate the relative path from another path,
/// specify that path using the `from` argument.

import 'dart:io' show Directory;
import 'package:path/path.dart' as path;

void main() {
  // The path from the current directory to the system temp directory.
  print(path.relative(Directory.systemTemp.path));

  // You can work with relative paths.
  var path1 = 'docs/book.html';
  var path2 = 'articles/list';
  print(path.relative(path1, from: path2)); // Prints '../../docs/book.html'.
  print(path.relative(path2, from: path1)); // Prints '../../articles/list'.

  // Or you can work with absolute paths.
  var samples = 'http://www.dartlang.org/samples';
  var docs = 'http://www.dartlang.org/docs';
  print(path.relative(samples, from: docs)); // Prints '../samples'.
}