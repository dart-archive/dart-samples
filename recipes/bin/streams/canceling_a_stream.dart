import 'dart:io';
import 'dart:async';

void main() {
  Directory directory = new Directory(Directory.current.path);
  StreamSubscription subscription;
  const int MAXLISTINGS = 25;
  
  int counter = 0;
  subscription = directory.list(recursive: true).listen((data) {
    print(data);
    counter++;
    if (counter >= MAXLISTINGS) {
      subscription.cancel();
    }
  });
}