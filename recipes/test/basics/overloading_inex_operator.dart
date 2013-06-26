class User implements Map {
  Map<String, dynamic> data = {};

  static int userCount = 0;

  User(this.data) {
    userCount++;
  }

  String toString() {
    return 'data: ${this.data}';
  }

  bool containsKey(String key) => data.keys.contains(key);

  operator[](String key) => data[key];

  void operator[]=(String key, var value) {
    data[key] = value;
  }

  Iterable<dynamic> get keys => data.keys;

  Iterable get values => data.values;

  // ...

}

void main() {
  var user1 = new User({'name': 'bob', 'age': 24});
  var user2 = new User({'name': 'robert', 'age': 23, 'username': 'robert234'});
  user1['age'] = 25;
  print(user1);
}