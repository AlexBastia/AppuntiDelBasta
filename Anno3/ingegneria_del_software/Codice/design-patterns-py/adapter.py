class Application:
  __radius: int

  def __init__(cls, radius):
    cls.__radius = radius

  @property
  def radius(cls):
    return cls.__radius

  @property.setter 
  def radius(cls, newRadius):
    cls.__radius = newRadius

  @classmethod
  def fits(cls, roundPeg):
    if roundPeg.radius <= cls.__radius:
      print("Yes!")
    else:
      print("No.")

class RoundPeg:
  def __init__(self, radius):
    self.__radius = 