#!/usr/bin/env python3

"""Functions that find the best alignment between two DNA sequences"""
# Two example sequences to match
#seq2 = "ATCGCCGGATTACGGG"
#seq1 = "CAATTCGGAT"

###########################################################
"""Function to read in a file (path), which contains two sequences"""

def read_seq(path):
    with open(path, "r") as seq:
        seqs = ["",""]
        index = 0
        
        for line in seq:
            line = line.replace("\n", "")  # Removes \n if they exist
            line = line.replace(" ", "") # Removes spaces if they exist

            seqs[index] = line  # Saves sequences in a list temporarily
            index += 1

        seq1 = seqs[0]
        seq2 = seqs[1]    
            
        return seq1, seq2


###########################################################
"""Function that compares sequence lengths:
Returns the longer sequence as s1, and the shorter as s2
l1 is length of the longest, l2 that of the shortest"""

def compare_length(seq1, seq2):
    l1 = len(seq1)
    l2 = len(seq2)
    if l1 >= l2:
        s1 = seq1
        s2 = seq2
    else:
        s1 = seq2
        s2 = seq1
        l1, l2 = l2, l1 # swap the two lengths
    return s1, l1, s2, l2


###########################################################
"""A function that computes a score by returning the number of 
# matches starting from arbitrary startpoint (chosen by user)"""

def calculate_score(s1, s2, l1, l2, startpoint):
    matched = "" # to hold string displaying alignments
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]: # if the bases match
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # some formatted output
    print("." * startpoint + matched)           
    print("." * startpoint + s2)
    print(s1)
    print(score) 
    print(" ")

    return score



#############################################################################
# 4. Running the code

# now try to find the best match (highest score) for the two sequences
my_best_align = None
my_best_score = -1

a = read_seq("../data/sequences2.csv")
b = compare_length(a[0], a[1])

for i in range(b[1]): # Note that you just take the last alignment with the highest score
    z = calculate_score(b[0], b[2], b[1], b[3], i)
    if z > my_best_score:
        my_best_align = "." * i + b[2] # think about what this is doing!
        my_best_score = z 


print(my_best_align)
print(b[0])
print("Best score:", my_best_score)

# Write the best output into a file
with open ("../results/alignment_results.txt", "w") as file:
    file.write(my_best_align)
    file.write("\n")
    file.write(b[0])
    file.write("\n")
    file.write("Best score:")
    file.write(str(my_best_score))

print("\nResults saved in '../results/alignment_results.txt'")