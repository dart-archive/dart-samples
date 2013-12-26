/// Use `Platform.pathSeparator` to get the separator used by the operating
/// system to separate components in file. Or, use the `separator` getter
/// in the `path` Pub package.
///

import 'dart:io' show Platform;
import 'package:path/path.dart' as path;

void main() {
  // Prints  '\' on Windows and '/' on other platforms.
  print(Platform.pathSeparator);

  // This does the same.
  print(path.separator);
}