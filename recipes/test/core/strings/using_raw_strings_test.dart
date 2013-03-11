library using_raw_strings_test;

import 'package:unittest/unittest.dart';

void main() {
  var x = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
  var y = "\u0061sdf";
  var z = "asdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
  print(x == z);
  print(identical(x, z));
  print("$x, $z");
  return;
  
  var string = '+1,';
  var r = r'(\+|-)?\d+';
  var r2 = '(\+|-)?\d+';
  print("r = $r");
  print("r2 = $r2");
  print('When properly escaped: ' r'(\\+|-)?\\d+');
  var regExp = new RegExp(r);
  
  print(regExp.firstMatch(string).group(0));
  print(3.0 == 3.0000);
}