class Circle:
  PI = 3.14159
  _count = 0
  def __init__(self, radius=1):
    self.__r = radius
    self.__class__._count+=1

  def __add__(self, other):
    return Circle(self.__r + other.__r)
  
  def __mul__(self, factor):
    return Circle(self.__r * factor)

  def __repr__(self):
    return "A circle"

  @classmethod
  def getInstanceCount(cls):
    return cls.count

  def getArea(self):
    return self.__r**2*self.PI

  def getCircumference(self):
    return self.__r*2*self.PI
  
import math

# 1. Define the custom Metaclass
class MetaLogger(type):
    """
    A custom metaclass that logs the calls to its
    __new__, __init__, and __call__ methods.
    
    This metaclass is responsible for CREATING the class object.
    """
    
    def __new__(mcs, name, bases, attrs):
        """
        Called to CREATE the new class object (e.g., 'Figure').
        This runs when Python first reads the 'class Figure...' block.
        
        mcs: The metaclass itself (MetaLogger)
        name: The name of the class being created ("Figure")
        bases: Tuple of parent classes
        attrs: Dictionary of class attributes/methods
        """
        print(f"[MetaLogger] __new__ called:")
        print(f"  mcs    = {mcs}")
        print(f"  name   = {name}")
        print(f"  bases  = {bases}")
        print(f"  attrs  = {list(attrs.keys())}")
        
        # Call the parent's __new__ (type.__new__) to actually create the class
        new_class = super().__new__(mcs, name, bases, attrs)
        print(f"[MetaLogger] __new__ finished, returning new class: {new_class}\n")
        return new_class

    def __init__(cls, name, bases, attrs):
        """
        Called to INITIALIZE the new class object ('Figure') *after*
        it has been created by __new__.
        
        cls: The new class object itself (Figure)
        """
        print(f"[MetaLogger] __init__ called:")
        print(f"  cls    = {cls}")
        print(f"  name   = {name}")
        # ...and so on
        
        # Call the parent's __init__ (type.__init__)
        super().__init__(name, bases, attrs)
        print(f"[MetaLogger] __init__ finished for class: {cls}\n")

    def __call__(cls, *args, **kwargs):
        """
        Called when an INSTANCE of the class is created.
        This is what 'Figure()' triggers.
        
        cls: The class object (Figure)
        *args, **kwargs: Arguments passed to the constructor (e.g., Figure(10))
        """
        print(f"[MetaLogger] __call__ called:")
        print(f"  cls    = {cls} (This is the class we are instantiating)")
        print(f"  *args  = {args}")
        print(f"  **kwargs = {kwargs}")
        
        # This super().__call__ will trigger the class's __new__ and __init__
        # (i.e., Figure.__new__ and Figure.__init__)
        print(f"[MetaLogger] __call__ is now calling super().__call__ to create the instance...")
        new_instance = super().__call__(*args, **kwargs)
        
        print(f"[MetaLogger] __call__ finished, returning instance: {new_instance}\n")
        return new_instance


print("--- Python is about to define the 'Figure' class ---")

# 2. Define the class using the Metaclass
class Figure(metaclass=MetaLogger):
    """
    A class representing a figure, which is itself an
    instance of MetaLogger.
    """
    
    def __new__(cls, *args, **kwargs):
        """
        Called to CREATE the new instance.
        Triggered by MetaLogger.__call__
        """
        print(f"  [Figure] __new__ called:")
        print(f"    cls    = {cls}")
        
        # Call the parent's __new__ (object.__new__)
        new_instance = super().__new__(cls)
        print(f"  [Figure] __new__ returning instance: {new_instance}")
        return new_instance

    def __init__(self, *args, **kwargs):
        """
        Called to INITIALIZE the new instance *after*
        it has been created by __new__.
        
        self: The new instance itself
        """
        print(f"  [Figure] __init__ called:")
        print(f"    self   = {self}")
        print(f"    *args  = {args}")
        print(f"    **kwargs = {kwargs}")
        
        # Call the parent's __init__ (object.__init__)
        super().__init__()
        print(f"  [Figure] __init__ finished.")


print("\n--- 'Figure' class has been defined by MetaLogger ---")


# 3. Main program to test instantiation
if __name__ == "__main__":
    print("\n--- Main block started: About to instantiate Figure() ---")
    
    # This call 'Figure()' is what triggers MetaLogger.__call__
    fig = Figure(10, 20, name="Test")
    
    print("\n--- Main block: Instantiation complete ---")
    print(f"Variable 'fig' holds: {fig}")
    print(f"Type of 'fig': {type(fig)}")
    print(f"Type of 'Figure' (the class): {type(Figure)}")
