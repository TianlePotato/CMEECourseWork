#!/usr/bin/env python3

"""returns the value of x,y,z
where y=x and decreases by 1 every loop
where z=x/y"""
def buggyfunc(x):
    y = x
    for i in range(x):
        try:
            y = y-1
            z = x/y
        except ZeroDivisionError:
            print(f"The result of dividing a number by zero is undefined")
        except:
            print(f"This didn't work;{x = }; {y = }")
        else:
            print(f"OK; {x = }; {y = }, {z = };")
    return z

buggyfunc(20)