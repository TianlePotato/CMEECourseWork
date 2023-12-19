################################################
# Loops vs List comprehensions
################################################

iters = 1000000

import timeit

from profileme import my_squares as my_squares_loops

from profileme2 import my_squares as my_squares_lc

################################################
# Loops vs join method
################################################

mystring = "my string"

from profileme import my_join as my_join_join

from profileme2 import my_join as my_join


import time
start = time.time()
my_squares_loops(iters)
print(f"my_squares_loops takes {time.time() - start} s to run.")

start = time.time()
my_squares_lc(iters)
print(f"my_squares_lc takes {time.time() - start} s to run.")