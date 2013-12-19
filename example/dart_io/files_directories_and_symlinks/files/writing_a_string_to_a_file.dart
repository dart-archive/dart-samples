/// Use the File object's `writeAsString()` method to write a string to a
/// file. After writing the string, the method closes the file.

import 'dart:io';

void main() {
  final filename = 'file.txt';
  new File(filename).writeAsString('some content')
    .then((File file) {
      // Do something with the file.
    });
}