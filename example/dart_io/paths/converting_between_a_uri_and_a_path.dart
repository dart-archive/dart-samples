/// Use the `toUri()` and `fromUri()` functions in the `path` Pub package when
/// converting between a URI and a path.

import 'package:path/path.dart' as path;

void main() {
  var uri = path.toUri('http://dartlang.org/samples');
  print(path.fromUri(uri)); // Prints 'http:/dartlang.org/samples'.
}