// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

import 'dart:html';
import 'dart:isolate';

void worker2() {
  port.receive((msg, SendPort reply) {
    switch (msg['cmd']) {
      case 'start':
        reply.call('WORKER STARTED: ${msg["msg"]}');
        break;

      case 'foobard':
        reply.call('Unknown command: ${msg["msg"]}');
        break;

      case 'stop':
        reply.call('WORKER STOPPED: ${msg["msg"]}. (buttons will no longer work)');
        port.close(); // Terminates the worker.
        break;
    }
  });
}

void main() {
  SendPort  workerPort;
  ButtonElement sayHI = query("#sayHI");
  ButtonElement unknownCmd = query("#unknownCmd");
  ButtonElement stop = query("#stop");
  OutputElement result = query("#result");

  sayHI.onClick.listen((MouseEvent event) {
    workerPort.call({'cmd': 'start', 'msg': 'Hi'}).then((reply) {
      query('#result').text = reply;
    });
  });

  unknownCmd.onClick.listen((MouseEvent event) {
    workerPort.call({'cmd': 'foobard', 'msg': '???'}).then((reply) {
      query('#result').text = reply;
    });
  });

  stop.onClick.listen((MouseEvent event) {
    workerPort.call({'cmd': 'stop', 'msg': 'Bye'}).then((reply) {
      query('#result').text = reply;
    });
  });

  workerPort = spawnDomFunction(worker2);
}

