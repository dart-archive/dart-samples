import 'dart:async';
import 'dart:io';

void main() {
  int counter = 1;  
  new File('README.md')
    .openRead()
    .transform(new StringDecoder())    // Decodes from bytes to characters.
    .transform(new LineTransformer())  // Applied transformation to each line.
    .listen((value) => print("${counter++}: $value"));
}