class SingletonMeta(type):
  __instances = {}
  
  def __call__(cls, *args, **kwds):
    if cls not in cls.__instances:
      cls.__instances[cls] = super().__call__(*args, **kwds)
    return cls.__instances[cls]
  
class Singleton(metaclass=SingletonMeta):
  pass
