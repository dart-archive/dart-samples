// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Use the `toUri()` and `fromUri()` functions in the `path` Pub package when
/// converting between a URI and a path.

import 'package:path/path.dart' as path;

void main() {
  var uri = path.toUri('http://dartlang.org/samples');
  print(path.fromUri(uri)); // Prints 'http:/dartlang.org/samples'.
}