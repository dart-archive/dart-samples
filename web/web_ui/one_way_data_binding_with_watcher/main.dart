// BEGIN(one_way_data_binding_with_watcher_dart)
import 'package:web_ui/watcher.dart' as watcher; // import the watcher
import 'dart:math';
import 'dart:html';

String die1;
String die2;
Random random = new Random();

void rollDice() {
  die1 = _rollDie();
  die2 = _rollDie();
}

String _rollDie() {
  return (random.nextInt(6) + 1).toString();
}

main() {
  rollDice();
  window.setInterval(() {
    rollDice();
    watcher.dispatch(); // dispatch the watcher repeatedly
  }, 2000);
}
