#!/usr/bin/env Rscript
# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list = ls())

stochrick <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100)
{
  
  N <- matrix(NA, numyears, length(p0))  #initialize empty matrix
  
  N[1, ] <- p0
  
  for (pop in 1:length(p0)) { #loop through the populations
    
    for (yr in 2:numyears){ #for each pop, loop through the years
      
      N[yr, pop] <- N[yr-1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma)) # add one fluctuation from normal distribution
      
    }
    
  }
  return(N)
  
}

# Now write another function called stochrickvect that vectorizes the above to
# the extent possible, with improved performance: 

stochrickvect <- function(p0 = runif(1000, .5, 1.5), r = 1.2, K = 1, sigma = 0.2,numyears = 100)
{
  
N <- matrix(NA, numyears, length(p0))  #initialize empty matrix
Random.Nums <- matrix(rnorm(99000, 0, sigma), 99, 1000)

N[1, ] <- p0

for (i in 2:100){
  
N[i,] <- N[i-1,] * exp(r * (1 - N[i-1,] / K) + Random.Nums[i-1,])
  
}
return(N)
}


print("Normal Stochastic Ricker takes:")
print(system.time(res2<-stochrick()))

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))