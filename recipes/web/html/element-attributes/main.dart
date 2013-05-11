import 'dart:html';

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
  assert(element.attributes['data-purpose'] == 'informational');
  
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
  assert(element.dataset.keys.first == 'purpose');
  assert(element.dataset['purpose'] == 'informational');
  element.dataset['purpose'] = 'biographical';
  assert(element.dataset['purpose'] == 'biographical');
}