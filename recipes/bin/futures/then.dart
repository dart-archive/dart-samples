import 'dart:io';

void main() {
  String filename = 'README.md';
  File file = new File(filename);
  file.readAsString()
    .then(print);
}