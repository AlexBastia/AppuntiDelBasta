class House:
  def __init__(self, size, wallCount, hasRoof, hasGarden):
    self.size = size
    self.walls = wallCount
    self.hasRoof = hasRoof
    self.hasGarden = hasGarden
  def __repr__(self):
    return f"{self.size} {self.walls} {self.hasRoof} {self.hasGarden}"

class Builder:
  def reset(self):
    pass
  def getResult(self):
    pass
  def setSize(self, size):
    pass
  def buildWalls(self, wallCount):
    pass
  def buildRoof(self, hasRoof):
    pass
  def buildGarden(self, hasGarden):
    pass

class HouseBuilder(Builder):
  def __init__(self):
    self.__result = None
    self.__size = 20
    self.__wallCount = 4
    self.__hasRoof = True
    self.__hasGarden = False

  def reset(self):
    self.__result = None
    self.__size = 20
    self.__wallCount = 4
    self.__hasRoof = True
    self.__hasGarden = False
  def setSize(self, size):
    self.__size = size
  def buildWalls(self, wallCount):
    self.__wallCount = wallCount
  def buildRoof(self, hasRoof):
    self.__hasRoof = hasRoof
  def buildGarden(self, hasGarden):
    self.__hasGarden = hasGarden
  def getResult(self):
    self.__result = House(self.__size, self.__wallCount, self.__hasRoof, self.__hasGarden)
    return self.__result
  
class Director:
  __builder: Builder = None
  def __init__(self,builder):
    self.__builder = builder
  def make(self, type):
    if type == "HouseWithGarden":
      self.__builder.reset()
      self.__builder.setSize(30)
      self.__builder.buildGarden(True)
      return self.__builder.getResult()
    else:
      self.__reset()
      return self.__getResult()

if __name__ == "__main__":
  builder = HouseBuilder()
  director = Director(builder)
  house = director.make("HouseWithGarden")
  print(house)