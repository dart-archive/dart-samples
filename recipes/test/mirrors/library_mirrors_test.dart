import 'dart:mirrors';
import 'dart:json';
import 'package:unittest/unittest.dart';

void main() {
  final MirrorSystem ms = currentMirrorSystem();
  LibraryMirror libraryMirror = ms.findLibrary(const Symbol('dart.json')).first;

  test('classes defined', () {
    expect(libraryMirror.classes.keys.map((key) => MirrorSystem.getName(key)).toList(),
        equals(['JsonListener', 'JsonParser', 'JsonUnsupportedObjectError',
                'BuildJsonListener', '_JsonStringifier', 'JsonCyclicError',
                '_Reviver@0x3a1d726e', 'ReviverJsonListener']));
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
}