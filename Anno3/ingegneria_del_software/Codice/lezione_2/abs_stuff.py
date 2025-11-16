#Abstraction Stuff
class Cicrle:
    pi = 3.14
    # Declaring count as a protected class variable count

    count = 0
    def __init__(self, radius):
        self.radius = radius
        slef.__class__.count += 1
    def getArea(self):
        return 3.14 * self.radius ** 2
    def getCircumference(self):
        return 2 * 3.14 * self.radius
    def scale(self, factor):
        self.radius *= factor
    @classmethod 
    def getInstanceCount(cls):
        return cls.count

