import 'dart:html';

void main() {
  var ul = querySelector('ul');
  assert(ul.children.isEmpty);

  // Append using List#add()
  var li = new LIElement();
  li.text = 'One banana';
  ul.children.add(li);
  assert(ul.children.last.outerHtml == '<li>One banana</li>');

  // Append using List#addAll()
  List<LIElement> items = [];
  items.add(new LIElement()..text = 'Three banana');
  items.add(new LIElement()..text = 'Four banana');
  ul.children.addAll(items);
  assert(ul.children[1].outerHtml == '<li>Three banana</li>');
  assert(ul.children[2].outerHtml == '<li>Four banana</li>');

  // Inserting in the middle
  ul.children.insert(1, new LIElement()..text = 'Two banana');
  assert(ul.children[1].outerHtml == '<li>Two banana</li>');

  // Prepending using list method.
  ul.children.insert(0, new LIElement()..text = 'Zero banana');
  assert(ul.children.first.outerHtml == '<li>Zero banana</li>');

  // Append using element.append()
  ul.append(new LIElement()..text = 'Five banana');
  assert(ul.children.last.outerHtml == '<li>Five banana</li>');

  // Append using element.appendHtml()
  ul.appendHtml('<li>Six banana</li>');
  assert(ul.children.last.outerHtml == '<li>Six banana</li>');

  document.body.children.add(ul);
}

