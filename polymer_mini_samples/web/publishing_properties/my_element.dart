library publishing_properties.my_element;

import 'package:polymer/polymer.dart';

@CustomTag('my-element')
class MyElement extends PolymerElement {
  @published String color = 'red';
  @published String owner = 'Daniel';
  MyElement.created() : super.created();
}
