// BEGIN(solo_test_code)
import "package:unittest/unittest.dart";

void main() {
  test("test that's already running fine", () {
    expect('foo', equals('foo'));
  }); // this test will not run
  
  solo_test("test I am working on now", () {
    expect('bar', equals('bar'));
  });
}
// END(solo_test_code)

/*
// BEGIN(solo_test_output)
unittest-suite-wait-for-done
PASS: test I am working on now

All 1 tests passed.
unittest-suite-success
// END(solo_test_output)
*/
