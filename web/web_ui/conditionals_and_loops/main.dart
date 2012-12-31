// BEGIN(conditionals_and_loops_dart)
import "dart:html";

class Book {
  String title;
  num price;
  num numPages;
  bool available;
 
  Book(this.title, this.price, this.numPages, [this.available=true]);
}

// BEGIN(conditionals_and_loops_noBooks_dart)
List<Book> books = [];
bool get noBooks => books.isEmpty;
// END(conditionals_and_loops_noBooks_dart)

// BEGIN(conditionals_and_loops_showBookDetails_dart))
bool showBookDetails = true;
// END(conditionals_and_loops_showBookDetails_dart))


// BEGIN(conditionals_and_loops_emptyBookList)
emptyBookList() {
  books = []; 
  return false;
}
// END(conditionals_and_loops_emptyBookList)

main() {
  books = [
    new Book("War and Peace", 20.99, 1013),
    new Book("Anna Karenina", 23.99, 1243, false),
    new Book("The Old Man and the Sea", 8.99, 78)
  ]; 
}
