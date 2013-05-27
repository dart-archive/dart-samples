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

Stream<int> timedFibonacci(Duration interval) {                    
  StreamController<int> controller;                                              
  Timer timer;                                                                   
  int counter = 0;
                                                                            
  void start() {                              
    timer = new Timer.periodic(interval, (_) {
      controller.add(fibonacci(counter++));
      if (counter == 25) {
        timer.cancel();
        controller.close();                             
      }
    });                                  
  }                                              

  void stop() {                                                             
    if (timer != null) {                                                         
      timer.cancel();                       
      timer = null;                                                              
    }                                                                            
  }                                                                 

  controller = new StreamController<int>(                                        
      onListen: start,                                                    
      onPause:  stop,                                                      
      onResume: start,                                                      
      onCancel: stop);  
                                                                                 
  return controller.stream;                                                      
}

void main() {  
  StreamSubscription<int> subscription;
  Stream stream = timedFibonacci(new Duration(milliseconds: 250));
  new Timer(new Duration(seconds: 4), () {
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