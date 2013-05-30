import 'dart:async';

void successCallback(value) => value;

void main() {
  new Future(() => throw 'an error')

     // Forwards error. Callback does not fire.
    .then(successCallback)

    // Handles error. Completes its Future with a value, 42.
    .catchError((error) {
      print(error);
      return 42;
    })

    // Completes its Future with 42. Callback fires.
    .whenComplete(() => print("inside whenComplete()"))

    // Prints 42.
    .then(print);
}