import 'dart:async';

int fibonacci(int n) {
  int first = 0, second = 1;
  for(int i = 0; i < n; i++) {
      int temp = first;
      first = second;
      second = temp + second;
  }
  return first;
}

// THIS IS BAD. DON'T DO THIS.                                                   
Stream<int> timedFibonacci(Duration interval) {                                  
  StreamController<int> controller = new StreamController();                     
  Timer timer;                                                                   
  int counter = 0;                                                               
  timer = new Timer.periodic(interval, (_) {                                     
    controller.add(fibonacci(counter++));                                        
    if (counter == 25) {                                                         
      timer.cancel();                                                            
      controller.close();                                                        
    }                                                                            
  });                                                                                                                                                         
  return controller.stream;                                                      
}     

void main() {                                                                    
  StreamSubscription<int> subscription;                                          
  Stream stream = timedFibonacci(new Duration(milliseconds: 250));               
  new Timer(new Duration(seconds: 2), () {                                       
    subscription = stream.listen(print);                                         
                                                                                 
    new Timer.periodic(new Duration(seconds: 1), (_) {                           
      if (subscription.isPaused) {                                               
        subscription.resume();                                                   
      } else {                                                                   
        subscription.pause();                                                    
      }                                                                          
    });                                                                          
  });                                                                            
}   