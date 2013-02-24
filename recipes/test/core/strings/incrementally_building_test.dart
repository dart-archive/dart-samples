library incrementally_building;

import 'package:unittest/unittest.dart';

void main() {
  group('incrementally building a string using a StringBuffer', () {
    test("using write()", () {
      var sb = new StringBuffer();
      sb.write("John, ");
      sb.write("Paul, ");
      sb.write("George, ");
      sb.write("and Ringo");
      expect(sb.toString(), equals("John, Paul, George, and Ringo"));
    });
    
    test('using several methods', () {
      var sb = new StringBuffer();
      sb.writeln("The Beatles:");
      sb.writeAll(['John, ', 'Paul, ', 'George, and Ringo']);
      sb.writeCharCode(33); // charCode for '!'.
      expect(sb.toString(), equals('The Beatles:\nJohn, Paul, George, and Ringo!'));
    });
  });
}