import 'package:polymer/polymer.dart';
import 'package:angular/angular.dart';
import './my_controller.dart' show MyController;

@MirrorsUsed(override: '*')
import 'dart:mirrors';

  // Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  targets: const ['my_controller'],
  override: '*')
void main() {
  initPolymer();
  ngBootstrap(module: new Module()
  ..type(MyController));
}
