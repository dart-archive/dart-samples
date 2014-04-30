library waiting_until_an_element_is_ready.my_element;

import 'package:polymer/polymer.dart';

@CustomTag('my-element')
class MyElement extends PolymerElement {
  @observable String owner = 'Daniel';
  MyElement.created() : super.created();

  ready() {
    $['el'].text = "$owner is ready!";
  }
}
