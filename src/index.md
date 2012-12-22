# Dart Cookbook

# Contents

- [Strings](#strings)
    - [Concatenating strings](#concatenating_strings)
    - [Interpolating expressions inside strings](#interpolating_expressions_inside_strings)
    - [Converting between character codes and strings](#converting_between_character_codes_and_strings)

# Strings

### <a id="concatenating_strings"></a>Concatenating strings

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

### <a id="interpolating_expressions_inside_strings"></a>Interpolating expressions inside strings

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


### <a id="converting_between_character_codes_and_strings"></a>Converting between character codes and strings

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
