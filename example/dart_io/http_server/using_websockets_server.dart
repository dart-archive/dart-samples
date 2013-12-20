import 'dart:io';
import 'dart:async';

handleMsg(msg) {
  print('Message received: $msg');
}

main() {
  runZoned(() {
    HttpServer.bind('127.0.0.1', 4040).then((server) {
      server.listen((HttpRequest req) {
        if (req.uri.path == '/ws') {
          // Upgrade a HttpRequest to a WebSocket connection.
          WebSocketTransformer.upgrade(req).then((socket) {
            socket.listen(handleMsg);
          });
        }
      });
    });
  },
  onError: (e) => print("An error occurred."));
}