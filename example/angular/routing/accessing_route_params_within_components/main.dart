// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  targets: const ['my_controller', 'my_router', MyAppModule],
  override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';
import 'my_router.dart' show MyRouteInitializer;
import 'my_controller.dart' show MyController;
import 'book_component.dart' show BookComponent;

class MyAppModule extends Module {
  MyAppModule() {
    type(MyController);
    type(BookComponent);
    type(RouteInitializer, implementedBy: MyRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}
