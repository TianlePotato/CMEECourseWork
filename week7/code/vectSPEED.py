# vect

import numpy as np

def loop_product(a,b):
    N = len(a)
    c = np.zeros(N)
    for i in range(N):
        c[i] = a[i] * b[i]
    return c

def vect_product(a,b):
    return np.multiply(a,b)


import timeit

array_lengths = [1, 100, 10000, 1000000, 10000000]
t_loop = []
t_vect = []

for N in array_lengths:
    print(f"\nSet {N=}")
    a = np.random.rand(N)
    b = np.random.rand(N)

    timer = timeit.repeat('loop_product(a, b)', globals=globals().copy(), number=3)
    t_loop.append(1000 * np.mean(timer))
    print(f"Loop method took {t_loop[-1]} ms on average.")

    timer = timeit.repeat('vect_product(a, b)', globals=globals().copy(), number=3)
    t_vect.append(1000 * np.mean(timer))
    print(f"vectorized method took {t_vect[-1]} ms on average.")


p.figure()
p.plot(array_lengths, t_loop, label="loop method")
p.plot(array_lengths, t_vect, label="vect method")
p.xlabel("Array length")
p.ylabel("Execution time (ms)")
p.legend()
p.show()