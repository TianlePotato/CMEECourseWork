#!/usr/bin/env python3

"""The functions in this script perform a variety of mathematical operations
on the inputs as requested"""

__author__ = 'Tianle (ts920@ic.ac.uk)'

## imports ##
import sys # module to interface our program with the operating system


def foo_1(x):
    """Finds the root 2 of input x"""
    return  f"The root of {x} is {x ** 0.5}"

def foo_2(x, y):
    """Compares the size of inputs x & y, returning whichever is larger"""
    if x > y:
        return f"x ({x}) is larger than y ({y})"
    return f"y ({y}) is larger than x ({x})"

def foo_3(x, y, z):
    """Compares the sizes of inputs x, y & z
    switching values of x-y if x is larger than y
    then switching values of y-z if y is larger than z"""
    x1 = x
    y1 = y
    z1 = z
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return f"x, y, z were = {x1,y1,z1}, they now are {x,y,z}"

def foo_4(x):
    """Returns the factorial of input x using a for loop"""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return f"The factorial of {x} is {result}"

def foo_5(x):
    """A recursive function that calculates the factorial of x"""
    if x == 1:
        return 1
    return x * foo_5(x-1)
    

def foo_6(x):
    """Calculate the factorial of x in a different way; no if statement involved"""
    inital_x = x
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return f"The factorial of {inital_x} is {facto}"

def main(argv):
    print(foo_1(16))
    print(foo_2(69,420))
    print(foo_2(6,1))
    print(foo_3(5,20,60))
    print(foo_3(55,20,6))
    print(foo_3(5,20,6))
    print(foo_4(5))
    print("The factorial of 1 is", foo_5(1))
    print("The factorial of 5 is", foo_5(5))
    print(foo_6(5))

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)