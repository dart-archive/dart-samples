// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import './controller1.dart' show ControllerOne;
import './controller2.dart' show ControllerTwo;

main() {
  ngBootstrap(module: new Module()
      ..type(ControllerOne)
      ..type(ControllerTwo));
}