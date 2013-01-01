library string_interpolation_test;

import "package:unittest/unittest.dart";
import "package:cookbook/strings/trimming_strings/trimming_strings.dart";

void main() {
  group("trim():", () {
    test("with leading and trailing whitespace", () {
      expect(use_trim("  asdf  "), equals("asdf"));
    });
    
    test("with leading whitespace", () {
      expect(use_trim("  asdf"), equals("asdf"));
    });
    
    test("with trailing whitespace", () {
      expect(use_trim("asdf  "), equals("asdf"));
    });
    
    test("with neither leading or trailing whitespace", () {
      expect(use_trim("asdf"), equals("asdf"));
    });
  });
  
  group("ltrim():", (){
    test("with leading and trailing whitespace", () {
      expect(ltrim("  asdf  "), equals("asdf  "));
    });
  });

  group("rtrim():", (){
    test("with leading and trailing whitespace", () {
      expect(rtrim("  asdf  "), equals("  asdf"));
    });
  });
}
