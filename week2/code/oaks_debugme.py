#!/usr/bin/env python3

"""Identifies the presence of oaks from a list"""

import csv
import sys
import doctest

#Define function
def is_an_oak(name):
    """ Returns True if name is starts with 'quercus' 
    
    >>> is_an_oak("quercusbruhmoment")
    False

    >>> is_an_oak("quercu")
    False

    >>> is_an_oak("quercus ")
    False
    """

    return name.lower() == "quercus"

def main(argv): 
    """Identifies and saves trees that are OAK"""
    f = open('../data/TestOaksData.csv','r',)
    g = open('../data/JustOaksData.csv','w')
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)
    oaks = set()
    next(taxa) #Ignores the header row
    for row in taxa:
        print(row)
        print ("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])    

    return 0
    
if (__name__ == "__main__"):
    status = main(sys.argv)

doctest.testmod()