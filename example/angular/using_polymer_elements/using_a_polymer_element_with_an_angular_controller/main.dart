import 'package:polymer/polymer.dart';
import 'package:angular/angular.dart';
import './my_controller.dart' show MyController;

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
targets: const ['my_controller'],
override: '*')
import 'dart:mirrors';

void main() {
  initPolymer();
  ngBootstrap(module: new Module()
  ..type(MyController));
}
