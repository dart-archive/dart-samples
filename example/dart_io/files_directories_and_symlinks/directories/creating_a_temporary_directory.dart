/// Use the Directory `createTemp()` method to create a temporary directory.
/// This method appends random characters to the name of the directory to
/// produce a unique directory name.

import 'dart:io';

void main() {
  // Create a temporary directory in the system temp directory.
  Directory.systemTemp.createTemp('my_temp_dir')
    .then((directory) {
      print(directory.path);
    });
}
