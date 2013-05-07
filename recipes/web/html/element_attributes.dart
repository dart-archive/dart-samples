import 'dart:html';
import 'dart:svg';

void main() {
  InputElement element = query('input');
  assert(element.id == 'fname');
  element.classes.add('first-name');
  assert(element.classes.first == 'first-name');
  
  element.size = 30;
  assert(element.size == 30);
  element.maxLength = 10;
  assert(element.maxLength == 10);
  assert(element.name == 'fname');
  
  // Get a value. 
  assert(element.attributes['id'] == 'fname');
  assert(element.attributes['name'] == 'fname');
  assert(element.attributes['data-some-random-key'] == 'someValue');
  
  // Set a value
  element.attributes['id'] = 'first-name';
  element.attributes['name'] = 'first-name';
  assert(element.attributes['id'] == 'first-name');
  assert(element.attributes['name'] == 'first-name');
  
  // Add an attribute
  element.attributes['size'] = '30';
  assert(element.attributes['size'] == '30');
  
  // Remove an attribute.
  element.attributes.remove('id');
  assert(element.attributes['id'] == null);
  
  // data-* attributes
  assert(element.dataset.length == 1);
  assert(element.dataset.keys.first == 'some-random-key');
  assert(element.dataset['some-random-key'] == 'someValue');
  element.dataset['some-random-key'] = 'someOtherValue';
  assert(element.dataset['some-random-key'] == 'someOtherValue');
  print(element.dataset.runtimeType);
  print(element.attributes.runtimeType);
  
  
  // namespaced attributes
  var img = new SvgElement.tag("image");
  img.attributes = {"x":"140", "y":"140", "width":"320", "height":"240"};
  img.attributes["xlink:href"] = 'http://dartlang.org/';
}