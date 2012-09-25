// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the COPYING file.

// This is a simple example of using Websockets.
// See: http://www.html5rocks.com/en/tutorials/websockets/basics/
//      https://github.com/sethladd/Dart-Web-Sockets
//
// This has been tested under Chrome and Firefox.

#import('dart:html');

WebSocket ws;

outputMsg(String msg) {
  var output = query('#output');
  var text = msg;
  if (!output.text.isEmpty()) {
    text = "${output.text}\n${text}";
  }
  output.text = text;
}

void initWebSocket([int retrySeconds = 2]) {
  bool encounteredError = false;
  
  outputMsg("Connecting to websocket");
  ws = new WebSocket('ws://echo.websocket.org');
  
  void handleError() {
    if (!encounteredError) {
      window.setTimeout(() => initWebSocket(retrySeconds * 2), 1000 * retrySeconds);
    }
    encounteredError = true;    
  }
  
  ws.on.open.add((e) {
    outputMsg('Connected');
    ws.send('Hello from Dart!');
  });
  
  ws.on.close.add((e) {
    outputMsg('Websocket closed, retrying in $retrySeconds seconds');
    handleError();
  });
  
  ws.on.error.add((e) {
    outputMsg("Error connecting to ws");
    handleError();
  });
  
  ws.on.message.add((MessageEvent e) {
    outputMsg('Received message: ${e.data}');
  });
}

void main() {
  initWebSocket();
}