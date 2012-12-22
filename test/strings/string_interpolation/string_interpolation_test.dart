library string_interpolation_test;

import "package:unittest/unittest.dart";
import "package:cookbook/strings/string_interpolation/string_interpolation.dart";

void main() {
  group("interpolation:", () { 
    test("simple", () {
      expect(simpleInterpolation(), equals("I said hello to Kathy"));
    });

    test("without using {}", () {
      expect(simpleInterpolationWithoutCurlies(), equals("I said hello to Kathy"));
    });

    test("calling toString() on an int", () {
      expect(callingToStringOnInt(), equals('There are 5 people in this room'));
    });
    
    test("an object without a toString() defined", () {
      Book book = new Book("War and Peace");
      expect(withoutToString(), equals("The book is 'Instance of \'Book\''"));
    });
  
    test("an object with a toString() defined", () {
      Song song = new Song("You can call me Al");
      expect(withToString(), equals("The song is 'You can call me Al'"));
    });
  
    test ("a ternary if...else", () {
      expect(useTernaryIfElse(), equals("There are a few people in this room"));
    });
  
    test ("list and map operations", () {
      List strings = listAndMapOperations();
      expect(strings[0], equals(
        "The list is [1, 2, 3, 4, 5], and when squared it is [1, 4, 9, 16, 25]"));
      expect(strings[1], equals("I live in sunny California"));
    });
  
    test("a self calling function", () {
        List names = ['John', 'Paul', 'George', 'Ringo'];
        String str = interpolateSelfCallingFunction();
        List<String> tokens = str.split(' ');
        expect(names.contains(tokens[0]), isTrue);
        expect(Strings.join(tokens.getRange(1, tokens.length - 1), " "), 
          equals("was the most important member of the Beatles"));
    });
  });
}
