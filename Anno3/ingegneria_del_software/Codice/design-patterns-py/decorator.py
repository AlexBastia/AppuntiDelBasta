from abc import ABC, abstractmethod

#
# Component
#
class Component(ABC):
  @abstractmethod
  def doStuff(self) -> str:
    pass

class ConcreteComponent(Component):
  def doStuff(self) -> str:
    return "Component"

#
# Decorator
#
class Decorator(Component):
  def __init__(self, wrapped: Component):
    self._wrapped = wrapped

  def doStuff(self) -> str:
    return self._wrapped.doStuff()

class ConcreteDecoratorA(Decorator):
  def doStuff(self) -> str:
    return f"DecoratorA({super().doStuff()})"

class ConcreteDecoratorB(Decorator):
  def doStuff(self) -> str:
    return f"DecoratorB({super().doStuff()})"

if __name__ == "__main__":
  c = ConcreteComponent()
  a = ConcreteDecoratorA(c)
  b = ConcreteDecoratorB(a)
  print(b.doStuff())
