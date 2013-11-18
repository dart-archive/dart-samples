import 'dart:html';

void main() {

  var ol = querySelector('ol');
  List<Element> children = ol.children;

  // RemoveAt()
  assert(children[1].innerHtml == 'Antarctica');
  children.removeAt(1);
  assert(children[1].innerHtml == 'Asia');

  // removeLast()
  children.removeLast();
  assert(children.last.innerHtml == 'North America');

  // remove()
  assert(children[1].innerHtml == 'Asia');
  children.remove(ol.querySelector('.largest'));
  assert(children[1].innerHtml == 'Australia');

  // Remove all.
  children.clear();
  assert(children.isEmpty);
}
