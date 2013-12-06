import 'dart:async';

String errorCallback(error) => '';

int syncFuncThatMightThrow() => throw 'throwing an aribitrary error';
Future<int> asyncFuncThatMightThrow() => new Future.error(new StateError('arbitrary bad state'));

int syncFunc() => 42;
Future<int> asyncFunc() => new Future.value(42);

int anotherSyncFunc() => throw 'not giving you an int';
Future<int> anotherAsyncFunc() => throw 'not giving you an int';

demoSyncTryCatch() {
  try {
     syncFuncThatMightThrow();
  } catch(e) {}
}

demoAsyncTryCatch() {
  asyncFuncThatMightThrow()
    .then(print)
    .catchError(errorCallback);
}

demoSyncTryCatch2() {
  try {
     var value = syncFunc();
     print(anotherSyncFunc(value));
  } catch(e) {}
}

demoAsyncTryCatch2() {
  asyncFunc()
    .then((value) => anotherAsyncFunc(value))
    .catchError(errorCallback);
}

void main() {
  demoSyncTryCatch();
  demoAsyncTryCatch();
  
  demoSyncTryCatch2();
  demoAsyncTryCatch2();
  
}