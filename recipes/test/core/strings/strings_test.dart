library strings_test;

import 'package:unittest/unittest.dart';

import 'concatenating_strings_test.dart' as concatenating_strings_test;
import 'interpolating_expressions_test.dart' as interpolating_expressions_test; 
import 'incrementally_building_test.dart' as incrementally_building_test;
import 'converting_chars_nums_test.dart' as converting_chars_nums_test;
import 'testing_string_emptiness_test.dart' as testing_string_emptiness_test;
import 'trimming_whitespace_test.dart' as trimming_whitespace_test;
import 'getting_the_length_test.dart' as getting_the_length_test;
import 'subscripting_strings_test.dart' as subscripting_strings_test;
import 'splitting_strings_test.dart' as splitting_strings_test;
import 'changing_string_case.dart' as changing_string_case;
import 'determining_if_string_contains_test.dart' as determining_if_string_contains_test;
import 'finding_regexp_matches_test.dart' as finding_regexp_matches_test;
import 'substituting_strings_test.dart' as substituting_strings_test;

void main() {
  concatenating_strings_test.main();
  interpolating_expressions_test.main();
  incrementally_building_test.main();
  converting_chars_nums_test.main();
  testing_string_emptiness_test.main;
  trimming_whitespace_test.main();
  getting_the_length_test.main();
  subscripting_strings_test.main();
  splitting_strings_test.main();
  changing_string_case.main();
  determining_if_string_contains_test.main();
  finding_regexp_matches_test.main(); 
  substituting_strings_test.main();
}