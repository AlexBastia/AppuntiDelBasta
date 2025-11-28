from abc import ABC, abstractmethod

class Chair(ABC):
  @abstractmethod
  def sitOn(self):
    pass
class Table(ABC):
  @abstractmethod
  def placeOn(self):
    pass

class VictorianChair(Chair):
  def sitOn(self):
    print("Sitting on Victorian CHair")
class ModernChair(Chair):
  def sitOn(self):
    print("Sitting on Modern CHair")
class VictorianTable(Table):
  def placeOn(self):
    print("Placing on Victorian Table")
class ModernTable(Table):
  def placeOn(self):
    print("Placing on Modern Table")

class AbstractFactory(ABC):
  @abstractmethod
  def createChair(self):
    pass
  @abstractmethod
  def createTable(self):
    pass

class VictorianFactory(AbstractFactory):
  def createChair(self):
    print("Creating victorian chair")
    return VictorianChair()
  def createTable(self): 
    print("Creating victorian Table")
    return VictorianTable()

class ModernFactory(AbstractFactory):
  def createChair(self):
    print("Creating modern chair")
    return ModernChair()
  def createTable(self):
    print("Creating modern Table")
    return ModernTable()
  
class Application:
  factory: AbstractFactory
  @classmethod
  def initialize(cls):
    cls.factory = ModernFactory()

  @classmethod 
  def doStuff(cls):
    c: Chair = cls.factory.createChair()
    t: Table = cls.factory.createTable()
    c.sitOn()
    t.placeOn()

if __name__ == "__main__":
  app = Application()
  app.initialize()
  app.doStuff() 