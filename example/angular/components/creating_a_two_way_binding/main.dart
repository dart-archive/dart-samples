// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import './my_controller.dart';
import './component_one.dart';
import './component_two.dart';

main() {
  ngBootstrap(module: new Module()
      ..type(MyController)
      ..type(ComponentOne)
      ..type(ComponentTwo));
}