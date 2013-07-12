import 'dart:html';
      
void main() {
  var ul = query('ul');
  assert(ul.children.length == 3);
  
  var targetItem = query('#target');
  var li = new LIElement();
  li.text = 'Added before target';
  targetItem.parent.insertBefore(li, targetItem);
  assert(ul.children.length == 4);
  assert(targetItem.previousElementSibling.outerHtml == '<li>Added before target</li>');
  
  li = new LIElement();
  li.text = 'Added after target';
  targetItem.parent.insertBefore(li, targetItem.nextElementSibling);
  print(targetItem.nextElementSibling.outerHtml == '<li>Added after target</li>');
}
