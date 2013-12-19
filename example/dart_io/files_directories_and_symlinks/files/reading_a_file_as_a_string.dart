// Use the File `readAsString()` method to read a file as a string.

import 'dart:async';
import 'dart:io';

void main() {
  new File('file.txt').readAsString().then((String contents) {
    // Do something with the file contents.
  });
}