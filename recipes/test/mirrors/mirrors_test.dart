import 'dart:mirrors';
import 'package:unittest/unittest.dart';
import 'dart:json';

class SomeClass {
  static int someNum = 42;
  static int staticMethod() => someNum;
  static int get staticGetter => someNum;
  static void set staticSetter(int value) {
    someNum = value;
  }
}

class ExampleClass implements Comparable {
  int compareTo(ExampleClass obj) {}
}

class ChildExampleClass extends ExampleClass {}

class MyClass {
  static int get getSomeStaticValue => _someStaticValue;
  static set setSomeStaticValue(int value) => _someStaticValue = value;
  static int _someStaticValue = -42;
  static int someStaticMethod() => 42;
  String someMethod() => '';
}

class Person {
  String firstName, lastName;
  int age;
  static int personCount = 0;
  static List<Person> personsNamedBob() => [];
  Person(this.firstName, this.lastName, this.age);
  String get name => '$firstName $lastName';
  bool canVote() => age >= 18;
  bool sameNameAs(Person other) => firstName == other.firstName && lastName == other.lastName;
}

class Student {
  String studentId;
  Student(this.studentId);
  bool hasRegistered() => false;
  bool enrolledIn(String classId) => false;
}



class Point {
  num x, y;
  Point(this.x, this.y);

  Point.fromJson(String json) {
    var data = parse(json);
    x = data['x'];
    y = data['y'];
  }
}

class Parent{static int foo() => 42;}
class Child extends Parent {}


bool hasMethod(obj, symbol) {
  ClassMirror classMirror = reflect(obj).type;
  return _hasMethod(classMirror, symbol);
}

bool _hasMethod(classMirror, symbol) {
  Mirror memberMirror = classMirror.methods[symbol];
  if (memberMirror != null && !memberMirror.isStatic) {
    return true;
  } else  {
    if (MirrorSystem.getName(classMirror.simpleName) == 'Object') {
      return false;
    }
  }
  return _hasMethod(classMirror.superclass, symbol);
}

Iterable classHierarchy(object) {
  List<Symbol> ancestorClasses = [];
  ClassMirror classMirror = reflect(object).type;
  while (classMirror.simpleName != const Symbol('Object')) {
    classMirror = classMirror.superclass;
    ancestorClasses.add(classMirror.simpleName);
  }
  return ancestorClasses;
}


class A {}
class B extends A {}
class C extends B {}

class Rectangle {
  num left;
  num top;
  num width;
  num height;

  Rectangle(this.left, this.top, this.width, this.height);

  Rectangle.square(num dimension) {
    left = dimension;
    top = dimension;
    width = dimension;
    height = dimension;
  }

  num get right             => left + width;
      set right(num value)  => left = value - width;
  num get bottom            => top + height;
      set bottom(num value) => top = value - height;

  String toString() => 'left=$left, right=$right, top=$top, bottom=$bottom';
}

