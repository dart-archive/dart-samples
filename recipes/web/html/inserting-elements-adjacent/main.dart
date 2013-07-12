import 'dart:html';

void main() {
  var ul = query('ul');
  assert(ul.children.length == 3);
  
  var targetItem = query('#target');
  var li = new LIElement();
  li.text = 'Added before target';
  targetItem.insertAdjacentElement('beforeBegin', li);
      
  assert(ul.children.length == 4);
  assert(targetItem.previousElementSibling.outerHtml == '<li>Added before target</li>');
  print(targetItem.previousElementSibling.outerHtml);
  
  li = new LIElement();
  li.text = 'Added after target';
  
  targetItem.insertAdjacentElement('afterEnd', li);
  assert(targetItem.nextElementSibling.outerHtml == '<li>Added after target</li>');
  print(targetItem.nextElementSibling.outerHtml);
}
