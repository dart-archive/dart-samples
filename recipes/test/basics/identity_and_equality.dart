import 'package:unittest/unittest.dart';

class Employee {
  String name, employeeID;

  Employee(this.employeeID, this.name);

  bool operator ==(Employee other) {
    if (identical(other, this)) return true;
    return (other.employeeID == employeeID);
  }

  int get hashCode {
    int result = 17;
    result = 37 * result + employeeID.hashCode;
    return result;
  }
}

void main() {
  test('equality using ==', () {
    expect('hello'.toUpperCase() == 'HELLO', isTrue);
  });

  test('testing identity', () {
    const List<int> list1 = const [1, 2, 3];
    const List<int> list2 = const [1, 2, 3];

    expect(list1 ==  list2, isTrue);
    expect(identical(list1, list2), isTrue);
  });

  test('', () {
    var mike = new Employee('019583', 'Mike');
    var michael = new Employee('019583', 'Michael');

    expect(mike != michael, isFalse);
    expect(mike == michael, isTrue);
    expect(mike.hashCode == michael.hashCode, isTrue);
    expect(identical(mike, michael), isFalse);

  });
}