// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';

void main() {
  InputElement username = querySelector('#username');
  InputElement submit = querySelector('#save');
  Element output = querySelector('#username-output');
  Storage localStorage = window.localStorage;

  // Local storage is a Map, supporting string keys and values.
  String savedUsername = localStorage['username'];

  if (savedUsername != null) {
    output.text = savedUsername;
  }

  submit.onClick.listen((Event e) {
    output.text = username.value;
    localStorage['username'] = username.value;
  });
}
