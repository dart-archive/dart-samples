import 'dart:io';
import 'dart:async';

handleError(DirectoryIOException error) {
  print('${error.message}: "${error.path}" does not exist.');
}

Stream streamReturningFunction() {
  Directory directory = new Directory('a/bogus/path');
  return directory.list();
}

void main() {
  StreamSubscription subscription;
  subscription = streamReturningFunction().listen(null);
  subscription.onData(print);
  subscription.onError(handleError);
}