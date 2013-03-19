import 'package:unittest/unittest.dart';

// Using "new List<T>()" *with no argument* still creates an empty growable 
// list (exactly the same as "<T>[]", so you might want to use the shorter
// literal instead). To create a fixedList-length list with a custom element on
// each index, use "new List.filled(n, filler)".
//
// The change intends to make the fixedList-length list the default List, rather
// than the growable list. As a result, Iterable.toList and LIst.from now
// also create fixedList-length lists unless the optional "growable" named
// parameter is set to true.

print(obj) => obj;

void main() {
  group('fixedList width and const lists', () {
    group('fixedList width list', () {
      var fixedList = new List(3);
      var growable = new List();
      
      test("should not be extensible", () {
        expect(() => fixedList.add(2), throwsUnsupportedError);
        expect(() => fixedList.removeLast(), throwsUnsupportedError);
        expect(() => fixedList.length = 10, throwsUnsupportedError);
      });
      test("should permit the changing of values", () {
        fixedList[0] = 'red';
        fixedList[1] = 'green';
        fixedList[2] = 'blue';
        expect(print(fixedList), equals(['red', 'green', 'blue']));
      });
    });
    
    group('creating const lists', () {
      const List<String> vowels = const ['A', 'E', 'I', 'O', 'U'];

      test("size cannot be changed", () {
        expect(() => vowels.add('Y'), throwsUnsupportedError);
      });
      
      test("content cannot be changed", () {
        expect(() => vowels[0] = 'a', throwsUnsupportedError);     
      });
    });
  });
  
  group('filledList', () {
    test("using filler", () {
      var filledList = new List.filled(3, 'X');
      expect(filledList.every((item) => item == 'X'), isTrue);
      expect(() => filledList.add('Y'), throwsUnsupportedError);
    });
    
    test("using generate", () {
      var arr = [1, 2, 3];
      List<List<String>> grid = new List.generate(3, (_) {
        var temp = arr;
        arr = arr.map((item) => item += 3).toList();
        return temp;
      });
      expect(grid, equals([[1, 2, 3], [4, 5, 6], [7, 8, 9]]));
    });
  });
}