void main() {
  group('creating', () {
    Rectangle rectangle;
    setUp(() {
      rectangle = new Rectangle(3, 4, 20, 30);
    });

    test('instance mirror using reflect()', () {
      InstanceMirror rectangleMirror = reflect(rectangle);
      expect(rectangleMirror is InstanceMirror, isTrue);
      expect(rectangleMirror.reflectee, equals(rectangle));
    });

    test('library mirror', () {
      final MirrorSystem mirrorSystem = currentMirrorSystem();
      var libraryMirror = mirrorSystem.findLibrary(const Symbol('dart.core')).first;
      expect(libraryMirror is LibraryMirror, isTrue);
      expect(MirrorSystem.getName(libraryMirror.simpleName), equals('dart.core'));
    });

    test('class mirror from instance mirror', () {
      var instanceMirror = reflect(rectangle);
      var classMirror = instanceMirror.type;
      expect(classMirror is ClassMirror, isTrue);
      expect(MirrorSystem.getName(classMirror.simpleName), 'Rectangle');
    });

    test('class mirror from instance mirror using reflectClass() ', () {
      var classMirror = reflectClass(rectangle.runtimeType);
      expect(MirrorSystem.getName(classMirror.simpleName), 'Rectangle');
    });

    test('class mirror from library mirror', () {
      final MirrorSystem mirrorSystem = currentMirrorSystem();
      var libraryMirror = mirrorSystem.findLibrary(const Symbol('dart.core')).first;

      var classMirror = libraryMirror.classes[const Symbol('StringBuffer')];
      expect(classMirror.simpleName, equals(const Symbol('StringBuffer')));
      expect(MirrorSystem.getName(classMirror.simpleName), equals('StringBuffer'));
    });
  });

  Rectangle rectangle;
  InstanceMirror instanceMirror;
  ClassMirror classMirror;

  group('instance mirrors', () {
    setUp(() {
      rectangle = new Rectangle(3, 4, 20, 30);
      instanceMirror = reflect(rectangle);
    });

    group('using getters and setters', () {
      test('getField', () {
        expect(instanceMirror.getField(const Symbol('left')).reflectee, equals(3));
        expect(instanceMirror.getField(const Symbol('right')).reflectee,
            equals(23));
      });

      test('setField', () {
        instanceMirror.setField(const Symbol('left'), 10);
        expect(instanceMirror.getField(const Symbol('left')).reflectee, equals(10));
        instanceMirror.setField(const Symbol('right'), 21);
        expect(instanceMirror.getField(const Symbol('right')).reflectee, equals(21));
      });

      test('getFieldAsync with implicit getter', () {
        instanceMirror.getFieldAsync(const Symbol('left'))
          .then(expectAsync1((mirror) {
            expect(mirror.reflectee, equals(3));
          }));
      });

      test('getFieldAsync with explicit getter', () {
        instanceMirror.getFieldAsync(const Symbol('right'))
        .then(expectAsync1((mirror) {
          expect(mirror.reflectee, equals(23));
        }));
      });

      test('setFieldAsync with implicit setter', () {
        instanceMirror.setFieldAsync(const Symbol('left'), 10)
        .then(expectAsync1((_) {
          expect(rectangle.left, equals(10));
        }));
      });

      test('setFieldAsync with explicit setter', () {
        instanceMirror.setFieldAsync(const Symbol('right'), 21)
        .then(expectAsync1((_) {
          expect(rectangle.right, equals(21));
        }));
      });

      test('static getter', () {
        var myObj = new MyClass();
        var classMirror = reflect(myObj).type;
        expect(classMirror.getField(const Symbol('getSomeStaticValue')).reflectee,
            equals(MyClass._someStaticValue));
      });

      test('static setter', () {
        var myObj = new MyClass();
        var classMirror = reflect(myObj).type;
        classMirror.setField(const Symbol('setSomeStaticValue'), -420);
        expect(classMirror.getField(const Symbol('getSomeStaticValue')).reflectee,
            equals(-420));
      });
    });

    group('calling a function or a method', () {
      test('using instance mirror', () {
        var myObject = new MyClass();
        var instanceMirror = reflect(myObject);
        expect(instanceMirror.invoke(const Symbol('someMethod'), []).reflectee,
            equals(''));
      });

      test('using class mirror', () {
        var myObject = new MyClass();
        var classMirror = reflect(myObject).type;
        expect(classMirror.invoke(const Symbol('someStaticMethod'), []).reflectee,
            equals(42));
      });

      test('using library mirror', () {
        final MirrorSystem ms = currentMirrorSystem();
        var libraryMirror = ms.findLibrary(const Symbol('dart.json')).first;
        var jsonPerson = '{"name" : "joe", "date" : [2013, 3, 10]}';
        var person = parse(jsonPerson);
        expect(person['name'], equals('joe'));

        person = libraryMirror.invoke(const Symbol('parse'), [jsonPerson]).reflectee;
        expect(person['name'], equals('joe'));
      });
    });

    group('ClassMirror#members', () {
      test('', () {
        var person = new Person('Jeff', 'Lebowski', 50);
        var classMirror = reflect(person).type;
        var memberList = classMirror.members.keys.toList().map((item) {
          return MirrorSystem.getName(item);
        }).toList();

        memberList.sort();
        expect(memberList,
            equals(['age', 'canVote', 'firstName', 'lastName', 'name',
                    'personCount', 'personsNamedBob', 'sameNameAs']));
      });
    });

    group('checking instance method exists', () {
      test('using the methods map', () {
        Person person = new Person('Jeff', 'Lebowski', 50);
        ClassMirror classMirror = reflect(person).type;
        expect(classMirror.methods[const Symbol('firstName')], isNull);
        expect(classMirror.methods[const Symbol('name')], isNull);
        expect(classMirror.methods[const Symbol('somethingBogus')], isNull);
        expect(classMirror.methods[const Symbol('toString')], isNull);
        expect(classMirror.methods[const Symbol('personCount')], isNull);
      });

      test('using hasMethod()', () {
        Person person = new Person('Jeff', 'Lebowski', 50);
        ClassMirror classMirror = reflect(person).type;
        expect(hasMethod(person, const Symbol('sameNameAs')), isTrue);
        expect(hasMethod(person, const Symbol('firstName')), isFalse);
        expect(hasMethod(person, const Symbol('lastName')), isFalse);
        expect(hasMethod(person, const Symbol('name')), isFalse);
        expect(hasMethod(person, const Symbol('toString')), isTrue);
        expect(hasMethod(person, const Symbol('runtimeType')), isFalse);
        expect(hasMethod(person, const Symbol('somethingBogus')), isFalse);
        expect(hasMethod(person, const Symbol('personCount')), isFalse);
      });

      test('using hasMethod() with static members', () {
        Parent x = new Parent();
        Child y = new Child();
        ClassMirror classMirror = reflect(x).type;
        expect(classMirror.members[const Symbol('foo')], isNotNull);
        expect(hasMethod(x, const Symbol('foo')), isFalse);
        expect(hasMethod(y, const Symbol('foo')), isFalse);
        expect(hasMethod(y, const Symbol('toString')), isTrue);

      });
    });
  });


  group('class mirrors', () {
    setUp(() {
      rectangle = new Rectangle(3, 4, 20, 30);
      instanceMirror = reflect(rectangle);
      classMirror = instanceMirror.type;
    });

    group('creating new instance', () {
      test('using the normal constructor', () {
        var point = new Point(1, 2);
        var classMirror = reflect(point).type;

        var point2 = classMirror.newInstance(const Symbol(''), [3, 4]).reflectee;
        expect(point2.x, equals(3));
        expect(point2.y, equals(4));
      });

      test('using a named constructor', () {
        var point = new Point(1, 2);
        var classMirror = reflect(point).type;
        var point2 = classMirror.newInstance(const Symbol('fromJson'),
            ['{"x":3,"y":4}']).reflectee;
        expect(point2.x, equals(3));
        expect(point2.y, equals(4));
      });

      test('using a newInstanceAsync()', () {
        var point = new Point(1, 2);
        var classMirror = reflect(point).type;
        var point2;
        classMirror.newInstanceAsync(const Symbol('fromJson'), ['{"x":3,"y":4}'])
          .then((mirror) {
            point2 = mirror.reflectee;
            assert(point2.x == 3 && point2.y == 4);
          });
      });
    });

    test('responding to a constructor', () {
      Point point = new Point(3, 4);
      ClassMirror classMirror = reflect(point).type;
      expect(classMirror.constructors[const Symbol('Point.fromJson')], isNotNull);
      expect(classMirror.constructors[const Symbol('Point')], isNotNull);
    });

    test('responding to a constructor using simpleName', () {
      Point point = new Point(3, 4);
      ClassMirror classMirror = reflect(point).type;
      String className = MirrorSystem.getName(classMirror.simpleName);
      expect(classMirror.constructors[new Symbol('${className}.fromJson')], isNotNull);
      expect(classMirror.constructors[new Symbol(className)], isNotNull);
    });

    test('getting a list of instance variables', () {});


    group('getting the interfaces implemented by a class', () {


      test('', () {
        ClassMirror classMirror = reflect(new ExampleClass()).type;
        expect(classMirror.superinterfaces.map((interface) {
          return MirrorSystem.getName(interface.simpleName);
        }).toList(), equals(['Comparable']));
      });

      test('inheritance', () {
        ClassMirror classMirror = reflect(new ChildExampleClass()).type;
        expect(classMirror.superinterfaces.map((interface) {
          return MirrorSystem.getName(interface.simpleName);
        }).toList(), equals([]));
      });
    });

    group('getting the superclass of a class', () {
      test('', () {
        classMirror = reflect(new C()).type;

        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('B'));

        classMirror = classMirror.superclass;
        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('A'));

        classMirror = classMirror.superclass;
        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('Object'));

        List<String> hierarchy = classHierarchy(new C()).map((symbol) => MirrorSystem.getName(symbol)).toList();
        expect(hierarchy, equals(['B', 'A', 'Object']));
        expect(hierarchy.indexOf(new A().runtimeType.toString()) != -1, isTrue);
        expect(hierarchy.indexOf(new List().runtimeType.toString()) == -1, isTrue);
      });

      test('object', () {
        classMirror = reflect(new Object()).type;

        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('Object'));
      });


      test('map', () {
        classMirror = reflect(new Map()).type;

        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('Object'));
      });

      test('set', () {
        classMirror = reflect(new Set()).type;

        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('_HashSetBase'));

        classMirror = classMirror.superclass;
        expect(MirrorSystem.getName(classMirror.superclass.simpleName),
            equals('IterableBase'));

        expect(MirrorSystem.getName(classMirror.superclass.superclass.superclass.simpleName),
            equals('Object'));

        expect(classHierarchy(new Set()).map((klass) => MirrorSystem.getName(klass)).toList(),
            equals(['_HashSetBase', 'IterableBase', 'Object']));
      });
    });

    group('getting interfaces implemented by this class', () {
      test('getting a list of interfaces implemented', () {
        classMirror = reflect([]).type;
        expect(MirrorSystem.getName(classMirror.superinterfaces.first.simpleName),
            equals('Iterable'));
      });
    });

    group('dealing with static members', () {
      SomeClass someObject;
      ClassMirror classMirror;

      setUp(() {
        someObject = new SomeClass();
        classMirror = reflect(someObject).type;
      });

      test('', () {

        expect(classMirror.getField(const Symbol('someNum')).reflectee,
            equals(42));
        expect(classMirror.getField(const Symbol('staticGetter')).reflectee,
            equals(42));

        classMirror.setField(const Symbol('staticSetter'), 20);
        expect(classMirror.getField(const Symbol('staticGetter')).reflectee,
            equals(20));

        expect(classMirror.invoke(const Symbol('staticMethod'),[]).reflectee,
            equals(20));
      });
    });
  });

  group('constructors', () {
    test('', () {
      var point = new Point(3, 4);
      var instanceMirror = reflect(point);
      var classMirror = instanceMirror.type;
      expect(classMirror.constructors.keys.map((symbol) {
        return MirrorSystem.getName(symbol);
      }), equals(['Point', 'Point.fromJson']));
    });

    test('', () {
      final MirrorSystem ms = currentMirrorSystem();
      LibraryMirror libraryMirror = ms.findLibrary(const Symbol('dart.core')).first;
      ClassMirror classMirror = libraryMirror.classes[const Symbol('List')];
      expect(classMirror.constructors[const Symbol('List')], isNotNull);
    });
  });

  group('parameters', () {
    test('', () {
      Student student = new Student('8dj3kd12L');
      ClassMirror classMirror = reflect(student).type;
      MethodMirror methodMirror = classMirror.methods[const Symbol('hasRegistered')];
      expect(methodMirror.parameters.length, equals(0));
      methodMirror = classMirror.methods[const Symbol('enrolledIn')];
      expect(methodMirror.parameters.length, equals(1));
      MethodMirror toStringMirror = classMirror.methods[const Symbol('toString')];
      expect(() => toStringMirror.parameters.length, throws);
    });
  });

  group('getting the name of the reflected object', () {
    test('', () {
      LibraryMirror libraryMirror = currentMirrorSystem().findLibrary(
          const Symbol('dart.json')).first;
      expect(libraryMirror.simpleName, equals(const Symbol('dart.json')));
      expect(libraryMirror.qualifiedName, equals(const Symbol('dart.json')));

      ClassMirror classMirror = libraryMirror.classes[const Symbol('JsonParser')];
      expect(classMirror.simpleName, equals(const Symbol('JsonParser')));
      expect(classMirror.qualifiedName, equals(const Symbol('dart.json.JsonParser')));

      MethodMirror methodMirror = classMirror.members[const Symbol('parseNumber')];
      expect(methodMirror.simpleName,
          equals(const Symbol('parseNumber')));
      expect(methodMirror.qualifiedName,
          equals(const Symbol('dart.json.JsonParser.parseNumber')));
    });
  });

  group('libraries', () {
    final MirrorSystem mirrorSystem = currentMirrorSystem();
    LibraryMirror libraryMirror = mirrorSystem.findLibrary(const Symbol('dart.json')).first;

    test('libraries loaded', () {
      List<Symbol> libraryNames = new List<Symbol>();
      mirrorSystem.libraries.forEach((Uri libraryUri, LibraryMirror library) {
        libraryNames.add(library.simpleName);
      });
      expect(libraryNames.indexOf(const Symbol('dart.mirrors')), greaterThan(1));
    });

    test('classes defined', () {
      expect(libraryMirror.classes.keys.map((key) => MirrorSystem.getName(key)).toList(),
          equals(['JsonListener', 'JsonParser', 'JsonUnsupportedObjectError',
                  'BuildJsonListener', '_JsonStringifier', 'JsonCyclicError',
                  '_Reviver@0x3a1d726e', 'ReviverJsonListener']));
    });

    test('isPrivate', () {
      expect(libraryMirror.classes[const Symbol('JsonListener')].isPrivate,
          isFalse);

    });


    test('get a class mirror', () {
      var classMirror = libraryMirror.classes[const Symbol('JsonListener')];
      expect(MirrorSystem.getName(classMirror.simpleName), equals('JsonListener'));
    });

    test('what functions are defined', () {
      expect(libraryMirror.functions.keys.map((key) => MirrorSystem.getName(key)).toList(),
          equals(['_parse', 'parse', 'printOn', 'stringify']));
      expect(libraryMirror.functions[const Symbol('stringify')] is MethodMirror, isTrue);
      expect(MirrorSystem.getName(libraryMirror.functions[const Symbol('stringify')].qualifiedName),
          equals('dart.json.stringify'));
      expect(MirrorSystem.getName(libraryMirror.functions[const Symbol('stringify')].simpleName),
          equals('stringify'));
    });

    test('getters and setters', () {
      expect(libraryMirror.getters, equals({}));
      expect(libraryMirror.setters, equals({}));
    });

    test('variables', () {
      expect(libraryMirror.variables, equals({}));
    });

    test('invoke a function', () {
      var jsonPerson = '{"name" : "joe", "date" : [2013, 3, 10]}';
      var person = parse(jsonPerson);
      expect(person['name'], equals('joe'));

      person = libraryMirror.invoke(const Symbol('parse'), [jsonPerson]).reflectee;
      expect(person['name'], equals('joe'));
    });
  });
}