#!/usr/bin/env python3

"""A script that tests the reading & writing of .csv files
This uses the file '../data/testcsv.csv'
and saves output in the file '../data/bodymass.csv'"""

import csv

with open("../data/testcsv.csv", "r") as f:

    csvread = csv.reader(f)
    temp = []
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print("The species is", row[0])

# write a file containing only species name and body mass
with open("../data/testcsv.csv", "r") as f:
    with open ("../data/bodymass.csv", "w") as g:

        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])