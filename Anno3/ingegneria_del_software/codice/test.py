from typing import override


class Animal:
    pass

class Dog(Animal):
    pass

class GR_Type(type):
    def __init__(cls, name, bases, dct):
        pass
    def __new__(cls, name, *args, **kwargs):
        return super().__new__(cls, name, *args, **kwargs)
    def __call__(self, *args, **kwds):
        return super().__call__(self, *args, **kwds)

class GR(Dog, metaclass=GR_Type):
    def __init__(self, *args):
        pass
    def __new__(cls, *args, **kwargs):
        return super().__new__(cls)

if __name__ == '__main__':
    a = Animal()
    dog = Dog()
    # mcs = GR_Type()
    lexy = GR()
    print(dog.__class__.__base__)

