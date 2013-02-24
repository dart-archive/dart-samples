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
new string every time it is invoked:): if you need to incrementally 
build up a long string, use a StringBuffer instead (see below).

Use `join()` to combine a sequence of strings:

	['Dewey', 'Cheatem', 'and', 'Howe'].join(' '); // 'Dewey Cheatem and Howe'

You can also use string interpolation (see below).
