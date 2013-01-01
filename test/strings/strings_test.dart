library strings_test;
import 'package:unittest/unittest.dart';
import 'string_interpolation/string_interpolation_test.dart' as string_interpolation_test;
import 'concatenating_strings/concatenating_strings_test.dart' as concatenating_strings_test;
import 'character_codes/character_codes_test.dart' as character_codes_test;
import 'trimming_strings/trimming_strings_test.dart' as trimming_strings_test;

void main() {
  string_interpolation_test.main();
  concatenating_strings_test.main();
  character_codes_test.main();
  trimming_strings_test.main();
}