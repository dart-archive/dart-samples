library string_interpolation;

import 'dart:math' as math;

String simpleInterpolation() {
  // BEGIN(string_interpolation_simple_interpolation)
  String greeting = "hello";
  String person = "Kathy";
  String s = "I said ${greeting} to ${person}";
  // I said hello to Kathy
  // END(string_interpolation_simple_interpolation)
  return s;
}

String simpleInterpolationWithoutCurlies() {
  String greeting = "hello";
  String person = "Kathy";
  // BEGIN(string_interpolation_simple_interpolation_without_curlies)
  String s = "I said $greeting to $person";
  // END(string_interpolation_simple_interpolation_without_curlies)
  return s;
}

String callingToStringOnInt() {
    // BEGIN(string_interpolation_calling_toString_on_int)
    int x = 5;
    String s = "There are ${x.toString()} people in this room";
    // END(string_interpolation_calling_toString_on_int)
    return s;
}

// BEGIN(string_interpolation_class_book)
class Book {
  String title;
  Book(this.title);
}
// END(string_interpolation_class_book)

String withoutToString() {
  // BEGIN(string_interpolation_without_toString)
  Book book = new Book("War and Peace");
  String s = "The book is '${book}'";
  // The book is "Instance of 'Book'"
  // END(string_interpolation_without_toString)
  return s;
}

// BEGIN(string_interpolation_class_song)
class Song {
  String title;
  Song(this.title);
  String toString() {
    return this.title;
  }
}
// END(string_interpolation_class_song)

String withToString() {
  // BEGIN(string_interpolation_with_toString)
  Song song = new Song("You can call me Al");
  String s = "The song is '${song}'"; // The song is 'You can call me Al'
  // END(string_interpolation_with_toString)
  return s;
}

String useTernaryIfElse() {
    // BEGIN(string_interpolation_use_ternary_if_else)
    int x = 5;
    String s = "There are ${x < 10 ? "a few" : "many"} people in this room";
    // END(string_interpolation_use_ternary_if_else)
    return s;
}

List<String> listAndMapOperations() {
    // BEGIN(string_interpolation_list_and_map_operations)
    List list = [1, 2, 3, 4, 5];
    String s1 = "The list is $list, and when squared it is ${list.map((i) {return
    i * i;})}";
    // The list is [1, 2, 3, 4, 5], and when squared it is [1, 4, 9, 16, 25]
 
    Map map = {"ca": "California", "pa": "Pennsylvania"};
    String s2 = "I live in sunny ${map['ca']}";
    // I live in sunny California
    // END(string_interpolation_list_and_map_operations)

    return [s1, s2];
}

String interpolateSelfCallingFunction() {
    // BEGIN(string_interpolation_interpolate_self_calling_function)
    List names = ['John', 'Paul', 'George', 'Ringo'];
    String s = "${
      ((names) {
          return names[(new math.Random()).nextInt(names.length)];
      })(names)} was the most important member of the Beatles";
    // END(string_interpolation_interpolate_self_calling_function)
    return s;
}
