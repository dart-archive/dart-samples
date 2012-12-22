// BEGIN(setsolotest_complete_example)
// BEGIN(setsolotest_extend_configuration)
import 'package:unittest/unittest.dart';
import 'package:args/args.dart';

class SingleTestConfiguration extends Configuration {
  get autoStart => false;
  void onDone(int passed, int failed, int errors, List<TestCase> testCases,
              String uncaughtError) {
    testCases.forEach((testCase){
      // get the id of the testCase in there
      print("${testCase.id}\t${testCase.result.toUpperCase()}: ${testCase.description}");
      });
   // skip the summary that is normally provided here...
  }
}
// END(setsolotest_extend_configuration)

// BEGIN(setsolotest_use_configuration)
void useSingleTestConfiguration() {
  configure(new SingleTestConfiguration());
  ensureInitialized();  
}
// END(setsolotest_use_configuration)

void main() {
  useSingleTestConfiguration();
  
  // get the args from the command line
  ArgParser argParser = new ArgParser();
  Options options = new Options();
  ArgResults results = argParser.parse(options.arguments);
  List<String> args = results.rest;

  // note that the second test is failing
  test("passing test", () => expect(1, equals(1)));
  test("failing test", () => expect(false, isTrue));
  test("another passing test", () => expect(3, equals(3)));
  
  if (!args.isEmpty) {
    setSoloTest(int.parse(args[0]));
  }
  
  // run the tests (we turned off auto-running of tests, remember?
  runTests();
}
// END(setsolotest_complete_example)

/*
// BEGIN(setsolotest_output_with_arg)
$ dart myFile.dart 2
unittest-suite-wait-for-done
2 FAIL: failing test
// END(setsolotest_output_with_arg)
*/

/*
// BEGIN(setsolotest_output_without_arg)
$ dart myFile.dart
unittest-suite-wait-for-done
1 PASS: passing test
2 FAIL: failing test
3 PASS: another passing test
// END(setsolotest_output_without_arg)
*/
