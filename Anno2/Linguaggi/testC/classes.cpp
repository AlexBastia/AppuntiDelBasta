#include <iostream>

// Class inheritance
class A {
public:
  int x = 1;
  void incr() { x++; }
};

class B : public A {
public:
  int z = 2;
  void print() { std::cout << x << std::endl; }
};

int main() {
  A a;
  B b;
  a.incr();
  b.incr();
  b.print();
  A *c = new B();
  std::cout << ((B *)c)->z;
}
