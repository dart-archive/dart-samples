import 'package:polymer/polymer.dart';

/**
 * A Polymer click counter element.
 */
@CustomTag('click-counter')
class ClickCounter extends PolymerElement {
  @published int count = 0;
  bool applyAuthorStyles = true;

  ClickCounter.created() : super.created() {}

  void increment() {
    count++;
  }
}

