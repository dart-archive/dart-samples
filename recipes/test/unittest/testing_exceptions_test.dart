import 'package:unittest/unittest.dart';

List<int> range(start, stop) {
    if (start >= stop) {
      throw new ArgumentError("arg1 must be less than arg2");
    }
    
    var list = new List<int>();
    for (var i = start; i < stop; i++) {
      list.add(i);
    }
    return list;
}

class TooMuchCoffeeException implements Exception {}

void main() {   
  test('an exception is thrown', () {
    expect(() => range(10, 5), throws);
  });
  
  test('an ArgumentError is thrown', () {
    expect(() => range(10, 5), throwsArgumentError);
  });
  
  test('getting the type of the exception', () {
    expect(() => range(5, 2), throwsA(new isInstanceOf<ArgumentError>()));
  });
  
  test('getting the type of a custom exception', () {
    expect(() => throw new TooMuchCoffeeException(), 
        throwsA(new isInstanceOf<TooMuchCoffeeException>()));
  });
  
  test('testing the type and message of an exception', () {
    expect(() => range(5, 3), 
        throwsA(predicate((e) => (e is ArgumentError &&
            e.message == 'arg1 must be less than arg2'))));
  });
  
  test('testing the type and message of an exception', () {
    expect(() => range(5, 3), 
      throwsA(allOf(isArgumentError,
          predicate((e) => e.message == 'arg1 must be less than arg2'))));
  });
  
  test('no exception is thrown', () {
    expect(() => range(5, 10), returnsNormally);
  });
}