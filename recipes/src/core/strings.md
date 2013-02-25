## Concatenating Strings

### Problem

You want to know how to concatenate strings in Dart. You tried using `+`, but
that resulted in an error.

### Solution

Use adjacent string literals:

	'Dart'  is' ' fun!'; // 'Dart is fun!'
	
### Discussion

Adjacent literals also work over multiple lines:

	'Dart'
	'is'
	fun!; // 'Dart is fun!'

They also work when using multiline strings:

	'''Peanut
	butter'''
	'''and
	jelly'''; // 'Peanut\nbutter and\njelly'
	
And you can concatenate adjacent single line literals with multiline strings:

	'Peanut ' 'butter'
	''' and
	jelly'''; // 'Peanut butter and\n jelly'

#### Alternatives to adjacent string literals

Use `concat()`:

	'Dewey'.concat(' Cheatem').concat(' and').concat( ' Howe'); // 'Dewey Cheatem and Howe'

Invoking a long chain of `concat()`s can be expensive (`concat()` creates a
new string every time it is invoked): if you need to incrementally 
build up a long string, use a StringBuffer instead (see below).

Use `join()` to combine a sequence of strings:

	['Dewey', 'Cheatem', 'and', 'Howe'].join(' '); // 'Dewey Cheatem and Howe'

You can also use string interpolation (see below).

## Interpolating expressions inside strings

### Problem

You want to create strings that contain Dart expressions and identifiers.

### Solution

You can put the value of an expression inside a string by using ${expression}.

    var favFood = 'sushi';
    'I love ${favFood.toUpperCase()}'; // 'I love SUSHI'

You can skip the {} if the expression is an identifier:

    'I love $favFood'; // 'I love sushi'
      
### Discussion

An interpolated string ‘string ${expression}’ is equivalent to the
concatenation of the strings ‘string' and expression.toString():

	var four = 4;
    'The $four seasons'; // 'The 4 seasons'
	
The code above is equivalent to the following:

	'The '.concat(4.toString()).concat(' seasons'); // 'The 4 seasons'
	
You should consider implementing a `toString()` method for user-defined
objects. Here's what happens if you don't:

	class Point {
	  num x, y;
	  Point(this.x, this.y);
	}
	
	var point = new Point(3, 4);
    'Point: $point'; // "Point: Instance of 'Point'"

Probably not what you wanted. Here is the same example with an explicit
`toString()`:

	class Point {
      ...
	  String toString() => "x: $x, y: $y";
	}
	
    'Point: $point'; // 'Point: x: 3, y: 4'

Interpolations are not evaluated within raw strings:

	r'$favFood'; // '$favFood'
	
	
## Incrementally building a string efficiently

### Problem

You want to combine string fragments in an efficient way. 

### Solution

Use a StringBuffer to programmatically generate a string. A StringBuffer 
collects the string fragments, but does not generate a new string until
`toString()` is called:

	var sb = new StringBuffer();
    sb.write("John, ");
    sb.write("Paul, ");
    sb.write("George, ");
    sb.write("and Ringo");
    sb.toString(); // "John, Paul, George, and Ringo"
    
### Discussion

