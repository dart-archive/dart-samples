/// Use the FileSystemEntity `isLink()` method to check if path represents
/// a symlink.

import 'dart:io';
import 'dart:async'; // Import not needed but added here to explicitly assign type for clarity below.

main() async {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // List the contents of the system temp directory.
  Stream<FileSystemEntity> entityList =
      systemTempDir.list(recursive: true, followLinks: false);
  await for (FileSystemEntity entity in entityList) {
    // Print the path only if it represents a symlink.
    var isLink = await FileSystemEntity.isLink(entity.path);
    if (isLink) print(entity.path);
  }
}
