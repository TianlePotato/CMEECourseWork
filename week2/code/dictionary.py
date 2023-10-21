#!/usr/bin/env python3

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc

#### Your solution here #### 
taxa_dic = {}
    
for i in range(len(taxa)):
    value = taxa[i][0] # species
    key = taxa[i][1]   # order

    if key in taxa_dic.keys():
        taxa_dic[key] = taxa_dic[key] + ", " + value

    else:
        taxa_dic[key] = value

for key in taxa_dic:
    print(key, ":", taxa_dic[key])

# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  
 
#### Your solution here #### 
print({x[1]:[i[0] for i in taxa if i[1] == x[1]] for x in taxa})