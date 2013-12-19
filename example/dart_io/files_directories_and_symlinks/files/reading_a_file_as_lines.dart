// Use the File `readAsLines()` method to read file contents as lines.

import 'dart:async';
import 'dart:io';

void main() {
  new File('file.txt').readAsLines().then((List<String> lines) {
    // Do something with lines.
  });
}