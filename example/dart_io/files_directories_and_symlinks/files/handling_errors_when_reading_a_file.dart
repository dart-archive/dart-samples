/// Use `then()` to read the file contents, and `catchError()` to catch
/// errors. Register a callback with `catchError()` to handle the error.

import 'dart:io';

void handleError(e) {
  print('There was a ${e.runtimeType} error');
  print(e.message);
}

main() {
  final filename = 'non_existent_file.txt';
  new File(filename).readAsString()
    // Read and print the file contents.
    .then(print)
    // Catch errors.
    .catchError((e) {
      print('There was a ${e.runtimeType} error');
      print('Could not read $filename');
    });
}