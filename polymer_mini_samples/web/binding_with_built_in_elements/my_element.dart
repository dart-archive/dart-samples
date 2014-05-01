library binding_with_built_in_elements.my_element;

import 'package:polymer/polymer.dart';

@CustomTag('my-element')
class MyElement extends PolymerElement {
  @observable var age = 25;
  @observable String name = 'Daniel';
  @observable String color = 'red';
  @observable String owner = 'Eric';

  MyElement.created() : super.created();

  void nameChanged() {
    if (name.isNotEmpty) {
      var tokens = name.split('');
      name = tokens[0].toUpperCase() + tokens.getRange(1, tokens.length).join();
    }
  }
}
