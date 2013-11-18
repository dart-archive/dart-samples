library strings_test;

import 'package:unittest/unittest.dart';

String filmToWatch() => 'The Big Lebowski';

class Point {
  int x, y;
  Point(this.x, this.y);
}

class PointWithToString {
  int x, y;
  PointWithToString(this.x, this.y);

  String toString() => 'x: $x, y: $y';
}

var data = [{'scheme': 'https', 'domain': 'news.ycombinator.com'},
            {'domain': 'www.google.com'},
            {'domain': 'reddit.com', 'path': 'search', 'params': 'q=dart'}
            ];

String assembleUrisUsingStringBuffer(data) {
  StringBuffer sb = new StringBuffer();
  for (final item in data) {
    sb.write(item['scheme'] != null ? item['scheme']  : 'http');
    sb.write("://");
    sb.write(item['domain']);
    sb.write('/');
    sb.write(item['path'] != null ? item['path']  : '');
    if (item['params'] != null) {
      sb.write('?');
      sb.write(item['params']);
    }
    sb.write('\n');
  }
  return sb.toString();
}

String assembleUrisUsingConcatenation(data) {
  var uris = '';
  for (final item in data) {
    uris += item['scheme'] != null ? item['scheme']  : 'http';
    uris += "://";
    uris += item['domain'];
    uris += '/';
    uris += item['path'] != null ? item['path']  : '';
    if (item['params'] != null) {
      uris += '?';
      uris += item['params'];
    }
    uris += '\n';
  }
  return uris;
}

var emptyString = '';
var clef = '\u{1D11E}';

