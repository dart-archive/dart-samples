import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  group("appending items to a names", () {

    test('using add', () {
      var names = ['Seth', 'Timothy', 'John'];
      names.add('Kathy');
      names.add('Mary');
      expect(print(names), equals(['Seth', 'Timothy', 'John', 'Kathy', 'Mary']));
    });
    
    test('using addAll', () {
      var names = ['Seth', 'Timothy', 'John'];
      names.addAll(['Kathy', 'Mary']);
      expect(print(names), equals(['Seth', 'Timothy', 'John', 'Kathy', 'Mary']));
    });
    
    test('using length', () {
      var names = ['Seth', 'Timothy', 'John'];
      var moreNames = ['Kathy', 'Mary'];
      
      var namesLen = names.length;
      names.length += 2;
      expect(print(names), equals(['Seth', 'Timothy', 'John', null, null]));
      
      for (var i = 0; i < moreNames.length; i++) {
        names[i + namesLen] = moreNames[i];
      }
      expect(print(names), equals(['Seth', 'Timothy', 'John', 'Kathy', 'Mary']));
    });
  });
}

