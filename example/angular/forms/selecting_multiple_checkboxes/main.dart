// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Temporary, please follow https://github.com/angular/angular.dart/issues/476
@MirrorsUsed(
  targets: const [MyController],
  override: '*')
import 'dart:mirrors';
import 'package:angular/angular.dart';


@NgController(
  selector: '[my-controller]',
  publishAs: 'ctrl'
)
class MyController {
  List<Map> fruits = <Map>[
    {'name': 'apple', 'selected': true},
    {'name': 'banana', 'selected': true},
    {'name': 'kiwi', 'selected': false}
  ];

  List<Map> get selectedFruits {
    return fruits.where((Map fruit) => fruit['selected']).toList();
  }
}

main() {
  ngBootstrap(module: new Module()..type(MyController));
}