// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@MirrorsUsed(override: '*')
import 'dart:mirrors';

import 'package:angular/angular.dart';

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  targets: const [MyController],
  override: '*')
@NgController(
  selector: '[my-controller]',
  publishAs: 'ctrl'
)
class MyController {
  bool show = false;
}

main() {
  ngBootstrap(module: new Module()..type(MyController));
}