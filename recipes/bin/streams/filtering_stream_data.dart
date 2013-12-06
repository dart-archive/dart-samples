import 'dart:async';



void main() {

  List<String> beatles = ['john', 'paul', 'george', 'ringo'];
  Stream stream = new Stream.fromIterable(beatles).asBroadcastStream();
  
  /* Getting a Stream */
  stream.where((item) => item.length == 4).listen(print); // john, paul
  stream.skip(2).listen(print); // 'george', 'ringo'
  stream.take(3).listen(print); //  john, paul, george
  
  // Take as long as condition is true.
  stream.takeWhile((item) => item.endsWith('n')).listen(print); // john
  
  // Skip as long as condition is true.
  stream.skipWhile((item) => item.length == 4).listen(print); // george, ringo
  
  new Stream.fromIterable(['h', 'o', 'b', 'b', 'i', 't']).distinct()
      .listen(print); // h, o, b, i, t
  
  /* Getting a single item. */
   stream.first.then(print); // john
   stream.last.then(print); // ringo
   stream.firstWhere((item) => item.length > 4).then(print); // george
   stream.lastWhere((item) => item.length > 4).then(print); // ringo
   stream.elementAt(2).then(print); // george
}