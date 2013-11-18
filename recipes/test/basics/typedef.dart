typedef void LogOutputFunc(String logData);

class Logger {
  LogOutputFunc func;
  Logger(this.func);

  void log(String logData) {
    func(logData);
  }
}

void timestampedPrint(String msg) => print('${new DateTime.now()}: $msg');

void main() {
  Logger l = new Logger(print);
  l.log('some log data');
  l.func = timestampedPrint;
  l.log('some log data');
}