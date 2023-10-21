#!/usr/bin/env python3

"""Identifies the presence of oaks from a list of taxa"""

taxa = [ 'Quercus robur',
         'Fraxinus excelsior',
         'Pinus sylvestris',
         'Quercus cerris',
         'Quercus petraea',
       ]


def is_an_oak(name):
    """Returns TRUE if genus is quercus"""
    return name.lower().startswith('quercus ')

# Use for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

# Using list comprehensions
oaks_lc = set([species
               for species in taxa
               if is_an_oak(species)])
print(oaks_lc)

# UPPER CASE using loop
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species.upper())
print(oaks_loops)

# UPPER CASE using list comprehensions
oaks_lc = set([species.upper()
                  for species in taxa
                  if is_an_oak(species)])
print(oaks_lc)