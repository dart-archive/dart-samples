import 'dart:async';
import 'dart:io';

void main() {
  new File('bogusFile.txt').readAsString()
    .then(print)
    .catchError((e) {
      if (e is FileIOException) {
        throw e;
      }
    })
    .catchError(print, test: (error) => error is FileIOException);
}