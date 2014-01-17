// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library my_controller;

import 'package:angular/angular.dart';

@NgController(
    selector: '[my-controller]',
    publishAs: 'ctrl'
)
class MyController {
  String style1 = '', style2 = '', style3 = '';

  boldAndStrike() {
    style1 = 'bold'; style2 = 'strike'; style3 = '';
  }

  boldAndRed() {
    style1 = 'bold'; style2 = ''; style3 = 'red';
  }

  strikeAndRed() {
    style1 = ''; style2 = 'strike'; style3 = 'red';
  }
}