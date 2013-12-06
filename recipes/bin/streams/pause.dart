import 'dart:async';

Future futureReturningFunction() {
  return new Future.delayed(new Duration(seconds: 1));
}

void main() {
  int counter = 0;
  Stream stream = new Stream.periodic(
      new Duration(milliseconds: 100), (_) => ++counter);
  
  StreamSubscription subscription; 
  subscription = stream.listen(print);
  
  new Timer.periodic(const Duration(seconds: 2), (_) {
    subscription.pause(futureReturningFunction());
  });
}