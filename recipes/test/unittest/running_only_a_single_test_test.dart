import 'package:unittest/unittest.dart';

List<int> myFunc(x, y) {
  if (y == 0) {
    throw new ArgumentError('second arg cannot be 0');
  }
  return [(x ~/ y), (x % y)];
}

void no_solo_test() {
  test('with y == 0', ()  => expect(() => 22 ~/ 0, throwsArgumentError));
  test('with y != 0', ()  => expect(myFunc(9, 2), equals([4, 1])));
}

void one_solo_test() {
  test('with y == 0', ()  => expect(() => myFunc(22, 0), throwsArgumentError));
  solo_test('with y != 0', ()  => expect(myFunc(9, 2), equals([4, 1])));
}

void many_solo_tests() {
  solo_test('with y == 0', ()  => expect(() => myFunc(22, 0),
      throwsArgumentError));
  solo_test('with y != 0', ()  => expect(myFunc(9, 2), equals([4, 1])));
}

void main() {
  
  test('with y == 0', ()  => expect(() => myFunc(22, 0), throwsArgumentError));
  test('with y != 0', ()  => expect(myFunc(9, 2), equals([4, 1])));
  return;
  
  
//  no_solo_test();
//  unittest-suite-wait-for-done
//  PASS: with y == 0
//  PASS: with y != 0
//
//  All 2 tests passed.
//  unittest-suite-success
  
  
// one_solo_test();
//unittest-suite-wait-for-done
//PASS: with y != 0
//
//All 1 tests passed.
//unittest-suite-success
  
  try {
    many_solo_tests();
  } catch(e) {
    print(e);
  }
}

//unittest-suite-wait-for-done
//Exception: Only one test can be soloed right now.
//PASS: with y == 0
//
//All 1 tests passed.
//unittest-suite-success
