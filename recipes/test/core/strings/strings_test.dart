library strings_test;

import 'package:unittest/unittest.dart';

import 'concatenating_strings_test.dart' as concatenating_strings_test;
import 'interpolating_expressions_test.dart' as interpolating_expressions_test; 
import 'escaping_characters_test.dart' as escaping_characters_test;
import 'incrementally_building_test.dart' as incrementally_building_test;
import 'converting_between_string_characters_test.dart' as converting_between_string_characters_test;
import 'determining_if_string_is_empty_test.dart' as determining_if_string_is_empty_test;
import 'removing_leading_trailing_whitespace_test.dart' as removing_leading_trailing_whitespace_test;
import 'calculating_the_length_test.dart' as calculating_the_length_test;
import 'subscripting_a_string_test.dart' as subscripting_a_string_test;
import 'splitting_strings_test.dart' as splitting_strings_test;
import 'changing_string_case_test.dart' as changing_string_case_test;
import 'determining_if_string_contains_test.dart' as determining_if_string_contains_test;
import 'finding_regexp_matches_test.dart' as finding_regexp_matches_test;
import 'substituting_strings_test.dart' as substituting_strings_test;
import 'processing_a_string_one_character_test.dart' as processing_a_string_one_character_test;

void main() {  
  concatenating_strings_test.main();
  interpolating_expressions_test.main();
  escaping_characters_test.main();
  incrementally_building_test.main();
  converting_between_string_characters_test.main();
  determining_if_string_is_empty_test.main;
  removing_leading_trailing_whitespace_test.main();
  calculating_the_length_test.main();
  subscripting_a_string_test.main();
  processing_a_string_one_character_test.main();
  splitting_strings_test.main();
  changing_string_case_test.main();
  determining_if_string_contains_test.main();
  finding_regexp_matches_test.main(); 
  substituting_strings_test.main();
}