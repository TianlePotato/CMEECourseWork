# CMEE 2022 HPC exercises R code pro forma
# For stochastic demographic model cluster run

rm(list=ls()) # good practice 
source("ts920_HPC_2023_main.R")

# get iteration value
#iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
iter <- 1

set.seed(iter)

clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03) 

growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0, 
                          0.5, 0.4, 0.0, 0.0, 
                          0.0, 0.4, 0.7, 0.0, 
                          0.0, 0.0, 0.25, 0.4), 
                        nrow=4, ncol=4, byrow=T) 

reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6, 
                                0.0, 0.0, 0.0, 0.0, 
                                0.0, 0.0, 0.0, 0.0, 
                                0.0, 0.0, 0.0, 0.0), 
                              nrow=4, ncol=4, byrow=T) 

# In 100 iterations
# 25 iterations of each initial state condition
# 150 repeats of each initial state condition iteration
# 120 generation time points for each repeat

# Determine initial state condition based on iteration number
if (iter < 26){
  state <- state_initialise_adult(4,100)
  init_condition <- "big_adult"
  
} else if (25 < iter && iter < 51) {
  state <- state_initialise_adult(4,10)
  init_condition <- "small_adult"
  
} else if (50 < iter && iter < 76) {
  state <- state_initialise_spread(4,100)
  init_condition <- "big_spread"
  
} else {
  state <- state_initialise_spread(4,10)
  init_condition <- "small_spread"
  
}

# Set file name
file_name <- paste("stochastic_", init_condition,"_", as.character(iter), ".rda", sep = "")

# Loop 150 times and save
result_list <- rep(list(rep(0, times = 121)), times = 150)

for (i in 1:150){
  results <- stochastic_simulation(state, growth_matrix,reproduction_matrix,clutch_distribution, 120)
  result_list[[i]] <- results
}

save(result_list, file = file_name)

rm(iter)