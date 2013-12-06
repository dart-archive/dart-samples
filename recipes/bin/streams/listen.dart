import 'dart:io';
import 'dart:async';

void main() {
  Stream<List<int>> stream = new File('README.md').openRead();
  StreamSubscription subscription;
  subscription = stream.listen((data) {
    print(new String.fromCharCodes(data));
  });
  
  try {  
    stream.listen((data) {
      print(new String.fromCharCodes(data));
    });
  } catch (e) {
    assert(e.toString() == 'Bad state: Stream already has subscriber.');
  }
  
  assert(stream.isBroadcast == false);
}