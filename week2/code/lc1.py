#!/usr/bin/env python3

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

latin_comp = [birds[i][0] for i in range(len(birds))]

common_comp = [birds[i][1] for i in range(len(birds))]

mass_comp = [birds[i][2] for i in range(len(birds))]

print("Using list comprehensions, the output lists are:\nLatin names:\n", latin_comp,
       "\nCommon names:\n", common_comp, "\nMean body masses:\n", mass_comp, "\n")

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

latin_conv = []
for i in range(len(birds)):
    latin_conv.append(birds[i][0])

common_conv = []
for i in range(len(birds)):
    common_conv.append(birds[i][1])

mass_conv = []
for i in range(len(birds)):
    mass_conv.append(birds[i][2])

print("Using for loops, the output lists are:\nLatin names:\n", latin_conv,
       "\nCommon names:\n", common_conv, "\nMean body masses:\n", mass_conv)

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 