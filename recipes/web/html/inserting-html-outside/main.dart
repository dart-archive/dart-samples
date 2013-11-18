import 'dart:html';

void main() {
  var ul = querySelector('ul');
  assert(ul.children.length == 3);

  var targetItem = querySelector('#target');
  var li = new LIElement();
  li.text = 'Added before target';
  targetItem.parent.insertBefore(li, targetItem);
  assert(ul.children.length == 4);
  assert(targetItem.previousElementSibling.outerHtml == '<li>Added before target</li>');

  li = new LIElement();
  li.text = 'Added after target';
  targetItem.parent.insertBefore(li, targetItem.nextElementSibling);
  assert(targetItem.nextElementSibling.outerHtml == '<li>Added after target</li>');
}
