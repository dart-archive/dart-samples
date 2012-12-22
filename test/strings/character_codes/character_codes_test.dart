library character_codes_test;

import 'package:unittest/unittest.dart';
import 'package:cookbook/strings/character_codes/character_codes.dart';

void main() {
  group("character codes:", () {
  test("CharCodes()", () {
      expect(useCharCodes(), equals([104, 101, 108, 108, 111]));
    });

    test("CharCodeAt()", () {
      expect(useCharCodeAt(), equals(104));
    });
  
    test("fromCharCodes()", () {
      expect(useFromCharCodes(), equals("hello"));  
    });
  
    test("StringBuffer", () {
      expect(useStringBuffer(), equals("hello"));  
    });
  
    test("rot13 example", () {
      expect(useRot13(), equals(["What", "or", "cheryl", "ones"]));
    });
  
    test("rot13 with non-alphanum chars", () {
      expect(useRot13WithNonAlpha(), isTrue);
    });
  });
}
