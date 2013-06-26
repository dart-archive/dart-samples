class Counter {
  int value = 0;

  Counter(this.value);

  call() {
    return value++;
  }
}

class Accumulator {
  int value;
  Accumulator (this.value);

  call(int x) => value += x;
}


void main() {
  var c = new Counter(10);
  print(c());  // 10
  print(c());  // 11

  var accum = new Accumulator(3);
  print(accum(10)); // 13
  print(accum(5));  // 18

  return;
}