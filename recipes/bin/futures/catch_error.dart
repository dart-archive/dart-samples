import 'dart:io';

void handleSuccess(value) {
  print('File read successfully: ');
  print(value);
}

void handleError(error) {
  print('File not read: ');
  print(error.message);
}

void main() {
  String filename = 'somefile.txt';
  File file = new File(filename);
  file.readAsString()
    .then(handleSuccess)
    .catchError(handleError);
}