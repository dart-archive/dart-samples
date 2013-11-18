import 'dart:html';

void main() {
  var original = query('input');
  var clone = original.clone(true);
  assert(original.attributes['type'] == original.attributes['type']);
  assert(original.attributes['name'] == original.attributes['name']);
  assert(original.attributes['size'] == original.attributes['size']);
  assert(clone.parent == null);

  
}