void main() {
  group('concatenating strings', () {
    group('using +', () {
      test('', () {
        expect('Dart ' + 'is ' + 'fun!', equals('Dart is fun!'));
      });

      test('over many lines', () {
        expect('Dart ' +
            'is '
            'fun!', equals('Dart is fun!'));
      });

      test('over one or many lines', () {
        expect('Dart ' + 'is ' +
            'fun!', equals('Dart is fun!'));
      });

      test('using multiline strings', () {
        expect('''Peanut
butter ''' +
'''and
jelly''', equals('Peanut\nbutter and\njelly'));
      });

      test('combining single and multiline string', () {
        expect('Dewey ' + 'Cheatem'
            ''' and
Howe''', equals('Dewey Cheatem and\nHowe'));
      });
    });

    group('using adjacent string literals', () {
      test('on one line', () {
        expect('Dart ' 'is ' 'fun!', equals('Dart is fun!'));
      });

      test('over many lines', () {
        expect('Dart '
            'is '
            'fun!', equals('Dart is fun!'));
      });

      test('over one or many lines', () {
        expect('Dart ' 'is '
            'fun!', equals('Dart is fun!'));
      });

      test('using multiline strings', () {
        expect('''Peanut
butter '''
'''and
jelly''', equals('Peanut\nbutter and\njelly'));
      });

      test('combining single and multiline string', () {
        expect('Dewey ' 'Cheatem'
            ''' and
Howe''', equals('Dewey Cheatem and\nHowe'));
      });
    });

    group('using alternatives to string literals', () {
      test(': join()', () {
        expect(['The', 'Big', 'Lebowski'].join(' '), equals('The Big Lebowski'));
      });
    });
  });

  group('interpolating expressions', () {
    test('without {}', () {
      var favfood = 'sushi';
      expect('i love ${favfood.toUpperCase()}', equals('i love SUSHI'));
      expect('i love $favfood', equals('i love sushi'));
    });

    test('with implicit tostring()', () {
      var four = 4;
      expect('the $four seasons', equals('the 4 seasons'));
      expect('the ' + 4.toString() + ' seasons', equals('the 4 seasons'));

      var point = new Point(3, 4);
      expect('point: $point', equals("point: Instance of 'Point'"));
    });

    test('with explicit toString()', () {
      var point = new PointWithToString(3, 4);
      expect('point: $point', equals('point: x: 3, y: 4'));
    });
  });

  group('escaping characters', () {
    var name = '''Wile
Coyote''';

    test('using an escape character', () {
      expect('Wile\nCoyote', equals('''Wile
Coyote'''));
    });

    test('using hex notation', () {
      expect('Wile\x0ACoyote', equals('''Wile
Coyote'''));
    });

    test('using unicode notation', () {
      expect('Wile\u000ACoyote', equals('''Wile
Coyote'''));
      expect('Wile\u{000A}Coyote', equals('''Wile
Coyote'''));
    });

    test('with non-special character', () {
      expect('Wile \E Coyote', equals('Wile E Coyote'));
    });

    test('with a variable', () {
      var superGenius = 'Wile Coyote';
      expect('\$superGenius', equals(r'$superGenius'));
    });
  });

  group('incrementally building a string', () {
    group('using a StringBuffer', () {
      test('using write()', () {
        expect(assembleUrisUsingStringBuffer(data), equals('''https://news.ycombinator.com/
http://www.google.com/
http://reddit.com/search?q=dart
'''));
    });
      test('using several methods', () {
        var sb = new StringBuffer();
        sb.writeln('The Beatles:');
        sb.writeAll(['John, ', 'Paul, ', 'George, and Ringo']);
        sb.writeCharCode(33); // charCode for '!'.
        expect(sb.toString(), equals('The Beatles:\nJohn, Paul, George, and Ringo!'));
      });
    });

    group('using concatenation', () {
      test('', () {
        expect(assembleUrisUsingConcatenation(data), equals('''https://news.ycombinator.com/
http://www.google.com/
http://reddit.com/search?q=dart
'''));
      });
    });
  });


  group('converting between string characters and numerical codes', () {
    var smileyFace = '\u263A';
    var clef = '\u{1D11E}';

    group('using runes', () {
      test('', () {
        expect('Dart'.runes.toList(), equals([68, 97, 114, 116]));

        expect(smileyFace.runes.toList(), equals([9786]));
        expect(smileyFace.runes.first.toRadixString(16), equals('263a'));

        expect(clef.runes.toList(), equals([119070]));
        expect(clef.runes.first.toRadixString(16), equals('1d11e'));
      });
    });

    group('using codeUnits', () {
      test('', () {
        expect('Dart'.codeUnits.toList(), equals([68, 97, 114, 116]));

        expect(smileyFace.codeUnits.toList(), equals([9786]));
        expect(smileyFace.codeUnits.first.toRadixString(16), equals('263a'));

        expect(clef.codeUnits.toList(), equals([55348, 56606]));
        expect(clef.codeUnits.map((codeUnit) => codeUnit.toRadixString(16))
          .toList(), equals(['d834', 'dd1e']));
      });
    });

    group('using codeUnitAt', () {
      test('', () {
        expect('Dart'.codeUnitAt(0), equals(68));

        expect(smileyFace.codeUnitAt(0), equals(9786)); // 9786
        expect(smileyFace.codeUnitAt(0).toRadixString(16), equals('263a'));

        expect(clef.codeUnitAt(0), equals(55348));
        expect(clef.codeUnitAt(0).toRadixString(16), equals('d834'));
        expect(clef.codeUnitAt(1), equals(56606));
       expect(clef.codeUnitAt(1).toRadixString(16), equals('dd1e'));
      });
    });

    group('using fromCharCodes', () {
      var heart = '\u2661';

      test('', () {
        expect(new String.fromCharCodes([68, 97, 114, 116]), equals('Dart'));
        expect(new String.fromCharCodes([73, 32, 9825, 32, 76, 117, 99, 121]),
            equals("I $heart Lucy"));
      });

      test('', () {
        expect(new String.fromCharCodes([9786]), equals(smileyFace));
      });

      test('with surrogate pair codeUnits', () {
        expect(new String.fromCharCodes([55348, 56606]), equals(clef));
      });

      test('with rune', () {
        expect(new String.fromCharCode(119070), equals(clef));
      });
    });

    group('using fromCharCode', () {
      test('', () {
        expect(new String.fromCharCode(68), equals('D'));
        expect(new String.fromCharCode(9786), equals(smileyFace));
        expect(new String.fromCharCode(119070), equals(clef));
      });
    });
  });



  group('determining if string is empty', () {
    test('using isEmpty', () {
      expect(emptyString.isEmpty, isTrue);
    });

    test('using isNotEmpty', () {
      expect(emptyString.isNotEmpty, isFalse);
    });

    test('using ==', () {
      var string = "asdf";
      expect(string == emptyString, isFalse);
    });

    test('if string contains a space', () {
      var space = ' ';
      expect(space.isEmpty, isFalse);
    });
  });


  group('trimming whitespace from a string', () {
    var space = '\n\r\f\t\v';
    var string = '$space X $space';

    test('', () {
      expect(string.trim(), equals('X'));
    });

    test('leading whitespace', () {
      expect(string.replaceFirst(new RegExp(r'^\s+'), ''), equals('X $space'));
    });

    test('trailing whitespace', () {
      expect(string.replaceFirst(new RegExp(r'\s+$'), ''), equals('$space X'));
    });
  });


  group('calculating the length of a string', () {
    print(obj) => obj;

    var hearts = '\u2661';

    test('that contains only BMP symbols', () {
      expect('I love music'.length, equals(12));
      expect('I love music'.runes.length, equals(12));

      expect(hearts.length, equals(1));
      expect(hearts.runes.length, equals(1));
    });

    test('that contains non-BMP symbols', () {
      var clef = '\u{1D11E}';
      expect(clef.length, equals(2));
      expect(clef.runes.length, equals(1));

      var music = 'I $hearts $clef';
      expect(music.length, equals(6));
      expect(music.runes.length, equals(5));
    });

    test('that has superimposed characters', () {
      var name = 'Ameli\u00E9';  // 'Amelié'
      var anotherName = 'Ameli\u0065\u0301';  // 'Amelié'
      expect(print(name.length), equals(6));
      expect(print(anotherName.length), equals(7));
    });
  });

  group('getting the character at a specific index', () {
    group("with non-BMP symbol", () {
      test('with non-BMP symbol', () {
        var coffee = '\u{1F375}';
        expect(coffee.runes.toList(), equals([127861]));
        expect(new String.fromCharCode(coffee.runes.first),
          equals(coffee));
        // Cannot use coffee[0] directly.
        expect(coffee.codeUnits.first, equals(55356));
        expect(coffee.codeUnits.toList()[0], equals(55356));
      });
    });

    group('with BMP symbol', () {

      test('with BMP symbols', () {
        expect('Dart'[0], equals('D'));

        var hearts = '\u2661';
        expect(hearts[0], equals('\u2661'));
      });
    });
  });

  group('processing a string one character at a time', () {
print(obj) {
  return obj;
}
    var clef = '\u{1D11E}';
    var lang= 'Dart';

    group('using split', () {
      test('on code-unit boundary', () {
        expect(lang.split('').map((char) => '*${char}*').toList(),
            equals(['*D*', '*a*', '*r*', '*t*']));

        var smileyFace = '\u263A';
        var happy = 'I am $smileyFace';
        expect(print(happy.split('')), equals(['I', ' ', 'a', 'm', ' ', '☺']));
        expect(clef.split('').length, equals(2));
      });
    });

    group('indexing the string in a loop', () {
      test('', () {
        var list = [];
        for(var i = 0; i < lang.length; i++) {
          list.add('*${lang[i]}*');
        }
        expect(list, equals(['*D*', '*a*', '*r*', '*t*']));
      });

      test('with an extended character', () {
        var list = [];
        for(var i = 0; i < clef.length; i++) {
          list.add([clef[i], clef[i].runes.first]);
        }
        // Because we are dealing with invalid strings, this test can never pass.
        // expect(print(list.last), equals([[?, 55348], [?, 56606]]));
      });
    });

    group('mapping runes', () {
      test('', () {
        expect(lang.runes.map((rune) => '*${new String.fromCharCode(rune)}*').toList(),
            equals(['*D*', '*a*', '*r*', '*t*']));

        var smileyFace = '\u263A';
        var happy = 'I am $smileyFace';
        expect(happy.runes.map((rune) => [rune, new String.fromCharCode(rune)]).toList(),
            equals([ [73, 'I'], [32, ' '], [97, 'a'], [109, 'm'], [32, ' '], [9786, '☺'] ]));

        var subject = '$clef list:';
        expect(subject.runes.map((rune) => new String.fromCharCode(rune)).toList(),
            equals(['𝄞', ' ', 'l', 'i', 's', 't', ':']));
      });
    });
  });


  group('splitting a string', () {
    var clef = '\u{1F3BC}';
    var smileyFace = '\u263A';
    var happy = 'I am $smileyFace';

    group('using split(string)', () {
      test('on code-unit boundary', () {
        expect(happy.split(' '), equals(['I', 'am', '☺']));
      });
    });

    group('using split(regExp)', () {
      var nums = '2/7 3 4/5 3~/5';
      var numsRegExp = new RegExp(r'(\s|/|~/)');
      test('', () {
        expect(nums.split(numsRegExp),
          equals(['2', '7', '3', '4', '5', '3', '5']));
      });
    });

    group('using splitMapJoin(regExp)', () {
      expect('Eats SHOOTS leaves'.splitMapJoin((new RegExp(r'SHOOTS')),
          onMatch: (m) => '*${m.group(0).toLowerCase()}*',
          onNonMatch: (n) => n.toUpperCase()
      ), equals('EATS *shoots* LEAVES'));
    });
  });

  group('changing string case', () {
    var theOneILove = 'I love Lucy!';

    test('with toUpperCase()', () {
      expect(theOneILove.toUpperCase(), equals('I LOVE LUCY!'));
    });

    test('with toLowerCase()', () {
      expect(theOneILove.toLowerCase(), equals('i love lucy!'));
    });

    test('with bicameral characters', () {
      var zeus = '\u0394\u03af\u03b1\u03c2'; // Δίας
      var resume = '\u0052\u00e9\u0073\u0075\u006d\u00e9'; // Résumé
      expect(zeus.toLowerCase(), equals('δίας'));
      expect(zeus.toUpperCase(), equals('ΔΊΑΣ'));
      expect(resume.toLowerCase(), equals('résumé'));
      expect(resume.toUpperCase(), equals('RÉSUMÉ'));
    });

    test('with unicameral characters', () {
      var chickenKebab = '\u091a\u093f\u0915\u0928 \u0915\u092c\u093e\u092c';
      // चिकन कबाब
      expect(chickenKebab.toLowerCase(), equals(chickenKebab));
      expect(chickenKebab.toUpperCase(), equals(chickenKebab));
    });
  });


  group('determining whether a string contains a substring', () {
    var fact = 'Dart strings are immutable';

    test('using contains', () {
      expect(fact.contains('immutable'), isTrue);
      expect(fact.contains('Dart', 2), isFalse);
    });

    test('using startsWith()', () {
      expect(fact.startsWith('Dart'), isTrue);
    });

    test('using endsWith()', () {
      assert(fact.endsWith('e') == true);
    });

    test('using indexOf()', () {
      expect(fact.indexOf('art') != -1, isTrue);
    });

    test('using hasMatch()', () {
      expect(new RegExp(r'ar[et]').hasMatch(fact), isTrue);
    });
  });

  group('finding regExp matches', () {
    var neverEatingThat = 'Not with a fox, not in a box';
    var regExp = new RegExp(r'[fb]ox');

    test('using allMatches()', () {
      Iterable matches = regExp.allMatches(neverEatingThat);
      expect(matches.map((match) => match.group(0)).toList(), equals(['fox', 'box']));
      expect(matches.length, equals(2));
    });

    test('using firstMatch()', () {
      expect(regExp.firstMatch(neverEatingThat).group(0), equals('fox'));
    });

    test('using neverEatingThatMatch', () {
      expect(regExp.stringMatch(neverEatingThat), equals('fox'));
      expect(regExp.stringMatch('I like bagels and lox'), isNull);
    });
  });

  group('substituting strings based on regExp matches', () {
    test('using replaceAll()', () {
      expect('resume'.replaceAll(new RegExp(r'e'), '\u00E9'), equals('résumé'));
    });

    test('using replaceFirst()', () {
      expect('0.0001'.replaceFirst(new RegExp(r'0+'), ''), equals('.0001'));
    });

    test('using replaceAllMapped()', () {
      var heart = '\u2661';
      var string = "I like Ike but I $heart Lucy";
      var regExp = new RegExp(r'[A-Z]\w+');
      expect(string.replaceAllMapped(
        regExp, (match) => match.group(0).toUpperCase()),
        equals('I like IKE but I ♡ LUCY'));
    });

  });

  group('creating an extended character', () {
    test('using a rune', () {
      expect(clef, equals('𝄞'));
    });
  });

  group('accessing runes and code units', () {
    test('', () {
      expect(clef.codeUnits.map((codeUnit) => codeUnit.toRadixString(16)), equals(['d834', 'dd1e']));
      expect(clef.runes.map((rune) => rune.toRadixString(16)).toList(), equals(['1d11e']));
    });
  });

  group('accessing length', () {
    print(obj) => obj;
    test('', () {
      expect(print(clef.length), equals(2));
      expect(print(clef.codeUnits.length), equals(2));
      expect(print(clef.runes.length), equals(1));
    });
  });

  group('subscripting', () {
    print(obj) => obj;
    test('', () {
      expect(print(clef.runes.first.toRadixString(16)), equals('1d11e'));
      expect(print(clef.runes.toList()[0].toRadixString(16)), equals('1d11e'));
      // This test will never pass because clef[0] is an illegal string.
      // expect(print(clef[0]), equals('?'));
      expect(print(clef.codeUnits[0]), equals(55348));
      expect(clef.runes.toList()[0], equals(119070));
    });
  });
  group("using raw string", () {
    print(obj) => obj;
    test('escaping special characters', () {
      var subsetSymbol = '\u2282';
      expect('A ⊂ B can be written as ' + r'A \u2282 B', equals(
          'A ⊂ B can be written as A \\u2282 B'));

      expect(print(r'Wile \E Coyote'), equals(r'Wile \E Coyote'));

      var superGenius = 'Wile Coyote';
      expect(print(r'$superGenius and Road Runner'), equals(r'$superGenius and Road Runner'));
    });

    test('escaping interpolation', () {
      expect('A ⊂ B can be written as ' + r'A $subsetSymbol B', equals(
          'A ⊂ B can be written as A \$subsetSymbol B'));
    });

    group('in a regExp', () {
      var nums = '+10, 30, -4';
      var regExp = new RegExp('(\\+|-)?\\d+');
      var rawStringRegExp = new RegExp(r'(\+|-)?\d+');

      var matches = regExp.allMatches(nums);
      expect(print(matches.map((match) => match.group(0)).toList()),
          equals(['+10', '30', '-4']));

      matches = rawStringRegExp.allMatches(nums);
      expect(print(matches.map((match) => match.group(0)).toList()),
          equals(['+10', '30', '-4']));
    });
  });
}
