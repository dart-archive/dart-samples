import 'dart:async';
import 'dart:io';

String obtainFilename(String data) => throw '<error from obtainFilename>';
String parseFileData(String contents) => throw '<error from parseFileData>';

Future<int> parseAndRead(data) {
  String filename = obtainFilename(data);         // Could throw.
  File file = new File(filename);
  return file.readAsString()
    .then((contents) => parseFileData(contents)); // Could also throw.
}

Future<int> parseAndReadWrapped(data) {
  return new Future(() {
    String filename = obtainFilename(data);         // Could throw.
    File file = new File(filename);
    return file.readAsString()
      .then((contents) => parseFileData(contents)); // Could also throw.
  });
}

void main() {
  var data = 'foo bar';
  parseAndReadWrapped(data)
    .then(print)
    .catchError((error) => print('Error: $error'));
}