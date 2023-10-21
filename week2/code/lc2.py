#!/usr/bin/env python3

# Average UK 
# Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.

more_than_100 = [rainfall[i] for i in range(len(rainfall)) if (rainfall[i][1] > 100)]

print("Done using list comprehension,\nMonths and rainfall values for those with greater than 100mm rainfall:\n",
      more_than_100, "\n")
 

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

less_than_50 = [rainfall[i][0] for i in range(len(rainfall)) if (rainfall[i][1] < 50)]

print("Done using list comprehension,\nMonths with less than 50mm rainfall:\n",
      less_than_50, "\n")


# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# 1 using for loop
loop_more_than_100 = []
for i in range(len(rainfall)):
    if rainfall[i][1] > 100:
        loop_more_than_100.append(rainfall[i])

print("Done using a for loop,\nMonths and rainfall values for those with greater than 100mm rainfall:\n",
      loop_more_than_100, "\n")

# 2 using for loop
loop_less_than_50 = []
for i in range(len(rainfall)):
    if rainfall[i][1] < 50:
        loop_less_than_50.append(rainfall[i][0])

print("Done using a for loop,\nMonths with less than 50mm rainfall:\n",
      loop_less_than_50, "\n")


# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

