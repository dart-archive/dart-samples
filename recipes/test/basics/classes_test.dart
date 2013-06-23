import 'package:unittest/unittest.dart';
import 'dart:mirrors';
import 'dart:json' as JSON;


// Getters and Setters
class Rectangle {
  num left;
  num top;
  num width;
  num height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  num get right             => left + width;
      set right(num value)  => left = value - width;
  num get bottom            => top + height;
      set bottom(num value) => top = value - height;
}


// Examples for overloading constructors.
class Point {
  num x, y;
  Point([this.x = 0, this.y = 0]);
}

class PointWithNamedDefaults {
  num x, y;
  PointWithNamedDefaults({this.x: 0, this.y: 0});
}

class PointWithNamedConstructor {
  num x, y;

  PointWithNamedConstructor(this.x, this.y);

  PointWithNamedConstructor.zero(){
    x = 0;
    y = 0;
  }
}

// Examples for calling super.
class Person {
  String name;
  Person(this.name);
}

class Employee extends Person {
  String employeeID;

  Employee(name, employeeID) : super(name) {
    this.employeeID = employeeID;
  }
  String toString() => '$name, $employeeID';
}

class Item {
  String name;
  Item();
  Item.named(this.name);
}

class Widget extends Item {
  String sku;
  Widget(name, this.sku) : super.named(name);
}

// Example for initializing final fields.
class Book {
  final String ISBN;
  Book(String ISBN) : ISBN = ISBN {}
}

// NoSuchMethod
class JsonWithAccessors {
  Map<String, Object> _jsonData;
  JsonWithAccessors(String jsonString) {
    _jsonData = JSON.parse(jsonString);
  }

  noSuchMethod(Invocation invocation) {
    if (invocation.isAccessor) {
      var key = MirrorSystem.getName(invocation.memberName);
      key = key.replaceFirst('=', '');
      if (_jsonData.containsKey(key)) {
        if (invocation.isSetter) {
          _jsonData[key] = invocation.positionalArguments[0];
        } else {
          return _jsonData[key];
        }
      }
      return;
    }

    throw new NoSuchMethodError(this,
        _symbolToString(invocation.memberName),
        invocation.positionalArguments,
        _symbolMapToStringMap(invocation.namedArguments));
  }
}

String _symbolToString(Symbol symbol) => MirrorSystem.getName(symbol);

Map<String, dynamic> _symbolMapToStringMap(Map<Symbol, dynamic> map) {
  if (map == null) return null;
  var result = new Map<String, dynamic>();
  map.forEach((Symbol key, value) {
    result[_symbolToString(key)] = value;
  });
  return result;
}

class Counter {
  int value = 0;

  Counter(this.value);

  call() {
    return value++;
  }
}

// Implementing getters and setters
// Use Rectangle class


// Overloading +
class Complex {
  double real, imag;

  Complex(this.real, this.imag);
  Complex operator+(Complex other) {
    return new Complex(this.real + other.real,this.imag + other.imag);
  }
}

// Factory constructors (CHANGE ALL THE variable names: from Bob Nystrom)
class MyClass {
  final String name;
  static Map<String, MyClass> _cache;

  factory MyClass(String name) {
    if (_cache == null) {
      _cache = {};
    }

    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final myObject = new MyClass._internal(name);
      _cache[name] = myObject;
      return myObject;
    }
  }

  MyClass._internal(this.name);
}

void main() {
  group('Point', () {
    test('default x and y', () {
      Point point = new Point();
      expect(point.x, equals(0));
      expect(point.y, equals(0));
    });

    test('default x', () {
      Point point = new Point(3);
      expect(point.x, equals(3));
      expect(point.y, equals(0));
    });

    test('no defaults', () {
      Point point = new Point(3, 4);
      expect(point.x, equals(3));
      expect(point.y, equals(4));
    });
  });

  group('Point2', () {
    test('default x and y', () {
      PointWithNamedDefaults point = new PointWithNamedDefaults();
      expect(point.x, equals(0));
      expect(point.y, equals(0));
    });

    test('default x', () {
      PointWithNamedDefaults point = new PointWithNamedDefaults(x:3);
      expect(point.x, equals(3));
      expect(point.y, equals(0));
    });

    test('no defaults', () {
      PointWithNamedDefaults point = new PointWithNamedDefaults(x:3, y:4);
      expect(point.x, equals(3));
      expect(point.y, equals(4));
    });
  });

  group('named constructor', () {
    PointWithNamedConstructor point = new PointWithNamedConstructor.zero();
    test('', () {
      expect(point.x, equals(0));
      expect(point.y, equals(0));
    });
  });

  group('Calling super constructor', () {
    test('', () {
      Employee employee = new Employee('John Smith', 'd9d8sfdo');
      expect(employee.name, equals('John Smith'));
      expect(employee.employeeID, 'd9d8sfdo');
    });
  });
}