In addition to `write()`, the StringBuffer class provides methods to write a
list of strings (`writeAll()`), write a numerical character code
(`writeCharCode()`), write with an added newline ('writeln()`), and more. Here
is a simple example:

    var sb = new StringBuffer();
    sb.writeln("The Beatles:");
    sb.writeAll(['John, ', 'Paul, ', 'George, and Ringo']);
    sb.writeCharCode(33); // charCode for '!'.
    sb.toString(); // 'The Beatles:\nJohn, Paul, George, and Ringo!' 

A StringBuffer represents a more efficient way of combining strings than
`concat()`.  See the "Concatenating Strings" recipe for a description of `concat()`. 








## Converting between string characters and numbers

### Problem 

You want to convert string characters into code units and back.

### Solution

Use `string.codeUnits()` to access the sequence of Unicode UTF-16 code units
that make up a string:
    
    'Dart'.codeUnits.toList(); // [68, 97, 114, 116]
    
     var smileyFace = '\u263A';
     smileyFace.codeUnits.toList(); // [9786]
     
The number 9786 represents the code unit '\u263A'.
     
Use the `runes` getter to access a string's code points:
 
	'Dart'.runes.toList(); // [68, 97, 114, 116]

     smileyFace.runes.toList(); // [9786]
 
### Discussion

Notice that using `runes` and `codeUnits()` produces identical results
in the examples above. That is because each character in both 'Dart' and
`smileyFace` fits within 16 bits, resulting in a code unit corresponding
neatly with a code point.

Consider an example where a character cannot be represented within 16-bits,
the Unicode character for a Treble clef ('\u{1F3BC}'). This character consists
of a surrogate pair: '\uD83C', '\uDFBC'. Getting the numerical value of this
character using `codeUnits()` produces the following result:

    var clef = '\u{1F3BC}';
	clef.codeUnits.toList(); // [55356, 57276]

The numbers 55356 and 57276 represent the surrogate pair, '\uD83C' and 
'\uDFBC', respectively.

Using `runes` produces this result:

    clef.runes.toList(); // [127932]
    
The number 127932 represents the code point '\u1F3BC'.

#### Using codeUnitAt() to access individual characters

To access the 16-Bit UTF-16 code unit at a particular index, use
`codeUnitAt()`:

    smileyFace.codeUnitAt(0); // 9786
    
    clef.codeUnitAt(0); // 55356
	clef.codeUnitAt(1); // 57276

Notice that in either call to `clef.codeUnitat()`, the values returned
represent strings that are only one half of a UTF-16 surrogate pair.
These are not valid UTF-16 strings.

#### Converting numerical values to strings

You can generate a new string from code units using the factory 
`String.fromCharCodes(charCodes)`:

	new String.fromCharCodes([68, 97, 114, 116]); // 'Dart'
	
    var heart = '\u2661';
	new String.fromCharCodes([73, 32, 9825, 32, 76, 117, 99, 121]);
	// 'I $heart Lucy'

The charCodes can be UTF-16 code units or runes.

The Unicode character for a Treble clef is '\u{1F3BC}', with a rune value of 
127932. Passing either code units, or a code point to `String.fromCharCodes()`
produces the `clef` string:

	new String.fromCharCodes([55356, 57276]); // clef
	new String.fromCharCodes([127932]), // clef
	
You can use the `String.fromCharCode()` factory to convert a single code unit
to a string:

	new String.fromCharCode(127932), // clef

Creating a string with only one half of a surrogate pair is permitted, but not
recommended.

## Determining if a string is empty

### Problem

You want to know if a string is empty. You tried ` if(string) {...}`, but that
did not work.

### Solution

Use string.isEmpty:

    var emptyString = '';
  	emptyString.isEmpty; // true
  	
A string with a space is not empty:
 
    var space = " ";
    space.isEmpty; // false
   
### Discussion 

Don't use `if (string)` to test the emptiness of a string. In Dart, all
objects except the boolean true evaluate to false. `if(string)` will always
be false.

Don't try to explicitly test for the emptiness of a string:

    if (emptyString == anotherString) {...}
    
This may work sometimes, but if `string` has an empty value that is
not a literal `''`, the comparisons will fail:
    
    emptyString == '\u0020`; // false
    emptyString == '\u2004'; // false
    
## Removing leading and trailing whitesapce

### Problem

You want to remove leading and trailing whitespace from a string.

### Solution

Use `string.trim()`:

    var space = '\n\r\f\t\v';
    var string = '$space X $space';
    string.trim(); // 'X'

The String class has no methods to remove leading and trailing whitespace. But
you can always use regExps.

Remove only leading whitespace:

    string.replaceFirst(new RegExp(r'^\s+'), ''); //  'X $space'
   
Remove only trailing whitespace:

    string.replaceFirst(new RegExp(r'\s+$'), ''); // '$space X'
    

      "\t\nx\t\t".replaceFirst(new RegExp(r'^\s+'), ''); // 'x\t\t'
      
 And to remove only trailing whitespacklp[;e, use this regExp:
 }
 
 
	
    

    



### Discussion
 