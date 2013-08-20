import 'dart:typed_data';

class User  {
  Map<String, dynamic> data = {};

  static int userCount = 0;

  User(this.data) {
    userCount++;
  }

  operator[](String key) => data[key];

  void operator[]=(String key, var value) {
    data[key] = value;
  }
}

class Vector3D {
  final Float32List _storage = new Float32List(3);

  Vector3D(double x_, double y_, double z_) {
    _storage[0] = x_;
    _storage[1] = y_;
    _storage[2] = z_;
  }

  double operator[](int i) => _storage[i];
  void operator[]=(int i, double v) { _storage[i] = v; }
}

doSomethingWith(obj) => obj;

void main() {
  var v3 = new Vector3D(3.1, 2.7, 4.5);
  doSomethingWith(v3[0]);
  v3[0] = 4.2;
  print(v3[0] == v3._storage[0]);
}