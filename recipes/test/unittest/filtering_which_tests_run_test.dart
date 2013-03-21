import 'package:unittest/unittest.dart';
import 'package:args/args.dart';
import 'dart:io';

class FilterTests extends Configuration {
  get autoStart => false;
}

void useFilteredTests() {
  configure(new FilterTests());
  ensureInitialized();  
}

void main() {
  useFilteredTests();
  
  // Get the args from the command line.
  ArgParser argParser = new ArgParser();
  Options options = new Options();
  ArgResults results = argParser.parse(options.arguments);
  List<String> args = results.rest;

  test('one test',     () => expect(1 + 0, equals(1))); 
  test('another test', () => expect(1 + 1, equals(2)));
  test('and another',  () => expect(1 + 2, equals(3)));

  group('case change', () {
    test('to upper', () => expect('this'.toUpperCase(), equals('THIS'))); 
    test('to lower', () => expect('THAT'.toLowerCase(), equals('that')));
  });

  if (!args.isEmpty) {
    filterTests(args[0]);
  }
  runTests();
    
// Output when no args are passed:
//    unittest-suite-wait-for-done
//    PASS: one test
//    PASS: another test
//    PASS: and another
//    PASS: case change to upper
//    PASS: case change to lower
//
//    All 5 tests passed.
//    unittest-suite-success
    
//    with 'case'
//    unittest-suite-wait-for-done
//    PASS: case change to upper
//    PASS: case change to lower
//
//    All 2 tests passed.
//    unittest-suite-success
    
    
// with 'another'
//    unittest-suite-wait-for-done
//    PASS: another test
//    PASS: and another
//
//    All 2 tests passed.
//    unittest-suite-success
//    
}


