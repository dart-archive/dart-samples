// BEGIN(filtertests_code)
import 'package:unittest/unittest.dart';
import 'package:args/args.dart';

class FilterTests extends Configuration {
  get autoStart => false;
}

void useFilterTests() {
  configure(new FilterTests());
  ensureInitialized();
}

void main() {
  useFilterTests();

  // get the args from the command line
  ArgParser argParser = new ArgParser();
  Options options = new Options();
  ArgResults results = argParser.parse(options.arguments);
  List<String> args = results.rest;

  test("one banana", () => expect(1, equals(1)));
  test("two banana", () => expect(2, equals(2)));
  test("three banana",()  => expect(3, equals(3)));
  test("four", () => expect(4, equals(4)));

  group("Betty Botter bought a bit of", () {
    test("butter", () => expect("butter".length, equals(6)));
    test("better butter", () => expect("better butter".length, equals(13)));
  });

  if (!args.isEmpty) {
    filterTests(args[0]);
  }
  runTests();
}

// END(filtertests_code)

/**
// BEGIN(filtertests_keyword_equals_four)
unittest-suite-wait-for-done
PASS: four

All 1 tests passed.
unittest-suite-success
// END(filtertests_keyword_equals_four)
*/

/**
// BEGIN(filtertests_keyword_equals_Betty)
unittest-suite-wait-for-done
PASS: Betty Botter bought a bit of butter
PASS: Betty Botter bought a bit of better butter

All 2 tests passed.
unittest-suite-success
// END(filtertests_keyword_equals_Betty)
*/
