import 'package:polymer/polymer.dart';
import 'package:angular/angular.dart';
import './my_controller.dart' show MyController;

void main() {
  initPolymer();
  ngBootstrap(module: new Module()
  ..type(MyController));
}
