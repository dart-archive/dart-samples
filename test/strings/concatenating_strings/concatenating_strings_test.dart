library concatenating_strings_test;

import "package:unittest/unittest.dart";
import "package:cookbook/strings/concatenating_strings/concatenating_strings.dart";

void main() {
  const String hello = "hello, world!";
  
  group("string concatenation:", () {
    test("using the + operator", () {
      expect(() => usePlusOperator(), throwsNoSuchMethodError); 
    });
    
    test("using adjacent string literals", () {
      expect(useAdjacentStringLiterals(), equals(hello));
    });
    
    test("using adjacent string literals on different lines", () {
      expect(useAdjacentStringLiteralsOnDifferentLines(), equals(hello));
    });
    
    test("using a string buffer", () {
      expect(useStringBuffer(), equals(hello));
    });
    
    test("using Strings.join()", () {
      expect(useJoin(), equals(hello));
    });
    
    test("using Strings.concatAll()", () {
      expect(useConcatAll(), equals(hello));
    });
  });
}

