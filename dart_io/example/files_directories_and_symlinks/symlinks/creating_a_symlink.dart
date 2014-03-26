/// Use the Link `create()` method to create a symlink.

import 'dart:io';

void main() {
  // Get the system temp directory.
  var systemTempDir = Directory.systemTemp;

  // Create a temporary directory with the system temp directory.
  systemTempDir.createTemp('my_temp_dir').then((temp) {

    // Generate a couple of paths.
    var first = '${temp.path}${Platform.pathSeparator}first';
    var second = '${temp.path}${Platform.pathSeparator}second';

    // Create a symlink.
    new Link(second).create(first).then((Link symLink) {
      // Do something with the symlink.
    });
  });
}
