# A simple file to test control flow tools in R

#####################################
# 1. Test if 'a' is TRUE
a <- TRUE
if (a == TRUE) {
    print("a is TRUE")
} else {
   print ("a is FALSE") 
}

#####################################
# 2. Test if the randomly generated 'z' is less than 0.5
z <- runif(1)
if (z <= 0.5) {
    print ("Less than a half")
}

#####################################
# 3. Calculate the square FOR all numbers within 1:10
for (i in 1:10) {
    j <- i * i
    print(paste(i, " square is", j))
}

#####################################
# 4. Print name FOR all species inputted
for (species in c('Heliodoxa rubinoides','Boissonneaua jardini','Sula nebouxii')) {
    print(paste('The species is', species))
}

#####################################
# 5. Print name FOR a pre-defined vector
v1 <- c("a","bc","def")
for (i in v1) {
    print(i)
}

#####################################
# 6. Keep looping until the condition (i<10) is met
i <- 0
while (i < 10) {
    i <- i+1
    print(i^2)
}
 