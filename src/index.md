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

MERGE(concatenating_strings_usePlusOperator)
     
So, how _do_ you concatenate strings in Dart?

#### Solution
The easiest, most efficient way is by using adjacent string literals:

MERGE(concatenating_strings_useAdjacentStringLiterals)

This still works if the adjacent strings are on different lines:

MERGE(concatenating_strings_useAdjacentStringLiteralsOnDifferentLines)

Dart also has a `StringBuffer` class; this can be used to build up a
`StringBuffer` object and convert it to a string by calling `toString()`
on it:

MERGE(concatenating_strings_useStringBuffer)
    
The `Strings` class (notice the plural) gives us 2 methods, `join()` and
`concatAll()` that can also be used. `Strings.join()` takes a delimiter as a
second argument.

MERGE(concatenating_strings_useJoin)
MERGE(concatenating_strings_useConcatAll)

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

MERGE(string_interpolation_simple_interpolation)
  
If the expression is an identifier, the `{}` can be skipped.

MERGE(string_interpolation_simple_interpolation_without_curlies)
  
If the variable inside the `{}` isn't a string, the variable's
`toString()` method is called:

MERGE(string_interpolation_calling_toString_on_int)

The call to `toString()` is unnecessary (although harmless) in this case:
`toString()` is already defined for ints and Dart automatically calls
`toString()`. What this does mean, though, is that it is the user's
responsibility to define a `toString()` method when interpolating
user-defined objects.

This will not work as expected:

MERGE(string_interpolation_class_book)
MERGE(string_interpolation_without_toString)

But this will:

MERGE(string_interpolation_class_song)  
MERGE(string_interpolation_with_toString)

You can interpolate expressions of arbitrary complexity by placing them inside
`${}`:

A ternary `if..else`:

MERGE(string_interpolation_use_ternary_if_else)
  
List and Map operations:

MERGE(string_interpolation_list_and_map_operations)

Notice above that you can access `$list`(an identifier) without using `{}`,
but the call to `list.map`(an expression) needs to be inside `{}`. 

Expressions inside `${}` can be arbitrarily complex:

MERGE(string_interpolation_interpolate_self_calling_function)

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

MERGE(character_codes_use_charCodes)
  
To get a specific character code, you can either subscript `charCodes`, or 
use `charCodeAt`:

MERGE(character_codes_use_charCodeAt)
  
To assemble a string from a list of character codes, use the `String` factory,
`fromCharCodes`:

MERGE(character_codes_use_fromCharCodes)
  
If you are using a StringBuffer to build up a string, you can add individual
charCodes using `addCharCode` (use `add()` to add characters; use `addCharCode()`
to add charCodes):

MERGE(character_codes_use_StringBuffer)

Here is an implementation of the `rot13` algorithm, using the tools described above.
`rot13` is a simple letter substitution algorithm that rotates a string by 13
places by replacing each character in it by one that is 13 characters removed
('a' becomes 'n', 'N' becomes 'A', etc.):

MERGE(character_codes_rot13)

Running the code:
 
MERGE(character_codes_use_rot13)

and:

MERGE(character_codes_use_rot13_with_non_alpha)

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

MERGE(one_way_data_binding_html)

The code in `main.dart` is tasked with generating the random values:

MERGE(one_way_data_binding_dart)

We add a little bit of css to make our display nicer:

MERGE(one_way_data_binding_css)

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

MERGE(one_way_data_binding_with_watcher_dart) 

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

MERGE(two_way_data_binding_html)

The shouted verion accesses the `tweet` variable within `{{ }}` and upcases it;
a `div` accesses `tweet.length` within its `{{ }}` to figure how the number of
characters remaining.

The `main.dart` file is pretty Spartan in this recipe. We define a
`tweet` variable and implement an empty `main()`:

MERGE(two_way_data_binding_dart)

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

MERGE(conditionals_and_loops_noBooks_html) 

and the code for the getter:

MERGE(conditionals_and_loops_noBooks_dart)

2) We allow the user to choose how much detail she wants to see about each book
by checking or unchecking the 'show details' checkbox provided. The `checked`
state of the checkbox is bound to a `showBookDetails` boolean:

MERGE(conditionals_and_loops_showBookDetails_html))

In `main.dart`, the value of `showBookDetails` is `true` by default and 
changes to `false` if the bound checkbox is unchecked:

MERGE(conditionals_and_loops_showBookDetails_dart))

Finally, we provide a "delete all books" link. If this is clicked, our book list
is cleared and the "No Books to Display" template is automatically rendered.
This is a good example of a Web UI event listener. If the link is clicked, the
`emptyBookList()` function is called, the content of `books` are cleared and our
first conditional(`noBooks`) is _automatically_ re-evaluated.

MERGE(conditionals_and_loops_emptyBookList)

Here is the `main.html` file:

BEGIN(conditionals_and_loops_html)

and the `main.dart` file:

BEGIN(conditionals_and_loops_dart)


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

MERGE(solo_test_code)

Run the tests now and you'll see that only the `solo_test()` runs; the `test()`
does not.

MERGE(solo_test_output)

You can also run a single test by passing the `id` of that test
to `setSoloTest()` (see `unittest/src/unittest.dart`), perhaps as a command-line
arg.

Since the default `unittest` ouput does not include the test `id`, you
need to extend the default Configuration class (see unittest/src/config.dart):

MERGE(setsolotest_extend_configuration)

Our custom configuration is pretty minimal: we modify the default
`Configuration`'s `onDone()` to include the test `id` on every line (`onDone()`
also outputs a summary of the entire test run; we skip that here).

Now we need code to use our new configuration and to initialize the test
framework (we put code for that in `useSingleTestConfiguration()` and call that function
from `main()`):

MERGE(setsolotest_use_configuration)

We use `ArgParser` to parse the command line arguments: if an id is provided
through the command line, only the test with that id runs:

MERGE(setsolotest_output_with_arg)

if no id is provided, all the tests run:
  
MERGE(setsolotest_output_without_arg)

Here is the complete example:

MERGE(setsolotest_complete_example)

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

MERGE(filtertests_code)

syntax. If the keyword is `four`, only one test run.

MERGE(filtertests_keyword_equals_four)

If it is `Betty`, all tests in `group()` run (same if it is `butter`).

MERGE(filtertests_keyword_equals_Betty)

If it is `banana`, 3 tests run.  Without a keyword, all tests run.


### <a id="testing-errors-and-exceptions"></a>Testing Errors and Exceptions
**pubspec dependencies**: _unittest_

#### Problem

You want to test all your code, including code that deals with errors or
exceptions. Consider this function that you are writing:

MERGE(testing_errors_and_exceptions_range)

How do you test the `ArgumentError`, and test the error message?

#### Solution

To simply test that some code throws, you can do the following:

MERGE(testing_errors_and_exceptions_throws)

Conversly, to test that *no* exception is thrown, use `returnsNormally`:

MERGE(testing_errors_and_exceptions_returnsNormally)

To test the type of an exception, use `throwsA`:

MERGE(testing_errors_and_exceptions_throwsA)

To test the exception type *and* the exception message, you can do this:

MERGE(testing_errors_and_exceptions_type_and_message_1)

Here is another way to do the same:

MERGE(testing_errors_and_exceptions_type_and_message_2)

Finally, the `unittest` framework has built-in matchers to handle common
exceptions and errors. To test the `ArguementError` in `range()`, you can simply
use the `throwsArgumentError` matcher:

MERGE(testing_errors_and_exceptions_throwsArgumentError)

Other common matchers provided are:

MERGE(testing_errors_and_exceptions_matchers)

See `unittest/src/core_matchers.dart` for more details.


