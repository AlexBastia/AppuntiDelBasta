# simpleScopingError.py
x = 1
y = 2
z = 3
w = 0
def testScope():
    global x
    y = 4
    z = 5 + w
   # global z
    #w = -1
if __name__ == "__main__":
    print("in main x =",x,", y =",y)
    print(dir())
