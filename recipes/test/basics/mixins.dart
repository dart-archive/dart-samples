abstract class Inspectable {
  String whoAmI() {
    return "hashCode: ${this.hashCode}, runtimeType: ${this.runtimeType}";
  }
}

abstract class Persistable {

}

abstract class Persistence {
  void save(String filename) {
   print('saving the object as ${asMap()}');
  }

  void load(String filename) {
   print('loading from $filename');
  }

  Object asMap() => throw 'asdf';
 }


abstract class Warrior extends Object with Persistence {}

class Ninja extends Warrior {
 Map asMap() => {'throwing_stars': true};
}

class Zombie extends Warrior {
 Map asMap() => {'eats_brains': true};
}

class Person extends Object with Inspectable {
  String firstName, lastName;
  Person(this.firstName, this.lastName);
}

class Employee extends Person {
  String username;
  Employee(firstName, lastName, this.username) : super(firstName, lastName);
}


void main() {
  return;
  var person = new Person('john', 'smith');
  print(person.whoAmI());
  var employee = new Employee('john', 'smith', 'jsmith');
  print(employee.whoAmI());
}