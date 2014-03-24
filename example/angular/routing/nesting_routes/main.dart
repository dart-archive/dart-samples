// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  targets: const ['my_router', 'my_controller'],
  override: '*')
import 'dart:mirrors';
import 'package:angular/angular.dart';
import 'my_router.dart' show myRouteInitializer;

class MyAppModule extends Module {
  MyAppModule() {
    value(RouteInitializerFn, myRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

main() {
  ngBootstrap(module: new MyAppModule());
}
