/// Use the FileSystemEntity `isLink()` method to check if path represents
/// a symlink.

import 'dart:io';

void main() {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // List the contents of the system temp directory.
  systemTempDir.list(recursive: true, followLinks: false)
    .listen((FileSystemEntity entity) {
      // Print the path only if it represents a symlink.
      FileSystemEntity.isLink(entity.path).then((isLink) {
        if (isLink) print(entity.path);
      });
    });
}
