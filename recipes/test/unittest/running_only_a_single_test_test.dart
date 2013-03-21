import 'package:unittest/unittest.dart';

void no_solo_test() {
  test('addition', () => expect(1 + 1, equals(2)));
  test('subtraction', () => expect(1 - 1, equals(0)));
}

void one_solo_test() {
  test('addition', () => expect(1 + 1, equals(2)));
  solo_test('subtraction', () => expect(1 - 1, equals(0)));
}

void many_solo_tests() {
  solo_test('addition', () => expect(1 + 1, equals(2)));
  solo_test('subtraction', () => expect(1 - 1, equals(0)));
}

void main() {
  no_solo_test();
//  unittest-suite-wait-for-done
//  PASS: addition
//  PASS: subtraction
//
//  All 2 tests passed.
//  unittest-suite-success
  
  one_solo_test();
//  unittest-suite-wait-for-done
//  PASS: subtraction
//
//  All 1 tests passed.
//  unittest-suite-success
  
  try {
    many_solo_tests();
  } catch(e) {
    print(e);
  }
}

// Exception: Only one test can be soloed right now.
