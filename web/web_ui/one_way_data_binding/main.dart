// BEGIN(one_way_data_binding_dart)
import 'dart:math';

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
}
