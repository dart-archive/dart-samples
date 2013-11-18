import 'dart:html';

void main() {

  querySelector('a').onClick.listen((event) {

    // Find all out of stock items and remove them from the DOM.
    querySelectorAll('.out-of-stock').forEach((item) {
      item.remove();
    });

    event.preventDefault();

    // Remove the link from the DOM.
    event.target.remove();
  });
}
