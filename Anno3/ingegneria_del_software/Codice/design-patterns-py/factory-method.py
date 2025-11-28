from abc import ABC, abstractmethod

#
# Product
#
class Product(ABC):
  @abstractmethod
  def doStuff(self) -> str:
    pass

class ConcreteProduct1(Product):
  def doStuff(self) -> str:
    return "Prod1"

class ConcreteProduct2(Product):
  def doStuff(self) -> str:
    return "Prod2"

# 
# Creator
#  
class Creator():
  def logic(self) -> None:
    p = self.create()
    print(p.doStuff())

  def create(self) -> Product:
    return ConcreteProduct1()
  
class ConcreteCreator1(Creator):
  def create(self) -> ConcreteProduct1:
    return ConcreteProduct1()

class ConcreteCreator2(Creator):
  def create(self) -> ConcreteProduct2:
    return ConcreteProduct2()

if __name__ == "__main__":
  c = ConcreteCreator2()
  c.logic()