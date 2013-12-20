import 'dart:io';

main() {
  WebSocket.connect('ws://127.0.0.1:4040/ws').then((socket) {
    socket.add('Hello, World!');
  });
}