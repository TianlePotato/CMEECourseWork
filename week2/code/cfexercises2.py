#!/usr/bin/env python3

"""Functions that print x given various conditions"""

######################
"""prints 'hello' for values within the range that are fully divisable by 3"""
def hello_1(x):
    for j in range(x):
        if j % 3 == 0:
            print('hello' + str(j))
    print(' ')

hello_1(12)

######################
"""prints 'hello' for values with remainder 3 when divided by 4 or 5"""
def hello_2(x):
    for j in range(x):
        if j % 5 == 3:
            print('hello5 ' + str(j))
        elif j % 4 == 3:
            print('hello4 ' + str(j))
    print(' ')

hello_2(12)

######################
"""prints 'hello' for the number of values within the inputted range """
def hello_3(x, y):
    for i in range(x, y):
        print('hello')
    print(' ')

hello_3(3, 17)

######################
"""prints 'hello' for values until x is equal to 15"""
def hello_4(x):
    while x != 15:
        print('hello')
        x = x + 3
    print(' ')

hello_4(0)

######################
"""prints 'hello' for values depending on various conditions"""
def hello_5(x):
    while x < 100:
        if x == 31:
            for k in range(7):
                print('hello')
        elif x == 18:
            print('hello')
        x = x + 1
    print(' ')

hello_5(12)

######################
"""WHILE loop with BREAK,
prints 'hello' if x is TRUE and y is not 6"""
def hello_6(x, y):
    while x:
        print('hello! ' + str(y))
        y += 1
        if y == 6:
            break
        print(' ')

hello_6 (True, 0)
