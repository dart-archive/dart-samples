import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  group("creating a list from another list", () {
    const List<String> vowels1 = const ['A', 'E', 'I', 'O', 'U'];
    var fruit1 = ['orange', 'banana', 'mango'];
    
    group("creating a fixed width list", () {
      var vowelsFixed = new List.from(vowels1, growable: false);
      var fruitFixed = new List.from(fruit1, growable: false);
      
      test("does not allow elements to be added", () {
        expect(() => vowelsFixed.add('Y'), throwsUnsupportedError);
        expect(() => vowelsFixed.add('Y'), throwsUnsupportedError);
      });

      test("allows elements to be modified", () {
        vowelsFixed[0] = 'Y';
        expect(vowelsFixed[0], equals('Y'));
      });
    });
 
    group("creating a growable list", () {
      var vowels2 = new List.from(vowels1);
      var fruit2 = new List.from(fruit1);

      test("allows elements to be added", () {
        vowels2.add('Y');
        expect(print(vowels2), equals(['A', 'E', 'I', 'O', 'U', 'Y']));
      });

      test("allows elements to be modified", () {
        vowels2[0] = 'Y';
        expect(print(vowels2[0]), equals('Y'));
      });
    });

  });
  
  group("common reference", () {
    var fruit1 = ['orange', 'banana', 'mango'];
    var fruit2 = fruit1;
    fruit1.add('kiwi');
    expect(fruit1, equals(fruit2));
    
  });
}