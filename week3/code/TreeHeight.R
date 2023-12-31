# This function calculates heights of trees given distance of each tree 
# from its base and angle to its top, using  the trigonometric formula 
#
# height = distance * tan(radians)
#
# ARGUMENTS
# degrees:   The angle of elevation of tree
# distance:  The distance from base of tree (e.g., meters)
#
# OUTPUT
# The heights of the tree, same units as "distance"

TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180
    height <- distance * tan(radians)
    #print(paste("Tree height is:", height))
  
    return (height)
}

all_trees <- read.csv("../data/trees.csv")

all_trees$Tree.Height.m <- TreeHeight(all_trees$Angle.degrees, all_trees$Distance.m)

write.csv(all_trees, "../results/TreeHts.csv", row.names = F)