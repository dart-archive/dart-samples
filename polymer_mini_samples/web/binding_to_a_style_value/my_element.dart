library binding_to_a_style_value.my_element;

import 'package:polymer/polymer.dart';

@CustomTag('my-element')
class MyElement extends PolymerElement {
  @observable String owner = 'Daniel';
  @observable String color = 'red';
  MyElement.created() : super.created();
}
