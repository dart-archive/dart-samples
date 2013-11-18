import 'package:unittest/unittest.dart';

String greet(to, from, [greeting = 'Hello']) => '$greeting from $from to $to!';

String greet2(to, from, {greeting:'Hello'}) => '$greeting from $from to $to!';

void main() {
  test('greet', () {
    expect(greet('John', 'Mary', 'Ola'), equals('Ola from Mary to John!'));
    expect(greet('John', 'Mary'), equals('Hello from Mary to John!'));
  });

  test('greet2', () {
    expect(greet2('John', 'Mary', greeting:'Ola'), equals('Ola from Mary to John!'));
    expect(greet('John', 'Mary'), equals('Hello from Mary to John!'));
  });
}
