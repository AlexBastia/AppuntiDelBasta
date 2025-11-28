from abc import ABC, abstractmethod

class Shape(ABC):

  def __init__(self, cpyShape=None):
    if not cpyShape == None:
      self.color = cpyShape.color
    else:
      self.color = "blue"

  @abstractmethod
  def clone(self):
    pass

class Circle(Shape):

  def __init__(self, cpyCircle=None):
    if not cpyCircle == None:
      self.radius = cpyCircle.radius
    else:
      self.radius = 1
    super().__init__(cpyCircle)

  def clone(self):
    return Circle(self) 
  
if __name__ == "__main__":
  c = Circle()
  cpy = c.clone()