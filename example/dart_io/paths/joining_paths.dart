/// Use the path Pub package, and use `join()` to create a new path from
/// existing paths. Using `join()` ensures that the current platform's directory
/// separator is used in the path.

import 'package:path/path.dart' as path;

void main() {
  var newPath = path.join('/Users/shailen', 'dart/projects');
  print(newPath); // Prints '/Users.shailen/dart/projects'.
}