library test_test;
import 'package:unittest/unittest.dart';

import 'strings/strings_test.dart' as strings_test;
import 'testing/testing_test.dart' as testing_test;

void main() {
  strings_test.main(); 
  testing_test.main();
}