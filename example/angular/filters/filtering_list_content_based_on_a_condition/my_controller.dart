// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_controller;

import 'package:angular/angular.dart';

class User {
  String name;
  User(this.name);
}

@NgController(
    selector: '[my-controller]',
    publishAs: 'ctrl'
)
class MyController {
  List<User> users = [
    new User('Anna'),
    new User('Hannah'),
    new User('Mary'),
    new User('Mem'),
    new User('Otto'),
  ];

  // Cool names are palindromes!
  bool isCoolName(user) {
    if (user.name.isEmpty) return false;

    var buffer = new StringBuffer();
    var name = user.name.toLowerCase();

    for (int i = name.length - 1; i >= 0; i--) {
      buffer.write(name[i]);
    }
    return name == buffer.toString();
  }
}