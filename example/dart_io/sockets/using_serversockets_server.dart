import 'dart:io';
import 'dart:convert';

main() {
  ServerSocket.bind('127.0.0.1', 4041)
    .then((serverSocket) {
      print('connected');
      serverSocket.listen((socket) {
        socket.transform(UTF8.decoder).listen(print);
      });
    });
}