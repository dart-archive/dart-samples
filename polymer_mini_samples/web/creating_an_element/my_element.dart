library creating_an_element.my_element;

import 'package:polymer/polymer.dart';

@CustomTag('my-element')
class MyElement extends PolymerElement {
  @observable String name = 'John';
  MyElement.created() : super.created();
}
