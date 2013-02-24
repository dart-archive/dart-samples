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

An interpolated string Ôstring ${expression}Õ is equivalent to the
concatenation of the strings Ôstring' and expression.toString():

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
	
