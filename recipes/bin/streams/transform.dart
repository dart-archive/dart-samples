import 'dart:async';
import 'dart:io';

void main() {
  List<List<String>> birds = [['quetzal', 'Central America'], 
                              ['peacock', 'India'], 
                              ['macaw', 'Brazil']];
  
  Stream stream = new Stream.fromIterable(birds);
  
  var transformer = new StreamTransformer(handleData: (value, sink) {
    sink.add("Name: ${value.first}, Found in: ${value.last}");
  });
  
  stream.transform(transformer).listen(print);
}

// Name: quetzal, Found in: Central America
// Name: peacock, Found in: India
// Name: macaw, Found in: Brazil
