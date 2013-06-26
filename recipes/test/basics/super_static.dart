abstract class Parent {
  static int theAnswer() => 42;
}

class Child extends Parent {
  String getTheAnswer() => "The answer is: ${Parent.theAnswer()}";
}

void main() {
  Child child = new Child();
  print(child.getTheAnswer());
}