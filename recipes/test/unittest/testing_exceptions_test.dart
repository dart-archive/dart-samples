import 'package:unittest/unittest.dart';



class TooMuchCoffeeException implements Exception {}

void main() {
  test('an exception is thrown', () {
    expect(() => 10 ~/ 0, throws);
  });
  
  test('no exception is thrown', () {
    expect(() => 10 ~/ 1, returnsNormally);
  });
  
  test('testing the type using a matcher', () {
    expect(() => throw new StateError('functions called in the wrong order'), 
        throwsStateError);
  });
  
  test('testing the type using a predicate', () {
    expect(() => 10 ~/ 0, 
        throwsA(predicate((e) => e is IntegerDivisionByZeroException)));
  });
  
  test('testing the type of a *custom* exception', () {
    expect(() => throw new TooMuchCoffeeException(), 
        throwsA(predicate((e) => e is TooMuchCoffeeException)));
  });
  
  test('testing the error message', () {
    expect(() => throw new ArgumentError('bad argument'), 
        throwsA(predicate((e) => e.message == 'bad argument')));
  });
  
  test('testing the error type and the error message', () {
    expect(() => throw new RangeError('out of range'), 
        throwsA(predicate((e) => (e is RangeError &&
            e.message == 'out of range'))));
  });
}