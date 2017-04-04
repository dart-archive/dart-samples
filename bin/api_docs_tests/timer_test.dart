import 'dart:async';

void main() {
  const TIMEOUT = const Duration(seconds: 3);
  const ms = const Duration(milliseconds: 1);

  startTimeout([int milliseconds]) {
    var duration = milliseconds == null ? TIMEOUT : ms * milliseconds;
    return new Timer(duration, handleTimeout);
  }
}
void handleTimeout() {  // callback function
/*...*/
}
