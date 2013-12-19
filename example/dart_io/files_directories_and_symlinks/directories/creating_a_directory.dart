/// Use the Directory `create()` method to create a directory.
/// To create intermediate directories, set the `recursive` argument to `true`
/// (default is `false`).

import 'dart:io';

void main() {
  // Creates dir/ and dir/subdir/.
  new Directory('dir/subdir').create(recursive: true)
    // The created directory is returned as a Future.
    .then((Directory directory) {
      print(directory.path);
  });
}