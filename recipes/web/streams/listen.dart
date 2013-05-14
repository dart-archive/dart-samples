import 'dart:html';
import 'dart:async';

void main() {
  var button = new ButtonElement();
  assert(button.onClick is Stream);
  assert(button.onClick.isBroadcast);
  
  document.body.children.add(button);
  button.text = "Click me";
  
  button.onClick.listen((mouseEvent) {
    print("first click");
  });

  button.onClick.listen((mouseEvent) {
    print("second click");
  });
}