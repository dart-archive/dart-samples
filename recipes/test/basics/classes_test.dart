import 'package:unittest/unittest.dart';
import 'dart:mirrors';
import 'dart:json';


class Book {
  final String ISBN;
  Book(String ISBN) : ISBN = ISBN {}
}

class Tool {
  final String brand;
  Tool([brand = 'Makita']) : brand = brand;
}

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


// Getter and setters to replace original fields
class Game {
  bool isBoardLoaded = false;
}

class Game2 {
  bool isBoardLoaded = false;
  Board board;
}

class Board {
  bool isLoaded = false;
  bool hasAllPieces = true;
  // ...
}

class Game3 {
  Board board;

  bool get isBoardLoaded => board.isLoaded;

  void set isBoardLoaded(bool isLoaded) {
    board.isLoaded = isLoaded;
  }
}

// Examples for overloading constructors.
class Point {
  num x, y;
  Point([this.x = 0, this.y = 0]);
}

class Point2 {
  double x = 0.0;
  double y = 0.0;
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

  PointWithNamedConstructor.fromJsonString(String jsonString) {
    var _json = parse(jsonString);
    x = _json['x'];
    y = _json['y'];
  }
}

// Examples for calling super.
class Person {
  String name;
  Person(this.name) {print('Person');}
}

class Employee extends Person {
  String employeeID;

  Employee(name, this.employeeID) : super(name) {
    print('Employee');
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


// NoSuchMethod
class JsonWithAccessors {
  Map<String, Object> _jsonData;
  JsonWithAccessors(String jsonString) {
    _jsonData = parse(jsonString);
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

class GamePiece {
  final String pieceName;
  static Map<String, GamePiece> _cache = {};
  GamePiece._create(this.pieceName);

  factory GamePiece(String pieceName) {
    GamePiece piece = _cache[pieceName];
    if (piece != null) {
      return piece;
    } else {
      piece = new GamePiece._create(pieceName);
      _cache[pieceName] = piece;
      return piece;
    }
  }
}


void main() {
  group('named constructor', () {
    test('identical pieces', () {
      GamePiece piece1 = new GamePiece('monster');
      GamePiece piece2 = new GamePiece('monster');
      expect(identical(piece1, piece2), isTrue);
    });

    test('different pieces', () {
      GamePiece piece1 = new GamePiece('monster');
      GamePiece piece2 = new GamePiece('angel');
      expect(identical(piece1, piece2), isFalse);
    });
  });

  group('final field', () {
    test('', () {
      Book book = new Book('99921-58-10-7');
      print(book.ISBN);
      // book.ISBN = 'asdf';
    });

    test('with default value', () {
      Tool tool = new Tool();
      expect(tool.brand, equals('Makita'));
    });
  });

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
    test('', () {
      Point2 point = new Point2();
      expect(point.x, equals(0.0));
      expect(point.y, equals(0.0));
    });
  });

  group('PointWithNamedDefaults', () {
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

    test('', () {
      point = new PointWithNamedConstructor.fromJsonString('{"x":3, "y":4}');
      expect(point.x, equals(3));
      expect(point.y, equals(4));
    });
  });

  group('Calling super constructor', () {
    test('', () {
      Employee employee = new Employee('John Smith', 'd9d8sfdo');
      expect(employee.name, equals('John Smith'));
      expect(employee.employeeID, 'd9d8sfdo');
    });
  });

  group('noSuchMethod()', () {
    JsonWithAccessors person;
    var jsonPerson = '{"name" : "joe", "date" : [2013, 3, 10]}';

    setUp(() {
      person = new JsonWithAccessors(jsonPerson);
    });

    test('getter', () {
      expect(person.name, equals('joe'));
    });

    test('setter', () {
      person.name = 'mark';
      expect(person.name, equals('mark'));
    });

    test('non-existent field', () {
      expect(person.height, isNull);
    });

    test('method', () {
      expect(() => person.name(), throws);
    });
  });

  group('converting a field to an accessor', () {
    test('game1', () {
       var game = new Game();
       expect(game.isBoardLoaded, isFalse);
    });

    test('game2', () {
      var game = new Game2();
      game.board = new Board();
      expect(game.isBoardLoaded, isFalse);
      expect(game.board.isLoaded, isFalse);
    });

    test('game3 getter', () {
      var game = new Game3();
      game.board = new Board();
      expect(game.isBoardLoaded, isFalse);
    });
  });
}