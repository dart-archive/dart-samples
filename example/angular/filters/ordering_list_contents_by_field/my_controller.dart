// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_controller;

import 'package:angular/angular.dart';

class User {
  String firstName, lastName;
  User(this.firstName, this.lastName);
}

@NgController(
    selector: '[my-controller]',
    publishAs: 'ctrl'
)
class MyController {
  List<User> users = [
    new User('Kathy', 'Walrath'),
    new User('Seth', 'Ladd'),
    new User('Mary', 'Campione')
  ];
}