# CMEE 2022 HPC exercises R code pro forma
# For neutral model cluster run

rm(list=ls()) # good practice 
source("ts920_HPC_2023_main.R")

# get iteration value
#iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
iter <- 1

set.seed(iter)

file_name <- paste("cluster_output_", as.character(iter), ".rda", sep = "")

wall_time = 11.5*60

if (iter < 26){
  neutral_cluster_run(interval_rich = 1, interval_oct = 500/10, 
                      burn_in_generations = 8*500, speciation_rate = 0.002902,
                      size = 500, wall_time = wall_time,
                      output_file_name = file_name)
  
} else if (25 < iter && iter < 51) {
  neutral_cluster_run(interval_rich = 1, interval_oct = 1000/10, 
                      burn_in_generations = 8*1000, speciation_rate = 0.002902,
                      size = 1000, wall_time = wall_time,
                      output_file_name = file_name)
  
} else if (50 < iter && iter < 76) {
  neutral_cluster_run(interval_rich = 1, interval_oct = 2500/10, 
                      burn_in_generations = 8*2500, speciation_rate = 0.002902,
                      size = 2500, wall_time = wall_time,
                      output_file_name = file_name)
  
} else {
  neutral_cluster_run(interval_rich = 1, interval_oct = 5000/10, 
                      burn_in_generations = 8*5000, speciation_rate = 0.002902,
                      size = 5000, wall_time = wall_time,
                      output_file_name = file_name)
}

rm(iter)