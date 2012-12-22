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

### <a id="interpolating_expressions_inside_strings"></a>Interpolating expressions inside strings

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


### <a id="converting_between_character_codes_and_strings"></a>Converting between character codes and strings

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

