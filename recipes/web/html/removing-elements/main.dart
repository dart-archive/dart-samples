import 'dart:html';
      
void main() {
  
  query('a').onClick.listen((event) {
  
    // Find all out of stock items and remove them from the DOM.
    queryAll('.out-of-stock').forEach((item) {
      item.remove();
    });
    
    event.preventDefault();
    
    // Remove the link from the DOM.
    event.target.remove();
  });
}
