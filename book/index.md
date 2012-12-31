# Dart Cookbook

# Contents

- [Strings](#strings)
    - [Concatenating strings](#concatenating-strings)
    - [Interpolating expressions inside strings](#interpolating-expressions-inside-strings)
    - [Converting between character codes and strings](#converting-between-character-codes-and-strings)
- [web_ui](#web_ui)
    - [Creating a one way data binding](#creating-a-one-way-data-binding)
    - [Creating a one way data binding with a
      watcher](#creating-a-one-way-data-binding-with-a-watcher)
    - [Creating a two way data binding](#creating-a-two-way-data-binding)
    - [Using template conditionals](#using-template-conditionals)


- [Testing](#testing)
    - [Running only a single test](#running-only-a-single-test)
    - [Filtering which tests are run](#filtering-which-tests-are-run)
    - [Testing Errors and Exceptions](#testing-errors-and-exceptions)

<!-- --------------------------------------------------------------------- -->
# Strings

### <a id="concatenating-strings"></a>Concatenating strings

#### Problem
String concatenation using a `+` works in a lot of languages, but not in Dart.
Since the `+` operator has not been defined for stings, the following code
throws a `NoSuchMethodError`:

	String s = "hello, " + "world!";
     
So, how _do_ you concatenate strings in Dart?

#### Solution
The easiest, most efficient way is by using adjacent string literals:

	String s =  "hello, " "world!";

This still works if the adjacent strings are on different lines:

	String s = "hello, "
	    "world!";

Dart also has a `StringBuffer` class; this can be used to build up a
`StringBuffer` object and convert it to a string by calling `toString()`
on it:

	var sb = new StringBuffer(); 
	["hello, ", "world!"].forEach((item) {
	  sb.add(item);
	  });
	String s = sb.toString();
    
The `Strings` class (notice the plural) gives us 2 methods, `join()` and
`concatAll()` that can also be used. `Strings.join()` takes a delimiter as a
second argument.

	String s = Strings.join(["hello", "world!"], ", "); 
	String s = Strings.concatAll(["hello, ", "world!"]); 

All of the above work, but if you are looking for a `+` substitute, use
adjacent string literals; if you need to join a list of strings using a
delimiter, use `Strings.join()`. If you plan on building a very long string,
use `StringBuffer` to gather the components and convert them to a string
only when needed. 

You can also use string interpolation; that is the subject of different
recipe.

### <a id="interpolating-expressions-inside-strings"></a>Interpolating expressions inside strings

#### Problem
You want to use identifiers and Dart expressions in Strings.

#### Solution

You can access the value of an expression inside a string by using `${expression}`.

	String greeting = "hello";
	String person = "Kathy";
	String s = "I said ${greeting} to ${person}";
	// I said hello to Kathy
  
If the expression is an identifier, the `{}` can be skipped.

	String s = "I said $greeting to $person";
  
If the variable inside the `{}` isn't a string, the variable's
`toString()` method is called:

	int x = 5;
	String s = "There are ${x.toString()} people in this room";

The call to `toString()` is unnecessary (although harmless) in this case:
`toString()` is already defined for ints and Dart automatically calls
`toString()`. What this does mean, though, is that it is the user's
responsibility to define a `toString()` method when interpolating
user-defined objects.

This will not work as expected:

	class Book {
	  String title;
	  Book(this.title);
	}
	Book book = new Book("War and Peace");
	String s = "The book is '${book}'";
	// The book is "Instance of 'Book'"

But this will:

	class Song {
	  String title;
	  Song(this.title);
	  String toString() {
	    return this.title;
	  }
	}
	Song song = new Song("You can call me Al");
	String s = "The song is '${song}'"; // The song is 'You can call me Al'

You can interpolate expressions of arbitrary complexity by placing them inside
`${}`:

A ternary `if..else`:

	int x = 5;
	String s = "There are ${x < 10 ? "a few" : "many"} people in this room";
  
List and Map operations:

	List list = [1, 2, 3, 4, 5];
	String s1 = "The list is $list, and when squared it is ${list.map((i) {return
	i * i;})}";
	// The list is [1, 2, 3, 4, 5], and when squared it is [1, 4, 9, 16, 25]
	
	Map map = {"ca": "California", "pa": "Pennsylvania"};
	String s2 = "I live in sunny ${map['ca']}";
	// I live in sunny California

Notice above that you can access `$list`(an identifier) without using `{}`,
but the call to `list.map`(an expression) needs to be inside `{}`. 

Expressions inside `${}` can be arbitrarily complex:

	List names = ['John', 'Paul', 'George', 'Ringo'];
	String s = "${
	  ((names) {
	      return names[(new math.Random()).nextInt(names.length)];
	  })(names)} was the most important member of the Beatles";

The code above defines an anonymous function to pick a random name from a
list and then calls that function with `names` as an argument. All of
this is done as part of string interpolation.

Creating a function and immediately calling it is useful in a lot of
situations (it is a common practice in Javascript); but, watch out: 
doing this sort of thing can lead to hard to maintain code. An abudance
of caution is advised ;) 


### <a id="converting-between-character-codes-and-strings"></a>Converting between character codes and strings

#### Problem
You want to get the ascii character codes for a string, or to get the
string corresponding to ascii codes.

#### Solution

To get a list of character codes for a string, use `charCodes`:

	String s = "hello";
	List<int> charCodes = s.charCodes;
	// [104, 101, 108, 108, 111]
  
To get a specific character code, you can either subscript `charCodes`, or 
use `charCodeAt`:

	int charCode = s.charCodeAt(0); // 104
  
To assemble a string from a list of character codes, use the `String` factory,
`fromCharCodes`:

	List<int> charCodes = [104, 101, 108, 108, 111];
	String s = new String.fromCharCodes(charCodes);
  
If you are using a StringBuffer to build up a string, you can add individual
charCodes using `addCharCode` (use `add()` to add characters; use `addCharCode()`
to add charCodes):

	StringBuffer sb = new StringBuffer();
	List<int> charCodes = [104, 101, 108, 108, 111];
	charCodes.forEach((charCode) {
	  sb.addCharCode(charCode);
	});
	String s = sb.toString(); // "Hello" 

Here is an implementation of the `rot13` algorithm, using the tools described above.
`rot13` is a simple letter substitution algorithm that rotates a string by 13
places by replacing each character in it by one that is 13 characters removed
('a' becomes 'n', 'N' becomes 'A', etc.):

	String rot13(String s) {
	  List<int> rotated = [];
	
	  s.charCodes.forEach((charCode) {
	    final int numLetters = 26;
	    final int A = 65;
	    final int a = 97;
	    final int Z = A + numLetters;
	    final int z = a + numLetters;
	
	    if (charCode < A ||
	        charCode > z ||
	        charCode > Z && charCode < a) {
	      rotated.add(charCode);
	    }
	    else {
	      if ([A, a].some((item){
	        return item <= charCode && charCode < item + 13;
	      })) {
	        rotated.add(charCode + 13);
	      } else {
	        rotated.add(charCode - 13);
	      }   
	    }
	  });
	
	  return (new String.fromCharCodes(rotated));
	}

Running the code:
 
	var wordList = ["Jung", "be", "purely", "barf"];
	List rotated = wordList.map((word) {
	    return rot13(word);
	  });
	// ["What", "or", "cheryl", "ones"]

and:

	String str1 = "aMz####AmZ";
	String str2 = rot13(rot13(str1));
	// str1 == str2

<!-- --------------------------------------------------------------------- -->
# web_ui

### TODO (shailen): Explain the file structure of the web_ui apps
### TODO (shailen): Explain how the examples can be run.

### <a id="creating-a-one-way-data-binding"></a>Creating a one way data binding
**pubspec dependencies**: _web_ui_

### Problem: You want to set up automatic monitoring of data, and ensure that
the UI is updated when the data’s value changes.

### Solution

You can inject data in your template using {{expression}}. The example below
displays the random values generated from rolling a pair of dice. Every time
the page is refreshed, the values - stored as {{ die1 }} and {{ die2 }} - are
injected into the page automatically:

	<html lang="en">
	<head>
	  <meta charset="utf-8">
	  <link href="main.css" rel="stylesheet" type="text/css">
	</head>
	<body>
	  <h1>Rolled the dice!</h1>
	  <table>
	    <tr><td>Die 1</td><td>Die 2</td></tr>
	    <tr><td>{{ die1 }}</td><td>{{ die2 }}</td></tr>
	  </table>
	  <script type="application/dart" src='main.dart'></script>
	</body>
	</html>

The code in `main.dart` is tasked with generating the random values:

	import 'dart:math';
	
	String die1;
	String die2;
	Random random = new Random();
	
	void rollDice() {
	  die1 = _rollDie();
	  die2 = _rollDie();
	}
	
	String _rollDie() {
	  return (random.nextInt(6) + 1).toString();
	}
	
	main() {
	  rollDice();
	}
	
We add a little bit of css (main.css) to make our display nicer:

	td {
	  border: 1px solid black; 
	  margin: 2px; 
	  padding: 3px 6px;
	} 
	
### <a id="creating-a-one-way-data-binding-with-a-watcher"></a>Creating a one
way data binding with a watcher
**pubspec dependencies**: _web_ui_

### Problem: You want to create a one way data binding, but you want to monitor
the bound values and keep refreshing them in the UI.

### Solution: Web UI implements this monitoring by using the `watcher.dart`
library. `watcher.dart` is automatically run for you, but you can also directly
invoke it. The previous recipe can be rewritten so that the random die values
get refreshed every 2 seconds. The `rollDice()` function is unchanged; `main()`
is altered to invoke it every 2 seconds by dispatching a watcher.  

	import 'package:web_ui/watcher.dart' as watcher; // import the watcher
	import 'dart:math';
	import 'dart:html';
	
	String die1;
	String die2;
	Random random = new Random();
	
	void rollDice() {
	  die1 = _rollDie();
	  die2 = _rollDie();
	}
	
	String _rollDie() {
	  return (random.nextInt(6) + 1).toString();
	}
	
	main() {
	  rollDice();
	  window.setInterval(() {
	    rollDice();
	    watcher.dispatch(); // dispatch the watcher repeatedly
	  }, 2000);
	}
	
Note that we have to import the watcher explicitly and call `dispatch()` on it
to make the magic happen. 

### <a id="creating-a-two-way-data-binding"></a>Creating a two
way data binding
**pubspec dependencies**: _web_ui_

### Problem: You want a DOM element's value to be kept in sync with the value of
a Dart variable without having to do DOM manipulation yourself.

### Solution: Web UI supports two-way data binding to keep one or more DOM
elements in sync with a Dart variable. In this recipe, we allow a user to input
some text (a tweet) and create a binding between the text input box and the
Dart variable `tweet`. We use that binding to print a "shouted" version of the
user's content and inform the user about how many characters she is still
permitted to type. The two-way binding between the input's value value and the
variable `tweet` allows all this to work effortlessly with no need for explicity
DOM manipulation.

The main html file contains the markup. Note the `bind-value="tweet"` declaration
in the text input:

	<html lang="en">
	<head>
	  <meta charset="utf-8">
	</head>
	<body>
	  <h1>Tweet something and we'll shout it out for you!</h1>
	  <div>
	    Tweet:
	    <input type="text" size="140" bind-value="tweet" placeholder="tweet something here">
	    <div> Shouted version: <span class="shouted">{{tweet.toUpperCase()}}</span></div>
	    <div> You have {{140 - tweet.length}} characters remaining</div>
	  </div>
	
	  <script type="application/dart" src='main.dart'></script>
	</body>
	</html>

The shouted verion accesses the `tweet` variable within `{{ }}` and upcases it;
a `div` accesses `tweet.length` within its `{{ }}` to figure how the number of
characters remaining.

The `main.dart` file is pretty Spartan in this recipe. We define a
`tweet` variable and implement an empty `main()`:

	String tweet = '';
	
	main() {} // main() is required, even if the body is empty

### <a id="using-template-conditionals"></a>Using template conditionals
**pubspec dependencies**: _web_ui_

### Problem: You want to display templates conditionally.

### Solution: Web UI allows for `if` constructs and for the conditional
instantiation of templates.  In this recipe, we display a short list of `Book`
objects stored in a `books` variable. 

We use conditionals in two places: 1) We instantiate different templates
based on whether our book list is empty or not. We bind this behavior to the
value of a `noBooks` getter that we define in `main.dart`. If this returns
true, we instantiate a template that shows a "No Books to Display" header on
the page; if it returns false, we instantiate the template that displays the book
data. Here is the (truncated) excerpt from `main.html`:

	    <template instantiate='if noBooks'><h2>No Books to Display</h2></template>
	    <template instantiate='if !noBooks'>

and the code for the getter:

	List<Book> books = [];
	bool get noBooks => books.isEmpty;
	List<Book> books = [];
	bool get noBooks => books.isEmpty;

2) We allow the user to choose how much detail she wants to see about each book
by checking or unchecking the 'show details' checkbox provided. The `checked`
state of the checkbox is bound to a `showBookDetails` boolean:

	<div><input type="checkbox" bind-checked="showBookDetails">show details</div> 

In `main.dart`, the value of `showBookDetails` is `true` by default and 
changes to `false` if the bound checkbox is unchecked:

	bool showBookDetails = true;
	bool showBookDetails = true;

Finally, we provide a "delete all books" link. If this is clicked, our book list
is cleared and the "No Books to Display" template is automatically rendered.
This is a good example of a Web UI event listener. If the link is clicked, the
`emptyBookList()` function is called, the content of `books` are cleared and our
first conditional(`noBooks`) is _automatically_ re-evaluated.

	emptyBookList() {
	  books = []; 
	  return false;
	}
	emptyBookList() {
	  books = []; 
	  return false;
	}

Here is the `main.html` file:

	<html lang="en">
	<head>
	  <meta charset="utf-8">
	</head>
	<body>
	  <div>
	    <template instantiate='if noBooks'><h2>No Books to Display</h2></template>
	    <template instantiate='if !noBooks'>
	      <h2>Books:</h2>
	      <ul>
	        <template iterate='book in books'>
	          <li>{{book.title}}
	          <ul template instantiate="if showBookDetails">
	            <li>${{book.price}}</li>
	            <li>{{book.numPages}} pages</li>
	            <li>{{book.available ? "Available" : "Out of Stock"}}</li>
	          </ul>
	          </li>
	        </template>
	      </ul> 
	      <div><input type="checkbox" bind-checked="showBookDetails">show details</div> 
	      <hr>
	      <div id="emptyBookList"><a href="#" on-click="emptyBookList()">delete all books</a></div>
	    </template>
	  </div>
	
	  <script type="application/dart" src='main.dart'></script>
	</body>
	</html>
	
and the `main.dart` file:

	import "dart:html";
	
	class Book {
	  String title;
	  num price;
	  num numPages;
	  bool available;
	
	  Book(this.title, this.price, this.numPages, [this.available=true]);
	}
	
	List<Book> books = [];
	bool get noBooks => books.isEmpty;
	bool showBookDetails = true;
	
	emptyBookList() {
	  books = []; 
	  return false;
	}
	
	main() {
	  books = [
	    new Book("War and Peace", 20.99, 1013),
	    new Book("Anna Karenina", 23.99, 1243, false),
	    new Book("The Old Man and the Sea", 8.99, 78)
	  ]; 
	}
	

<!-- --------------------------------------------------------------------- -->
# Testing

### <a id="running-only-a-single-test"></a>Running only a single test

**pubspec dependencies**: _unittest, args_

#### Problem
You are coding away furiously and diligently writing tests for everything. But,
running all your tests takes time and you want to run just a single test,
perhaps the one for the code you are working on.

#### Solution
The easiest way to do this is to convert a `test()`s to a `solo_test()`:

	import "package:unittest/unittest.dart";
	
	void main() {
	  test("test that's already running fine", () {
	    expect('foo', equals('foo'));
	  }); // this test will not run
	
	  solo_test("test I am working on now", () {
	    expect('bar', equals('bar'));
	  });
	}

Run the tests now and you'll see that only the `solo_test()` runs; the `test()`
does not.

	unittest-suite-wait-for-done
	PASS: test I am working on now
	
	All 1 tests passed.
	unittest-suite-success

You can also run a single test by passing the `id` of that test
to `setSoloTest()` (see `unittest/src/unittest.dart`), perhaps as a command-line
arg.

Since the default `unittest` ouput does not include the test `id`, you
need to extend the default Configuration class (see unittest/src/config.dart):

	import 'package:unittest/unittest.dart';
	import 'package:args/args.dart';
	
	class SingleTestConfiguration extends Configuration {
	  get autoStart => false;
	  void onDone(int passed, int failed, int errors, List<TestCase> testCases,
	              String uncaughtError) {
	    testCases.forEach((testCase){
	      // get the id of the testCase in there
	      print("${testCase.id}\t${testCase.result.toUpperCase()}: ${testCase.description}");
	      });
	   // skip the summary that is normally provided here...
	  }
	}

Our custom configuration is pretty minimal: we modify the default
`Configuration`'s `onDone()` to include the test `id` on every line (`onDone()`
also outputs a summary of the entire test run; we skip that here).

Now we need code to use our new configuration and to initialize the test
framework (we put code for that in `useSingleTestConfiguration()` and call that function
from `main()`):

	void useSingleTestConfiguration() {
	  configure(new SingleTestConfiguration());
	  ensureInitialized();  
	}

We use `ArgParser` to parse the command line arguments: if an id is provided
through the command line, only the test with that id runs:

	$ dart myFile.dart 2
	unittest-suite-wait-for-done
	2 FAIL: failing test

if no id is provided, all the tests run:
  
	$ dart myFile.dart
	unittest-suite-wait-for-done
	1 PASS: passing test
	2 FAIL: failing test
	3 PASS: another passing test

Here is the complete example:

	import 'package:unittest/unittest.dart';
	import 'package:args/args.dart';
	
	class SingleTestConfiguration extends Configuration {
	  get autoStart => false;
	  void onDone(int passed, int failed, int errors, List<TestCase> testCases,
	              String uncaughtError) {
	    testCases.forEach((testCase){
	      // get the id of the testCase in there
	      print("${testCase.id}\t${testCase.result.toUpperCase()}: ${testCase.description}");
	      });
	   // skip the summary that is normally provided here...
	  }
	}
	
	void useSingleTestConfiguration() {
	  configure(new SingleTestConfiguration());
	  ensureInitialized();  
	}
	
	void main() {
	  useSingleTestConfiguration();
	
	  // get the args from the command line
	  ArgParser argParser = new ArgParser();
	  Options options = new Options();
	  ArgResults results = argParser.parse(options.arguments);
	  List<String> args = results.rest;
	
	  // note that the second test is failing
	  test("passing test", () => expect(1, equals(1)));
	  test("failing test", () => expect(false, isTrue));
	  test("another passing test", () => expect(3, equals(3)));
	
	  if (!args.isEmpty) {
	    setSoloTest(int.parse(args[0]));
	  }
	
	  // run the tests (we turned off auto-running of tests, remember?
	  runTests();
	}

### <a id="filtering-which-tests-are-run"></a>Filtering which tests are run
**pubspec dependencies**: _unittest, args_

#### Problem
You want to run just a subset of your tests, perhaps those  whose description
contains a word or a phrase, or that are collected together in a `group()`.

#### Solution

Use `filterTests()` with with a String or a RegExp argument; if a test's
description matches the argument, the test runs, otherwise, it doesn't. 

Before you use `filterTests()`, you need to disable the automatic running of
tests (create and use a simple custom configuration that sets `autoStart` to false)
and call `filterTests()` _after_ your `test()` and `group()` definitions. Here
is a simple recipe that takes the string argument to `filterTests()` from the
command line. 

	import 'package:unittest/unittest.dart';
	import 'package:args/args.dart';
	
	class FilterTests extends Configuration {
	  get autoStart => false;
	}
	
	void useFilterTests() {
	  configure(new FilterTests());
	  ensureInitialized();
	}
	
	void main() {
	  useFilterTests();
	
	  // get the args from the command line
	  ArgParser argParser = new ArgParser();
	  Options options = new Options();
	  ArgResults results = argParser.parse(options.arguments);
	  List<String> args = results.rest;
	
	  test("one banana", () => expect(1, equals(1)));
	  test("two banana", () => expect(2, equals(2)));
	  test("three banana",()  => expect(3, equals(3)));
	  test("four", () => expect(4, equals(4)));
	
	  group("Betty Botter bought a bit of", () {
	    test("butter", () => expect("butter".length, equals(6)));
	    test("better butter", () => expect("better butter".length, equals(13)));
	  });
	
	  if (!args.isEmpty) {
	    filterTests(args[0]);
	  }
	  runTests();
	}
	

syntax. If the keyword is `four`, only one test run.

	unittest-suite-wait-for-done
	PASS: four
	
	All 1 tests passed.
	unittest-suite-success

If it is `Betty`, all tests in `group()` run (same if it is `butter`).

	unittest-suite-wait-for-done
	PASS: Betty Botter bought a bit of butter
	PASS: Betty Botter bought a bit of better butter
	
	All 2 tests passed.
	unittest-suite-success

If it is `banana`, 3 tests run.  Without a keyword, all tests run.


### <a id="testing-errors-and-exceptions"></a>Testing Errors and Exceptions
**pubspec dependencies**: _unittest_

#### Problem

You want to test all your code, including code that deals with errors or
exceptions. Consider this function that you are writing:

	List range(start, stop) {
	    if (start >= stop) {
	      throw new ArgumentError("start must be less than stop");
	    }
	    // remainder of function
	}

How do you test the `ArgumentError`, and test the error message?

#### Solution

To simply test that some code throws, you can do the following:

	test("an exception or error occured", () {
	  expect(() => range(5, 5), throws);
	});

Conversly, to test that *no* exception is thrown, use `returnsNormally`:

	expect(() => range(5, 10), returnsNormally);

To test the type of an exception, use `throwsA`:

	expect(() => range(5, 2), throwsA(new isInstanceOf<ArgumentError>()));

To test the exception type *and* the exception message, you can do this:

	expect(() => range(5, 3), 
	    throwsA(predicate((e) => e is ArgumentError && e.message == 'start must be less than stop')));

Here is another way to do the same:

	expect(() => range(5, 3), 
	    throwsA(allOf(isArgumentError, predicate((e) => e.message == 'start must be less than stop'))));

Finally, the `unittest` framework has built-in matchers to handle common
exceptions and errors. To test the `ArguementError` in `range()`, you can simply
use the `throwsArgumentError` matcher:

	expect(() => range(2, 2), throwsArgumentError);

Other common matchers provided are:

	throwsException
	throwsFormatException
	throwsArgumentError
	throwsIllegalJSRegExpException
	throwsRangeError
	throwsNoSuchMethodError
	throwsUnimplementedError
	throwsUnsupportedError

See `unittest/src/core_matchers.dart` for more details.



