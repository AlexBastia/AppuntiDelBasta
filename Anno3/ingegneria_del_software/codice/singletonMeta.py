class Singleton(type):
    __instance = None

    def __call__(cls, *args, **kwargs):
        print("Calling...")
        if cls.__instance is None:
            print("Creating instance of class")
            print(type(cls))
            cls.__instance = type.__call__(cls, *args, **kwargs)
        return cls.__instance

class Test(metaclass=Singleton):
    def __init__(self):
        pass

if __name__ == "__main__":
    t = Test()
    t = Test()
    t = Test()
