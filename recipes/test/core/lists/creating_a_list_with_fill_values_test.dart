import 'package:unittest/unittest.dart';

print(obj) => obj;

void main() {
  group('filledList', () {
    test("using filler", () {
      var filledList = new List.filled(3, 'X');
      expect(print(filledList.every((item) => item == 'X')), isTrue);
      expect(() => filledList.add('Y'), throwsUnsupportedError);
    });
    
    test("using generate", () {
      var arr = [1, 2, 3];
      List<List<String>> grid = new List.generate(3, (_) {
        var temp = arr;
        arr = arr.map((item) => item += 3).toList();
        return temp;
      });
      expect(print(grid), equals([[1, 2, 3], [4, 5, 6], [7, 8, 9]]));
    });
  });
}