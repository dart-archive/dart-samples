import 'dart:async';

void successCallback(value) => value;

void main() {
  new Future(() => throw 'an error')

     // Forwards error. Callback does not fire.
    .then(successCallback)

    // Forwards error. Callback does fire.
    .whenComplete(() => print("inside whenComplete()"))

    // Forwards error. Callback does not fire.
    .then((_) => print("Won't reach here either."))

    // Handles error.
    .catchError(print);
}