// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `split()` function in the `path` Pub package to split a path into
/// its components.

import 'package:path/path.dart' as path;

void main() {
  print(path.split('/Users/shailen')); // Prints ['/', 'Users', 'shailen'].

  // Windows example.
  print(path.split(r'C:\tempdir\tmp.txt')); // Prints [r'C:\', 'tempdir', 'tmp.txt'])
}