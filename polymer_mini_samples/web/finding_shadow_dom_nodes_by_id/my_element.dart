library finding_shadow_dom_nodes_by_id.my_element;

import 'package:polymer/polymer.dart';

@CustomTag('my-element')
class MyElement extends PolymerElement {
  @published String color = 'red';
  @published String owner = 'Daniel';

  MyElement.created() : super.created();

  void setFocus() {
    $['nameInput'].focus();
  }
}
