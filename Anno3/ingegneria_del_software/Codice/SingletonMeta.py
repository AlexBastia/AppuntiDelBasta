class FigureType(type):
  def __new__(cls, name, bases, attrs):
    return super().__new__(cls, name, bases, attrs)
  def __init__(cls, name, bases, attrs):
    cls.__instance = None
    return super().__init__(name, bases, attrs)
  def __call__(cls, *args, **kwds):
    if cls.__instance == None:
      cls.__instance = super().__call__(*args, **kwds)

    return cls.__instance

class Figure(metaclass=FigureType):
  count = 0

  def __new__(self, *args, **kwds):
    return super().__new__(self)

  def __init__(self, figName):
    self.name = figName
    self.__class__.count += 1
    print('Created new instance')
  
if __name__ == "__main__":
  a = Figure("Triangle")
  b = Figure("Square")
  c = Figure("Pentagon")
  print(Figure.count)
  print(c.name)