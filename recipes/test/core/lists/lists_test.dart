library lists_test;

import 'package:unittest/unittest.dart';

class LackingPoint {
  num x;
  num y;
  LackingPoint(this.x, this.y);
}

class Point implements Comparable {
  num x;
  num y;
  Point(this.x, this.y);
 
  String toString() => 'Point: x = $x, y = $y';  
 
  // Sort in dictionary order (one of several arbitrary ways to sort a list
  // of Points).
  int compareTo(other) {
    if (this.x == other.x) {
      if (this.y == other.y) {
        return 0;
      } else if (this.y > other.y) {
        return 1;
      } else {
        return -1;
      }
    } else if (this.x > other.x) {
      return 1;
    } else {
      return -1;
    }
  }
}

void main() {
  group("a fixed-width list", () {
    var fixed = new List(10);

    test("should not be extensible", () {
      expect(() => fixed.add(2), throwsUnsupportedError);
    });

    test("should be filled with the fill value", () {
      expect(fixed.every((item) => item == 0), isTrue);
    });

    test("should permit the changing of the fill value", () {
      fixed[0] = 4;
      expect(fixed.every((item) => item == 0), isFalse);
    });
  });
  
  group("const list", () {
    const List<String> vowels = const ['A', 'E', 'I', 'O', 'U'];

    test("size cannot be changed", () {
      expect(() => vowels.add('Y'), throwsUnsupportedError);      
    });
    
    test("item cannot be changed", () {
      expect(() => vowels[0] = 'a', throwsUnsupportedError);     
    });
  });
  
  group("creating a list from another list", () {
    group("when the other is a const list", () {
      const List<String> vowels = const ['A', 'E', 'I', 'O', 'U'];
      var newList = new List.from(vowels);

      test("allows elements to be added", () {
        newList.add('Y');
        expect(newList[newList.length - 1], equals('Y'));
      });

      test("allows elements to be modified", () {
        newList[0] = 'Y';
        expect(newList[0], equals('Y'));
      });
    });
  });
  
  group("changing the size of a list", () {
    var myList;

    setUp(() {
      myList = [1, 2, 3, 5, 8];
    });

    test('by shortening the list', () {
      myList.length = 2;
      expect(myList, equals([1, 2]));
    });

    test('by lengthening the list', () {
      myList.length += 5;
      expect(myList.getRange(5, 4).every((item) => item == null), isTrue);
    });

    test('is not possible with a fixed length list', () {
      var fixed = new List.fixedLength(10, fill: 0);
      expect(() => fixed.length = 2, throwsUnsupportedError);
    });

    test('is not possible with a const list', () {
      const List<String> vowels = const ['A', 'E', 'I', 'O', 'U'];
      expect(() => vowels.length = 2, throwsUnsupportedError);
    });
  });
  
  group("iterating over the items in a list", () {
    List<int> nums = [0, 1, 2, 3, 5];

    test("using a for loop", () {
      List items = [];
      for (var i = 0; i < nums.length; i++) {
        items.add(nums[i]);
      }
      expect(items, equals(nums));
    });
    
    test("using a for-in", () {
      List items = [];
      for (var item in nums) {
        items.add(item);
      }
      expect(items, equals(nums));
    });
    
    test("using an iterator", () {
      List items = [];
      Iterator iter = nums.iterator;
      
      while(iter.moveNext()) {
        items.add(iter.current);
      }
      expect(items, equals(nums));
    });
    
    test("using ForEach()", () {
      List items = [];
      nums.forEach((fib) {
        items.add(fib % 2);
      });
      expect(items, equals([0, 1, 0, 1, 1]));
    });
  });
  
  group("iterating over a part of a list", () {
    var beatles = ['John', 'Paul', 'George', 'Ringo'];
    
    test("skipping over some elements", () {
      expect(beatles.skip(2).toList(), equals(['George', 'Ringo']));
    });
    
    test("taking only some elements", () {
      expect(beatles.take(2).toList(), equals(['John', 'Paul']));
    });
  });

  group("iterating over a list based on a condition becoming true or false", () {
    var veggies = ["cabbage", "carrots", "onions", "peas", "kale", "peppers"];
    test("take while", () {
      expect(veggies.takeWhile((v) => v != "peas").toList(),
          equals(["cabbage", "carrots", "onions"]));
    });
    
    test("drop while", () {
      expect(veggies.skipWhile((v) => v.length != 4).toList(),
        equals(["peas", "kale", "peppers"]));
    });
  });
  
  group("appending items to a list", () {    
    test("adding a single element", () {
      var myList = [];
      myList.add(3);
      expect(myList, equals([3]));
    });
    
    test("adding several elements", () {
      var myList = [0, 1, 2];
      myList.addAll([4, 5, 6]);
      expect(myList, equals([0, 1, 2, 4, 5, 6]));
    });
    
    test("with a fixed-width list", () {
      var fixed = new List.fixedLength(3, fill: 4);
      expect(() => fixed.add(5), throwsUnsupportedError);
    });
  });
  
  group("inserting items in a list", () {
    
  });
  
  group("removing from the list based on the value of items", () {
    group("remove()", () {
      test('', () {
        var list = [1, 3, 2, 4, 5, 2, 3, 1];
        list.remove(1);
        expect(list, equals([3, 2, 4, 5, 2, 3, 1]));
      });
    });
    
    group("removeAll()", () {
      test("removeAll with 1 item", () {
        var list = [1, 3, 2, 4, 5, 2, 3, 1];
        list.removeAll([1]);
        expect(list, equals([3, 2, 4, 5, 2, 3]));
      });
    
      test("removeAll with several item", () {
        var list = [1, 3, 2, 4, 5, 2, 3, 1];
        list.removeAll([1, 2]);
        expect(list, equals([3, 4, 5, 3]));
      });
    });
    
    group("retainAll()", () {
      test("retainAll with 1 item", () {
        var list = [1, 3, 2, 4, 5, 2, 3, 1];
        list.retainAll([1]);
        expect(list, equals([1, 1]));
      });
    
      test("retainAll with several item", () {
        var list = [1, 3, 2, 4, 5, 2, 3, 1];
        list.retainAll([1, 2]);
        expect(list, equals([1, 2, 2, 1]));
      });
    });
    
    group("removing from the list based on position of items", () {
      var list = [1, 2, 3, 5, 8, 13, 21];
      list.removeRange(1, 4);
      
      test("at a particular position", () {
        expect(list, equals([1, 13, 21]));
      });
      
      test("in a particular range", () {
        var list = [1, 3, 2, 4, 5, 2, 3, 1];
        list.removeAt(4);
        expect(list, equals([1, 3, 2, 4, 2, 3, 1]));
      });
    });
  });

  group("removing elements based on a test", () {
    group("remove elements", () {
      test("using filter", () {
        var list = [1, 2, 3, 5, 8, 13, 21];
        list = list.where((item) => item % 2 != 0).toList();
        expect(list, equals([1, 3, 5, 13, 21]));
      });
      
      test("using removeMatching()", () {
        var list = [1, 2, 3, 5, 8, 13, 21];
        list.removeMatching((item) => item % 2 == 0);
        expect(list, equals([1, 3, 5, 13, 21]));
      });
    });
    
    group("retain elements", () {
      test("using filter", () {
        var list = [1, 2, 3, 5, 8, 13, 21];
        list = list.where((item) => item % 2 == 0).toList();
        expect(list, equals([2, 8]));
      });
      
      test("using retainMatching()", () {
        var list = [1, 2, 3, 5, 8, 13, 21];
        list.retainMatching((item) => item % 2 == 0);
        expect(list, equals([2, 8]));
      });
    });
  });
   
  group("removing all elements", () {
    test('using clear()', () {
      var list = [1, 2, 3, 4];
      list.clear();
      expect(list, equals([])); 
    });
    
    test('using length = 0', () {
      var list = [1, 2, 3, 4];
      list.length = 0;
      expect(list, equals([])); 
    });
  });
  
  group("finding if a list contains an item", () {
    var list = [1, 2, 3, 4];
    
    test("using contains()", () {
      expect(list.contains(2), isTrue);
      expect(list.contains(5), isFalse);
    });
    
    test("using indexOf()", () {
      expect(list.indexOf(2) != -1, isTrue);
      expect(list.indexOf(5) == -1, isTrue);
    });    
  });
  
  group("finding the position of an element in a list", () {
    // list.indexOf(element, start); // -1 if not found
    // list.lastIndexOf(element, start);
  });
  
  group("converting a list to a string", () {
    test("with a null element", () {
      var listWithNull = [3, 4, null, 6];  // "34null6"
      expect(listWithNull.join(''), equals('34null6'));
    });
    test("without an explicit toString()", () {
      var list = [3, 4, new Point(3, 4), 6];
      // expect(list.join(''), equals("34Instance of 'Point'6"));
    });
    test("with an explicit toString()", () {
      var list = [3, 4, new Point(3, 4), 6];
      expect(list.join(' '), equals('3 4 Point: x = 3, y = 4 6'));
    });
  });
  
  group("comparing lists for equality of content", () {});
  
  group("sorting lists", () {
    test("a default ascending sort", () {
      var list = [1, -4, 2];
      list.sort();
      expect(list, equals([-4, 1, 2]));
    });
    
    test("an ascending sort with compareTo()", () {
      var list = [1, -4, 2];
      list.sort((a, b) => a.compareTo(b));
      expect(list, equals([-4, 1, 2]));
    });
    
    test("a descending sort with compareTo()", () {
      var list = [1, -4, 2];
      list.sort((a, b) => b.compareTo(a));
      
      expect(list, equals([2, 1, -4]));
    });
    
    group("custom sort with user defined class", () {
      // Message when compareTo() is not defined:
      //   Caught Class 'Point' has no instance method 'compareTo'.
      
      test("without compareTo", () {
        var list = [new LackingPoint(3, 4), new LackingPoint(3, 5)];
        expect(() => list.sort(), throws); 
      });
      
      test("where a.x == b.x", () {
        var list = [new Point(3, 5), new Point(3, 4)];
        list.sort();
        expect(list.first.x, equals(3));
        expect(list.first.y, equals(4));
      });
      
      test("where a.x < b.x", () {
        var list = [new Point(4, 4), new Point(3, 4)];
        list.sort();
        expect(list.first.x, equals(3));
        expect(list.first.y, equals(4));
      });
    });
  });
}
