import 'dart:html';

void main() {
  DivElement element = query('div');
  assert(element.getComputedStyle().fontFamily == 'sans-serif');
  assert(element.getComputedStyle().fontWeight == 'bold');
  assert(element.getComputedStyle(':after').content == "' rocks!'");
  
  // Getting classes.
  assert(element.classes.length == 1);
  assert(element.classes.first == 'bold');

  
  // Adding a class.
  element.classes.add('underlined');
  assert(element.classes.length == 2);
  assert(element.classes.contains('underlined'));
  assert(element.getComputedStyle().textDecoration == 'underline');
  
  // Removing a class.
  element.classes.remove('underlined');
  assert(element.classes.contains('underlined') == false);
  assert(element.getComputedStyle().textDecoration == 'none');
  
  // Toggling a class.
  element.classes.toggle('underlined');
  assert(element.classes.contains('underlined'));
  element.classes.toggle('underlined');
  assert(element.classes.contains('underlined') == false);

  // Assigning style properties directly.
  String color = 'rgb(120, 120, 120)';
  element.style
    ..color = color
    ..border = '1px solid rgb(0, 0, 0)';
  assert(element.getComputedStyle().color == color);
  assert(element.getComputedStyle().border == '1px solid rgb(0, 0, 0)');
}
      