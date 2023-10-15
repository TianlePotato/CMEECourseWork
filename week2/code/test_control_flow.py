#!/usr/bin/env python3

"""Some functions exemplifying the use of control statements"""

__author__ = 'Tianle (ts920@ic.ac.uk)'
__version__ = '0.0.1'

## imports ##
import sys # module to interface our program with the operating system
import doctest

## constants ##


## functions ##
def even_or_odd(x=0):
    """Find whether a number x is even or odd
    
    >>> even_or_odd(10)
    '10 is Even!'

    >>> even_or_odd(55)
    '55 is Odd!'

    in case of negative numbers, the positive is taken:
    >>> even_or_odd(-69)
    '-69 is Odd!'
    
    """
    
    if x % 2 == 0:
        return f"{x} is Even!"
    return f"{x} is Odd!"

def main(argv):
    print(even_or_odd(22))
    print(even_or_odd(33))
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()