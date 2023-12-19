# CMEE 2022 HPC exercises R code main pro forma
# You don't HAVE to use this but it will be very helpful.
# If you opt to write everything yourself from scratch please ensure you use
# EXACTLY the same function and parameter names and beware that you may lose
# marks if it doesn't work properly because of not using the pro-forma.

name <- "Tianle Shao"
preferred_name <- "Tianle"
email <- "ts920@imperial.ac.uk"
username <- "ts920"

# Please remember *not* to clear the workspace here, or anywhere in this file.
# If you do, it'll wipe out your username information that you entered just
# above, and when you use this file as a 'toolbox' as intended it'll also wipe
# away everything you're doing outside of the toolbox.  For example, it would
# wipe away any automarking code that may be running and that would be annoying!

# Question 1
species_richness <- function(community){
  return(length(unique(community)))
}

# Question 2
init_community_max <- function(size){
  return(seq(size))
}

# Question 3
init_community_min <- function(size){
  return(rep(1, size))
}

# Question 4
choose_two <- function(max_value){
  return(sample(seq(max_value), 2, replace = FALSE))
}

# Question 5
neutral_step <- function(community){
  two_numbers <- choose_two(length(community))
  community[two_numbers[1]] <- community[two_numbers[2]]
  return(community)
}

# Question 6
neutral_generation <- function(community){
  generation <- round(jitter(length(community)/2))
  
  for (i in seq(generation)){
    community <- neutral_step(community)
  }
  
  return(community)
}

# Question 7
neutral_time_series <- function(community,duration)  {
  generation_richness <- as.vector(species_richness(community))
  
  for (i in seq(duration)){
    community <- neutral_generation(community)
    generation_richness <- append(generation_richness, species_richness(community))
  }
  return(generation_richness)
}

# Question 8
question_8 <- function() {
  
  png(filename="question_8.png", width = 600, height = 400)
  # plot your graph here
  data <- data.frame(neutral_time_series(seq(100), 200), seq(201))
  colnames(data) <- c("Species_Richness", "Time")
  
  plot(x=data$Time, y=data$Species_Richness, type="l", xlab="Time", ylab="Species Richness")
  
  Sys.sleep(0.1)
  dev.off()
  
  return("The system will always converge on population richness of 1, as species will constantly be replaced by others, and there is no way for more species to be created.")
}

# Question 9
neutral_step_speciation <- function(community,speciation_rate)  {
  random_num <- runif(1, 0, 1)
  two_numbers <- choose_two(length(community))
  
  if (random_num > speciation_rate){
    community[two_numbers[1]] <- community[two_numbers[2]] # Normal
  } else {
    community[two_numbers[1]] <- max(community)+1 # Speciation
  }
  return(community)
}

# Question 10
neutral_generation_speciation <- function(community,speciation_rate)  {
  generation <- round(jitter(length(community)/2))
  
  for (i in seq(generation)){
    community <- neutral_step_speciation(community, speciation_rate)
  }
  
  return(community)
}

# Question 11
neutral_time_series_speciation <- function(community,speciation_rate,duration)  {
  generation_richness <- as.vector(species_richness(community))
  
  for (i in seq(duration)){
    community <- neutral_generation_speciation(community, speciation_rate)
    generation_richness <- append(generation_richness, species_richness(community))
  }
  return(generation_richness)
}

# Question 12
question_12 <- function()  {
  
  png(filename="question_12.png", width = 600, height = 400)
  # plot your graph here
  data <- data.frame(neutral_time_series_speciation(init_community_max(100), 0.1, 200), 
                     neutral_time_series_speciation(init_community_min(100), 0.1, 200), 
                     seq(201))
  colnames(data) <- c("Max_rich", "Min_rich", "Time")
  plot(x=data$Time, y=data$Max_rich, type="l", col = "red", xlab="Time", ylab="Species Richness", ylim = c(0,100))
  lines(x=data$Time, y=data$Min_rich, col = "blue")
  legend(170,100,c("Max Starting Richness", "Min Starting Richness"), lwd=c(2,2), col = c("red", "blue"))
  
  dev.off()
  
  return("A speciation rate >0 means the species richness doesn't coverge at 1, instead fluctuating at a point depending on the speciation rate. The minimum and maximum richness starts do not matter as all runs converge after a given burn in time. The speciation rate reaches an equilibrium with the rate in which species go extinct and are replaced.")
}

# Question 13
species_abundance <- function(community)  {
  return(sort(as.vector(table(community)), decreasing = T))
}

# Question 14
octaves <- function(abundance_vector) {

  logged_av <- floor(log2(abundance_vector))+1
  octave <- tabulate(logged_av)
  
  return(octave)
}

# Question 15
sum_vect <- function(x, y) {
  # Determine which vector is long and which is short
  if(length(x) < length(y)){
    short <- x
    long <- y
  } else {
    short <- y
    long <- x
  }
  
  # Append zeros to the end of the shorter vector to make it as long as the long vector 
  added_zeros <- rep(0, (length(long)-length(short)))
  short <- c(short, added_zeros)
  return(short + long)
}

# Question 16 
question_16 <- function() {
  # Initiate starting communities, and storage vectors
  community_from_max <- init_community_max(100)
  avg_octaves_max <- vector()
  community_from_min <- init_community_min(100)
  avg_octaves_min <- vector()
  
  # Identify repeats to add to storage vector
  gens_to_plot <- seq(200,2200,by=20)
  
  # Loop through all 200 burn-ins and 2000 reps
  for (gen in 1:2200){
    
    community_from_max <- neutral_generation_speciation(community_from_max, 0.1)
    community_from_min <- neutral_generation_speciation(community_from_min, 0.1)
    
    if (gen %in% gens_to_plot){
      gen.octaves <- octaves(species_abundance(community_from_max))
      avg_octaves_max <- sum_vect(avg_octaves_max, gen.octaves)
      
      gen.octaves <- octaves(species_abundance(community_from_min))
      avg_octaves_min <- sum_vect(avg_octaves_min, gen.octaves)
    } else {
      next
    }
  }
  
  avg_octaves_max <- avg_octaves_max/101
  avg_octaves_min <- avg_octaves_min/101
  
  barnames <- as.vector("1")
  for (n in 2:(length(avg_octaves_max))-1) {
    name <- paste(as.character(2^(n)), "-", as.character(2^(n+1)-1))
    barnames <- append(barnames, name)
  }
  
  avg_octaves_max <- data.frame(avg_octaves_max, barnames)
  avg_octaves_min <- data.frame(avg_octaves_min, barnames)
  
  png(filename="question_16_min.png", width = 600, height = 400)
  # plot your graph here
  barplot(height = avg_octaves_max$avg_octaves_max, names.arg = avg_octaves_max$barnames, 
          ylim = c(0,ceiling(max(avg_octaves_max$avg_octaves_max))), 
          xlab = "Species abundances", ylab = "Avg number of species with abundance",
          col = "#ff8585", border = NA)
  
  Sys.sleep(0.1)
  dev.off()
  
  png(filename="question_16_max.png", width = 600, height = 400)
  # plot your graph here
  barplot(height = avg_octaves_min$avg_octaves_min, names.arg = avg_octaves_min$barnames, 
          ylim = c(0,ceiling(max(avg_octaves_min$avg_octaves_min))), 
          xlab = "Species abundances", ylab = "Avg number of species with abundance",
          col = "#858fff", border = NA)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("Initial conditions do not matter as all abundances converge at a stable equilibrium of species abundances across octaves. ")
}

# Question 17
neutral_cluster_run <- function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations, output_file_name) {
      
    ########### SET UP ###################
      # Initial Community
    community <- init_community_min(size)
      # Convert input minutes to seconds
    total_run_time <- wall_time * 60 
      # Record starting time of loop
    start_time <- proc.time()
    elapsed_time <- proc.time() - start_time
      # keeps track of number of elapsed generations
    generations <- 0
      # keeps track of species richness in burn-in period
    time_series <- vector()
      # keeps track of species abundances
    abundance_list <- list()
    
    ############ MAIN LOOP ################
    # Keep looping until the time runs out
    while(elapsed_time["elapsed"] < total_run_time){
      elapsed_time <- proc.time() - start_time
      generations <- generations + 1
      
      if (generations <= burn_in_generations){
        # Calculates richness at set intervals during burn-in
        community <- neutral_generation_speciation(community, speciation_rate)
        if (generations %% interval_rich == 0){
          time_series <- append(time_series, species_richness(community))
        }
      } else {
        # Calculates abundances at set intervals after burn-in
        community <- neutral_generation_speciation(community, speciation_rate)
        if (generations %% interval_oct == 0){
          gen.octaves <- octaves(species_abundance(community))
          abundance_list <- c(abundance_list, list(gen.octaves))
        }
      } # Main If loop
    } # While loop
    
    ########### SAVING #############
    save(time_series, abundance_list, total_run_time,
         speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_generations,
         file = output_file_name)
    
} # Function loop

# Questions 18 and 19 involve writing code elsewhere to run your simulations on
# the cluster

# Question 20 
process_neutral_cluster_results <- function() {
  
  # Initialise storage frames
  rep500 <- 0
  rep1000 <- 0
  rep2500 <- 0
  rep5000 <- 0
  
  # Keep track of lengths of all files
  abun_lengths <- c(0,0,0,0)
  
  # vector of all file names
  files <- list.files("output_files", pattern = "\\.rda$", full.names = TRUE)
  
  #################### MAIN LOOP ######################################
  for (file in files) {
    
    # Read in file
    load(file)
      
    # Add the row to the previous values, accounting for different vector lengths
    if (grepl(".*_500_.*\\.rda$", file)) {
      # Record length of file
      abun_lengths[1] <- abun_lengths[1] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep500 <- sum_vect(rep500, abundance_list[[i]])
      }
      
    } else if (grepl(".*_1000_.*\\.rda$", file)) {
      abun_lengths[2] <- abun_lengths[2] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep1000 <- sum_vect(rep1000, abundance_list[[i]])
      }      
      
    } else if (grepl(".*_2500_.*\\.rda$", file)) {
      abun_lengths[3] <- abun_lengths[3] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep2500 <- sum_vect(rep2500, abundance_list[[i]])
      }      
      
    } else if (grepl(".*_5000_.*\\.rda$", file)) {
      abun_lengths[4] <- abun_lengths[4] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep5000 <- sum_vect(rep5000, abundance_list[[i]])
      }      
    }
  }
    
  # Find means
  rep500 <- rep500/abun_lengths[1]
  rep1000 <- rep1000/abun_lengths[2]
  rep2500 <- rep2500/abun_lengths[3]
  rep5000 <- rep5000/abun_lengths[4]
  
  combined_results <- list(rep500, rep1000, rep2500, rep5000) #create your list output here to return
  
  # save results to an .rda file
  save(combined_results, file = "question_20_results.rda")
}

plot_neutral_cluster_results <- function(){

  # load combined_results from your rda file
  load("question_20_results.rda")
  
  pop_sizes <- c("500", "1000", "2500", "5000")

  png(filename="plot_neutral_cluster_results.png", width = 600, height = 400)
  # plot your graph here
  par(mfrow = c(2,2))
  for (i in 1:length(combined_results)){
    
    barnames <- as.vector("1")
    for (n in 2:(length(combined_results[[i]]))-1) {
      name <- paste(as.character(2^(n)), "-", as.character(2^(n+1)-1), sep = "")
      barnames <- append(barnames, name)
    }
    
    barplot(height = combined_results[[i]], names.arg = barnames, 
            ylim = c(0,ceiling(max(combined_results[[i]]))), 
            xlab = "Species abundance octaves", ylab = "Avg number of species with abundance",
            col = "#858fff", border = NA, main = paste("Population size", pop_sizes[i]))
  }
  
  Sys.sleep(0.1)
  dev.off()
  
  return(combined_results)
}


# Question 21
state_initialise_adult <- function(num_stages,initial_size){
  initial_state <- rep(0, num_stages)
  initial_state[length(initial_state)] <- initial_size
  return(initial_state)
}

# Question 22
state_initialise_spread <- function(num_stages,initial_size){
  even_pop <- floor(initial_size/num_stages)
  initial_state <- rep(even_pop, num_stages)
  
  # if initial size cannot be divided by num_stages, save remainder into lowest stages
  if (initial_size%%num_stages != 0){
    leftovers <- initial_size%%num_stages
    initial_state[1:leftovers] <- initial_state[1:leftovers] + 1
  }
  
  return(initial_state)
}

# Question 23
deterministic_step <- function(state,projection_matrix){
  # Matrix multiplication
  new_state <- projection_matrix %*% state
  return(new_state)
}

# Question 24
deterministic_simulation <- function(initial_state,projection_matrix,simulation_length){
  state <- initial_state
  population_size <- sum(state)

  for (i in 1:simulation_length){
    state <- deterministic_step(state, projection_matrix)
    population_size <- c(population_size, sum(state))
  }
  
  return(population_size)
}

# Question 25
question_25 <- function(){
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
  
  projection_matrix = reproduction_matrix + growth_matrix
  
  state_spread <- state_initialise_spread(4,100)
  state_adult <- state_initialise_adult(4,100)
  
  results_spread <- deterministic_simulation(state_spread, projection_matrix, 24)
  results_adult <- deterministic_simulation(state_adult, projection_matrix, 24)
  
  png(filename="question_25.png", width = 600, height = 400)
  # plot your graph here
  plot(results_adult, type = "l", col = "red", xlab = "Time point", ylab = "Abundance", ylim = c(0,500))
  lines(results_spread, col = "blue")
  legend("bottomright", c("Adults only", "Even spread"), lwd=c(2,2), col = c("red", "blue"), box.col = "transparent", bg = "transparent")
  
  Sys.sleep(0.1)
  dev.off()
  
  return("Starting with only adults in the population results in greater population overall, as adults immediately produce a large number of offspring, resulting in a large population at time step 2. In contrast, having a spread initial population means fewer adults are able to reproduce immediately to gain a larger population, and more immature individuals need to survive before being able to reproduce. The survival process would on average result in fewer individuals due to the death rate present.")
}

# Question 26, for each life-stage in state, calculate how many stay, grow or die
multinomial <- function(pool,probs) {
  # Where pool = an integer of number of individuals
  # prob = e.g. (0.3, 0.5, 0.2), where 0.3 is stay, 0.5 is grow, 0.2 is death
  
  if (sum(probs) < 1){ # If death is possible
    death_rate <- 1-sum(probs)
    probs <- c(probs, death_rate) # Include death
    counts <- rmultinom(n = 1,size = pool,prob = probs)
    
    return(counts[-length(counts)]) # Outputs new life-stage without deaths
    
  } else { # if death isn't possible
    counts <- rmultinom(n = 1,size = pool,prob = probs)
    
    return(counts) # Outputs new life-stage
  }
}

# Question 27, Calculates the new state after growth and death. NOT reproduction.
# Includes Q26 multinomial(pool, probs)
survival_maturation <- function(state,growth_matrix) {

  # 1. Initiate empty matrix
  new_matrix <- matrix(rep(0, length(growth_matrix)), 
                       nrow = nrow(growth_matrix), ncol = ncol(growth_matrix))
  
  # 2. For loop to calculate fate of each life-stage in "state"
  for (i in 1:(length(state))){
    # Find the results of each column
    column_results <- multinomial(state[i], growth_matrix[,i])
    # And then add the new column to the empty matrix
    new_matrix[,i] <- column_results
  }
  
  # 3. Calculate rows from the new matrix to get new state
  new_state <- rowSums(new_matrix)
  return(new_state)
}

# Question 28, outputs the n'th element of a probability distribution, given its probability
random_draw <- function(probability_distribution) {
  draw <- sample(length(probability_distribution), 1, prob = probability_distribution)
  return(draw)
}

# Question 29, Calculates probability of an adult recruiting
stochastic_recruitment <- function(reproduction_matrix,clutch_distribution){
  
  # 1. Get the reproduction value from the top right of the reproduction matrix
  recruitment_prob <- reproduction_matrix[1, length(reproduction_matrix[1,])]
  
  # 2. Get the mean number of offspring for any given clutch
  nums <- 1:length(clutch_distribution)
  mean_clutch <- sum(nums * clutch_distribution)
  
  # 3. Divide to get the recruitment probability
  result <- recruitment_prob/mean_clutch
  return(result)
}

# Question 30, Calculates total offspring produced
# Includes Q28 random_draw
offspring_calc <- function(state,clutch_distribution,recruitment_probability){
  
  # Find number of adults in state
  num_adults <- state[length(state)]
  
  # Use binomial to find how many of those adults reproduce
  vec_clutches <- rbinom(n = num_adults, size = 1, prob = recruitment_probability)
  num_clutches <- sum(vec_clutches == 1)
  
  total_clutch_size <- as.vector(0)
  
  # Don't run if no reproducing adults
  if (num_clutches != 0){
    for (i in 1:num_clutches){
      # For each reproducing adult, add a random clutch size to total clutch
      total_clutch_size <- c(total_clutch_size, random_draw(clutch_distribution))
    }
  }
  
  # Sum up all offspring
  total_offspring <- sum(total_clutch_size)
  return(total_offspring)
}

# Question 31, Calculates new state, and adds new offspring to new state
stochastic_step <- function(state,growth_matrix,reproduction_matrix,clutch_distribution,recruitment_probability){
  # single time step of survival/maturation
  new_state <- survival_maturation(state, growth_matrix)
  # single time step of offspring
  new_offspring <- offspring_calc(state, clutch_distribution, recruitment_probability)
  # add offspring to state after survival/mautration
  new_state[1] <- new_state[1] + new_offspring
  return(new_state)
}

# Question 32
stochastic_simulation <- function(initial_state,growth_matrix,reproduction_matrix,clutch_distribution,simulation_length){
  # Calculate reproduction probability
  repro_prob <- stochastic_recruitment(reproduction_matrix, clutch_distribution)
  
  state <- initial_state
  
  # Vector to save population sizes for all time points of simulation_length
  population_size <- rep(0, simulation_length + 1)
  population_size[1] <- sum(state)
  
  # Run simulation the amount of times defined by simulation_length
  for (i in 1:simulation_length){
    state <- stochastic_step(state, growth_matrix, reproduction_matrix, clutch_distribution, repro_prob)

    population_size[i+1] <- sum(state)
    
    # If population goes extinct, exit the loop - all remaining time points are 0
    if (sum(state) == 0){
      break
    }
  }
  
  return(population_size)
}

# Question 33
question_33 <- function(){
  
  # Matricies
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
  
  # Initialise populations
  state_spread <- state_initialise_spread(4,100)
  state_adult <- state_initialise_adult(4,100)
  
  # Simulating stochastic for 24 time points
  results_spread <- stochastic_simulation(state_spread, growth_matrix,reproduction_matrix,clutch_distribution, 24)
  results_adult <- stochastic_simulation(state_adult, growth_matrix,reproduction_matrix,clutch_distribution, 24)
  
  png(filename="question_33.png", width = 600, height = 400)
  # plot your graph here
  plot(results_adult, type = "l", col = "red", xlab = "Time point", ylab = "Abundance", ylim = c(0,max(results_adult)))
  lines(results_spread, col = "blue")
  legend("bottomright", c("Adults only", "Even spread"), lwd=c(2,2), col = c("red", "blue"), box.col = "transparent", bg = "transparent", lty = 1)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("Deterministic models are smoother than the stochastic ones, as they are guaranteed a set proportion of growth and death each new generation. Stochastic models however vary in growth and death rates, due to random probabilities, and would likely result in a less smooth graph.")
}

# Questions 34 and 35 involve writing code elsewhere to run your simulations on the cluster

# Question 36
question_36 <- function(){
  
  # Initialising results lists
  big_adult <- list()
  small_adult <- list()
  big_spread <- list()
  small_spread <- list()
  
  # Input files
  files <- list.files("output_stochastic", pattern = "\\.rda$", full.names = TRUE)
  
  # Main loop
  for (file in files) {
    
    load(file)
    
    # Saving based on condition met
    if (grepl(".*big_adult.*\\.rda$", file)) {
      big_adult <- c(big_adult, result_list)
      
    } else if (grepl(".*small_adult.*\\.rda$", file)) {
      small_adult <- c(small_adult, result_list)
      
    } else if (grepl(".*big_spread.*\\.rda$", file)) {
      big_spread <- c(big_spread, result_list)
      
    } else if (grepl(".*small_spread.*\\.rda$", file)) {
      small_spread <- c(small_spread, result_list)
      
    }
  }
  
  # Calculating extinction percentage by finding number of zeros for each list, and dividing by total number of repeats
  extinction_count <- c(sum(sapply(big_adult, function(x) tail(x, 1) == 0))/3750*100,
                        sum(sapply(small_adult, function(x) tail(x, 1) == 0))/3750*100,
                        sum(sapply(big_spread, function(x) tail(x, 1) == 0))/3750*100,
                        sum(sapply(small_spread, function(x) tail(x, 1) == 0))/3750*100)
  
  png(filename="question_36.png", width = 600, height = 400)

  # plot your graph here
  barplot(height = extinction_count, names.arg = c("Adults \nlarge population", "Adults \nsmall population", "Even spread \nlarge population", "Even spread \nsmall population"), 
          ylim = c(0,20), 
          xlab = "Initial population state", ylab = "Percentage extinction rate",
          
          col = "#858fff", border = NA)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("The small, spread population was most likely to go extinct. The small initial population meant that it was the most vulnerable to stochastic fluctuations, with the death of any single individual accounting for a greater proportion of the entire population. (e.g. 1 death would be 10% of individuals for a population of 10, whilst only 1% of individuals for a population of 100). The spread population meant that only 25 adults were present at the initial time step, and that fewer offspring were created in the immediate next timestep, compared to the starts where only adults are present. Ultimately, the small, spread start has on average the lowest population at all time steps, and is most likely to go extinct.")
}

# Question 37
question_37 <- function(){
  ########## DETERMINISTIC ##############################
  # Matricies
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
  
  projection_matrix = reproduction_matrix + growth_matrix
  
  # Initialising populations
  state_spread_big <- state_initialise_spread(4,100)
  state_spread_small <- state_initialise_spread(4,10)
  
  # Simulations running 120 time steps
  results_spread_big <- deterministic_simulation(state_spread_big, projection_matrix, 120)
  results_spread_small <- deterministic_simulation(state_spread_small, projection_matrix, 120)
  
  ################ STOCHASTIC ##############################
  # Results lists
  big_spread <- list()
  small_spread <- list()
  
  # Load in file
  files <- list.files("output_stochastic", pattern = "\\.rda$", full.names = TRUE)
  
  # MAIN LOOP for reading in files
  for (file in files) {
    
    load(file)
    
    # Saving into different lists accordingly
    if (grepl(".*big_spread.*\\.rda$", file)) {
      big_spread <- c(big_spread, result_list)
      
    } else if (grepl(".*small_spread.*\\.rda$", file)) {
      small_spread <- c(small_spread, result_list)
      
    }
  }
  
  # Make into data frame to average rows 
  big_matrix <- as.data.frame(big_spread)
  small_matrix <- as.data.frame(small_spread)
  
  # Averaging
  avg_big <- rowMeans(big_matrix)
  avg_small <- rowMeans(small_matrix)
  
  ###################### CALCULATIONS ####################
  deviation_big <- avg_big/results_spread_big
  deviation_small <- avg_small/results_spread_small
  
  ###################### PLOTS ###########################

  png(filename="question_37.png", width = 600, height = 400)
  # plot your graph for the small initial population size here
  plot(deviation_big, type = "l", col = "red", xlab = "Time point", ylab = "Deviation of stochastic model from deterministic model", ylim = c(min(deviation_big),max(deviation_small)), lwd = 2)
  lines(rep(1,121), col = "#595959", lty = 2, lwd = 2)
  lines(deviation_small, col = "blue", lwd = 2)
  legend("topleft", c("Large population", "Small population"), lwd=c(2,2), col = c("red", "blue"), box.col = "transparent", bg = "transparent", lty = 1)
  
  Sys.sleep(0.1)
  dev.off()

  return("Large populations are better approximated by the deterministic model, as larger populations are more resistant to stochastic fluctuations, and events such as extinction by chance. The stochastic simulations of large populations therefore converge on the deterministic model more so than smaller populations, with the convergence of a stochastic model on the deterministic model becoming even more apparent as the stochastic population increases towards infinity.")
}


# Challenge questions - these are optional, substantially harder, and a maximum
# of 14% is available for doing them. 

# Challenge question A
Challenge_A <- function() {
  
  # Initial 
  avg_richness_max <- matrix(nrow = 100, ncol = 100)
  avg_richness_min <- matrix(nrow = 100, ncol = 100)
  
  for (i in 1:100){
    print(i)
    community_from_max <- init_community_max(100)
    richness_from_max <- rep(0, 100)
    richness_from_max[1] <- 100
    community_from_min <- init_community_min(100)
    richness_from_min <- rep(0, 100)
    richness_from_min[1] <- 1
    
    # Loop through 100 reps
    for (gen in 2:100){
      
      community_from_max <- neutral_generation_speciation(community_from_max, 0.1)
      community_from_min <- neutral_generation_speciation(community_from_min, 0.1)
      
      richness_from_max[gen] <- length(unique(community_from_max))
      richness_from_min[gen] <- length(unique(community_from_min))
      
    }
    
    avg_richness_max[i,] <- richness_from_max
    avg_richness_min[i,] <- richness_from_min
  }
  
  ############# Confidence intervals ###################
  # Empty matrix to store results
  avg_richness_max_CI_upper <- rep(0, 100)
  avg_richness_max_CI_lower <- rep(0, 100)
  avg_richness_min_CI_upper <- rep(0, 100)
  avg_richness_min_CI_lower <- rep(0, 100)
  
  
  for (i in 1:100){
    input <- avg_richness_max[,i]
    
    sample.mean <- mean(input)
    sample.se <- (sd(input))/sqrt(length(input))
    t.score <- qt(p=0.028/2, df=(length(input)-1), lower.tail = FALSE)
    margin.error <- t.score * sample.se
    avg_richness_max_CI_lower[i] <- sample.mean - margin.error
    avg_richness_max_CI_upper[i] <- sample.mean + margin.error
    
    input <- avg_richness_min[,i]
    
    sample.mean <- mean(input)
    sample.se <- (sd(input))/sqrt(length(input))
    t.score <- qt(p=0.028/2, df=(length(input)-1), lower.tail = FALSE)
    margin.error <- t.score * sample.se
    avg_richness_min_CI_lower[i] <- sample.mean - margin.error
    avg_richness_min_CI_upper[i] <- sample.mean + margin.error
  }
  
  
  ####################### DATA 
  avg_richness_max <- colMeans(avg_richness_max)
  avg_richness_min <- colMeans(avg_richness_min)
  
  richness_frame <- data.frame(c(avg_richness_max, avg_richness_min), 
                               rep(1:100, 2), 
                               rep(c("Max richness", "Min richness"), each = 100), 
                               c(avg_richness_max_CI_lower, avg_richness_min_CI_lower), 
                               c(avg_richness_max_CI_upper, avg_richness_min_CI_upper))
  colnames(richness_frame) <- c("Richness", "Time_Point", "Starting_Condition", "CI_low", "CI_up")
  
  
  png("Challenge_A.png", width = 600, height = 400)
  plot(x = richness_frame$Time_Point[1:100], y = richness_frame$Richness[1:100], type = "l", col = "red", xlab = "Time point", ylab = "Species richness", ylim = c(0,100), lwd = 2)
  lines(x = richness_frame$Time_Point[101:200], y = richness_frame$Richness[101:200], col = "blue", lwd = 2)
  lines(x = richness_frame$Time_Point[1:100], y = richness_frame$CI_low[1:100], col = "red", lty = 2)
  lines(x = richness_frame$Time_Point[1:100], y = richness_frame$CI_up[1:100], col = "red", lty = 2)
  lines(x = richness_frame$Time_Point[101:200], y = richness_frame$CI_low[101:200], col = "blue", lty = 2)
  lines(x = richness_frame$Time_Point[101:200], y = richness_frame$CI_up[101:200], col = "blue", lty = 2)
  legend("topright", c("Max", "Min"), lwd=c(2,2), col = c("red", "blue"), box.col = "transparent", bg = "transparent", lty = 1, title = "Initial richness")

  
  Sys.sleep(0.1)
  dev.off()
  
  return("Around 50 generations are required for the system to reach dynamic equilibrium")
}

# Challenge question B
Challenge_B <- function() {
  
  avg_richness_max <- rep(0, 100)
  avg_richness_75 <- rep(0, 100)
  avg_richness_50 <- rep(0, 100)
  avg_richness_25 <- rep(0, 100)
  avg_richness_min <- rep(0, 100)
  
  for (i in 1:100){
    print(i)
    community_from_max <- init_community_max(100)
    richness_from_max <- rep(0, 100)
    richness_from_max[1] <- 100
    
    community_from_75 <- c(sample(1:75, 25, replace = TRUE), 1:75)
    richness_from_75 <- rep(0, 100)
    richness_from_75[1] <- 75
    
    community_from_50 <- c(sample(1:50, 50, replace = TRUE), 1:50)
    richness_from_50 <- rep(0, 100)
    richness_from_50[1] <- 50
    
    community_from_25 <- c(sample(1:25, 75, replace = TRUE), 1:25)
    richness_from_25 <- rep(0, 100)
    richness_from_25[1] <- 25
    
    community_from_min <- init_community_min(100)
    richness_from_min <- rep(0, 100)
    richness_from_min[1] <- 1
    
    # Loop through 1000 reps
    for (gen in 2:100){
      
      community_from_max <- neutral_generation_speciation(community_from_max, 0.1)
      community_from_75 <- neutral_generation_speciation(community_from_75, 0.1)
      community_from_50 <- neutral_generation_speciation(community_from_50, 0.1)
      community_from_25 <- neutral_generation_speciation(community_from_25, 0.1)
      community_from_min <- neutral_generation_speciation(community_from_min, 0.1)
      
      richness_from_max[gen] <- length(unique(community_from_max))
      richness_from_75[gen] <- length(unique(community_from_75))
      richness_from_50[gen] <- length(unique(community_from_50))
      richness_from_25[gen] <- length(unique(community_from_25))
      richness_from_min[gen] <- length(unique(community_from_min))
      
    }
    
    avg_richness_max <- avg_richness_max + richness_from_max
    avg_richness_75 <- avg_richness_75 + richness_from_75
    avg_richness_50 <- avg_richness_50 + richness_from_50
    avg_richness_25 <- avg_richness_25 + richness_from_25
    avg_richness_min <- avg_richness_min + richness_from_min
  }
  
  avg_richness_max <- avg_richness_max / 100
  avg_richness_75 <- avg_richness_75 / 100
  avg_richness_50 <- avg_richness_50 / 100
  avg_richness_25 <- avg_richness_25 / 100
  avg_richness_min <- avg_richness_min / 100
  
  
  png(filename="Challenge_B.png", width = 600, height = 400)
  # plot your graph here
  plot(avg_richness_max, type = "l", col = "red", xlab = "Time point", ylab = "Species richness", ylim = c(0,100))
  lines(avg_richness_75, col = "orange")
  lines(avg_richness_50, col = "yellow")
  lines(avg_richness_25, col = "green")
  lines(avg_richness_min, col = "blue")
  legend("topright", c("100", "75", "50", "25", "1"), lwd=c(2,2), col = c("red", "orange", "yellow", "green", "blue"), box.col = "transparent", bg = "transparent", lty = 1, title = "Initial richness")
  
  Sys.sleep(0.1)
  dev.off()

}

# Challenge question C
# Mean species richness against simulation generation
Challenge_C <- function() {
  rep500 <- matrix(nrow = 25, ncol = 4000)
  rep1000 <- matrix(nrow = 25, ncol = 4000)
  rep2500 <- matrix(nrow = 25, ncol = 4000)
  rep5000 <- matrix(nrow = 25, ncol = 4000)
  
  rep_num <- c(1,1,1,1)
  
  # vector of all file names
  files <- list.files("output_files", pattern = "\\.rda$", full.names = TRUE)
  
  #################### MAIN LOOP ######################################
  for (file in files) {
    
    # Read in file
    load(file)
    
    # Add the row to the previous values, accounting for different vector lengths
    if (grepl(".*_500_.*\\.rda$", file)) {
      
      rep500[rep_num[1],] <- time_series
      rep_num[1] = rep_num[1] + 1
      
    } else if (grepl(".*_1000_.*\\.rda$", file)) {
      
      rep1000[rep_num[2],] <- time_series[1:4000]
      rep_num[2] = rep_num[2] + 1
      
    } else if (grepl(".*_2500_.*\\.rda$", file)) {
      
      rep2500[rep_num[3],] <- time_series[1:4000]
      rep_num[3] = rep_num[3] + 1
      
    } else if (grepl(".*_5000_.*\\.rda$", file)) {
      
      rep5000[rep_num[4],] <- time_series[1:4000]
      rep_num[4] = rep_num[4] + 1
      
    }      
  }
  
  mean500 <- colMeans(rep500)
  mean1000 <- colMeans(rep1000)
  mean2500 <- colMeans(rep2500)
  mean5000 <- colMeans(rep5000)
  
  plateau_lines <- c(mean(mean500[1000:4000]), mean(mean1000[1000:4000]), mean(mean2500[1000:4000]), mean(mean5000[1000:4000]))
  plateau_times <- c(which(mean500 > plateau_lines[1])[1], which(mean1000 > plateau_lines[2])[1], which(mean2500 > plateau_lines[3])[1], which(mean5000 > plateau_lines[4])[1])
  
  png(filename="Challenge_C.png", width = 600, height = 400)
  # plot your graph here
  plot(mean5000, type = "l", col = "red", xlab = "Time point", ylab = "Mean species richness", ylim = c(0, 100))
  lines(mean500, col = "purple")
  lines(mean1000, col = "blue")
  lines(mean2500, col = "orange")
  lines(rep(plateau_lines[1], 4000), col= "purple", lty = 2)
  lines(x = rep(plateau_times[1], 2), y=c(0,plateau_lines[1]), col= "purple", lty = 2)
  lines(rep(plateau_lines[2], 4000), col= "blue", lty = 2)
  lines(x = rep(plateau_times[2], 2), y=c(0,plateau_lines[2]), col= "blue", lty = 2)
  lines(rep(plateau_lines[3], 4000), col= "orange", lty = 2)
  lines(x = rep(plateau_times[3], 2), y=c(0,plateau_lines[3]), col= "orange", lty = 2)
  lines(rep(plateau_lines[4], 4000), col= "red", lty = 2)
  lines(x = rep(plateau_times[4], 2), y=c(0,plateau_lines[4]), col= "red", lty = 2)
  legend("bottomright", title = "Community size", c("500", "1000", "2500", "5000"), lwd=c(2,2,2,2), col = c("purple", "blue", "orange", "red"), box.col = "transparent", bg = "transparent", lty = 1)
  
  Sys.sleep(0.1)
  dev.off()

}

# Challenge question D
Challenge_D <- function() {
  
  Coalescence_sim <- function(v, J){
    # v = speciation rate
    # J = community size
    #J = 5000
    #v = 0.002902
    
    # a) 
    lineages <- rep(1, J)
    
    # b)
    abundances <- vector()
    
    # c) length of "lineages"
    N <- J
    
    # d)
    theta <- v*((J-1)/(1-v))
    
    # k)
    while (N > 1){
      
      # e)
      j <- sample(length(lineages), 1)
      
      # f)
      randnum <- runif(1, min = 0, max = 1)
      
      # g)
      if (randnum < (theta/(theta+N-1))) {
        abundances <- c(abundances, lineages[j])
        
        # h)
      } else if (randnum >= (theta/(theta+N-1))) {
        i <- j
        while(i == j) {
          i <- sample(length(lineages), 1)
        }
        lineages[i] <- lineages[i] + lineages[j]
      }
      
      # i)
      lineages <- lineages[-j]
      
      # j) 
      N <- N - 1
    }
    
    # l)
    abundances <- c(abundances, lineages)
    
    return(abundances)
  }
  
  ############# Normal neutral simulation #########################
  rep500 <- 0
  rep1000 <- 0
  rep2500 <- 0
  rep5000 <- 0
  abun_lengths <- c(0,0,0,0)
  
  # vector of all file names
  files <- list.files("output_files", pattern = "\\.rda$", full.names = TRUE)
  
  for (file in files) {
    
    # Read in file
    load(file)
    
    # Add the row to the previous values, accounting for different vector lengths
    if (grepl(".*_500_.*\\.rda$", file)) {
      # Record length of file
      abun_lengths[1] <- abun_lengths[1] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep500 <- sum_vect(rep500, abundance_list[[i]])
      }
      
    } else if (grepl(".*_1000_.*\\.rda$", file)) {
      abun_lengths[2] <- abun_lengths[2] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep1000 <- sum_vect(rep1000, abundance_list[[i]])
      }      
      
    } else if (grepl(".*_2500_.*\\.rda$", file)) {
      abun_lengths[3] <- abun_lengths[3] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep2500 <- sum_vect(rep2500, abundance_list[[i]])
      }      
      
    } else if (grepl(".*_5000_.*\\.rda$", file)) {
      abun_lengths[4] <- abun_lengths[4] + length(abundance_list)
      
      # Read each row of each file
      for (i in 1:length(abundance_list)){
        rep5000 <- sum_vect(rep5000, abundance_list[[i]])
      }      
    }
  }
  
  rep500 <- rep500/abun_lengths[1]
  rep1000 <- rep1000/abun_lengths[2]
  rep2500 <- rep2500/abun_lengths[3]
  rep5000 <- rep5000/abun_lengths[4]
  
  combined_results <- list(rep500, rep1000, rep2500, rep5000)
  
  
  ####################### Coalescence Simulation ######################################
  coa500 <- 0
  coa1000 <- 0
  coa2500 <- 0
  coa5000 <- 0
  
  abun_lengths <- c(100,100,100,100)
  
  for (i in 1:abun_lengths[1]) {
    oct_coalescence <- octaves(Coalescence_sim(0.002902, 500))
    coa500 <- sum_vect(coa500, oct_coalescence)
  }
      
  for (i in 1:abun_lengths[2]) {
    oct_coalescence <- octaves(Coalescence_sim(0.002902, 1000))
    coa1000 <- sum_vect(coa1000, oct_coalescence)
  }

  for (i in 1:abun_lengths[3]){
    oct_coalescence <- octaves(Coalescence_sim(0.002902, 2500))
    coa2500 <- sum_vect(coa2500, oct_coalescence)
  }
      
  for (i in 1:abun_lengths[4]){
    oct_coalescence <- octaves(Coalescence_sim(0.002902, 5000))
    coa5000 <- sum_vect(coa5000, oct_coalescence)
  }
  
  coa500 <- coa500/100
  coa1000 <- coa1000/100
  coa2500 <- coa2500/100
  coa5000 <- coa5000/100
  
  combined_coa <- list(coa500, coa1000, coa2500, coa5000)
  
  barnames <- as.vector("1")
  for (n in 2:(length(combined_results[[4]]))-1) {
    name <- paste(as.character(2^(n)), "-", as.character(2^(n+1)-1), sep = "")
    barnames <- append(barnames, name)
  }
  
  plot_data <- data.frame(data = c(combined_results[[4]], c(combined_coa[[4]],0)), 
                          group = rep(barnames, 2), type = rep(c("Neutral", "Coalescence"), each = 12))

  library(ggplot2)
  
  # plot your graph here
  p <- ggplot(plot_data, aes(x = factor(group, levels = barnames), y = data, fill = type)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "Abundance octave", y = "Number of species", fill = "Simulation Type") +
    ggtitle("Neutral and coalescence simulations for population of 5000") +
    theme_classic()
  
  plot(p)
  
  ggsave("Challenge_D.png", width = 10, height = 6)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("Coalescence simulations are much faster as they only simulate individuals that have decendent individuals present at the current observed state. 
         These are present in the current state either by previous states surviving, multiplying or speciating. 
         Individuals that have gone extinct during the simulation, and therefore do not contribute the current state, are not included at all in the simulation.
         This means much fewer individuals, and possibly fewer repeats, need to be simulated overall. Whilst the 5000 individual neutral simulation took 11.5 hours to run ~17000 simulations across 25 cluster PCs, overall therefore taking 287.5 hours of runtime, 100 repeats for the 5000 individual Coalescence simulations uses only around 9 seconds to run on 1 PC, suggesting 17000 runs would only take around 0.5 hours, 575 times faster.")
}

# Challenge question E
Challenge_E <- function(){
  
  ######## MODIFIED Q32 FUNCTION ################################
  stochastic_mean_life_stage <- function(initial_state,growth_matrix,reproduction_matrix,clutch_distribution,simulation_length){
    repro_prob <- stochastic_recruitment(reproduction_matrix, clutch_distribution)
    state <- initial_state
    mean_stage <- rep(0, simulation_length + 1)
    mean_stage[1] <- (state[1]*1 + state[2]*2 + state[3]*3 + state[4]*4) / sum(state)
    
    for (i in 1:simulation_length){
      state <- stochastic_step(state, growth_matrix, reproduction_matrix, clutch_distribution, repro_prob)
    
      mean_stage[i+1] <- (state[1]*1 + state[2]*2 + state[3]*3 + state[4]*4) / sum(state)
      
      if (sum(state) == 0){
        break
      }
    }
    
    return(mean_stage)
  }
  
  
  #########################################################
  
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
  
  state_spread <- state_initialise_spread(4,100)
  state_adult <- state_initialise_adult(4,100)
  
  results_spread <- stochastic_mean_life_stage(state_spread, growth_matrix,reproduction_matrix,clutch_distribution, 24)
  results_adult <- stochastic_mean_life_stage(state_adult, growth_matrix,reproduction_matrix,clutch_distribution, 24)
  
  png(filename="Challenge_E.png", width = 600, height = 400)
  # plot your graph here
  plot(results_adult, type = "l", col = "red", xlab = "Time point", ylab = "Abundance", ylim = c(1,4))
  lines(results_spread, col = "blue")
  legend("bottomright", c("Adults only", "Even spread"), lwd=c(2,2), col = c("red", "blue"), box.col = "transparent", bg = "transparent", lty = 1)
  
  Sys.sleep(0.1)
  dev.off()
  
  return("Whilst the adults only start starts at a mean state of 4, the spread start initialises at a mean state of 2.5.
         The mean state of the adults start drops rapidly at time step 2 as the abundance of adults results in the reproduction of many state 1 individuals, whilst the ")
}

# Challenge question F
Challenge_F <- function(){
  # Load ggplot package
  library(ggplot2)
  
  # Create and assign column names to data frame
  population_size_df <- data.frame(matrix(nrow = 121*150*100, ncol = 4))
  colnames(population_size_df) <- c("simulation_number", "initial_condition", "time_step", "population_size")
  
  # vector of all file names
  files <- list.files("output_stochastic", pattern = "\\.rda$", full.names = TRUE)
  
  # Counting
  current_row <- 1
  sim_number <- 1

  #################### MAIN LOOP ##############################################
  for (file in files) {
    
    # Read in file
    load(file)
    
    ############## initial_condition ##########################################
    if (grepl(".*big_adult.*\\.rda$", file)) {
      
      population_size_df$initial_condition[current_row:(current_row+18149)] <- "Adults, large population"
      
    } else if (grepl(".*small_adult.*\\.rda$", file)) {
      
      population_size_df$initial_condition[current_row:(current_row+18149)] <- "Adults, small population"
      
    } else if (grepl(".*big_spread.*\\.rda$", file)) {
      
      population_size_df$initial_condition[current_row:(current_row+18149)] <- "Even spread, large population"
      
    } else if (grepl(".*small_spread.*\\.rda$", file)) {
      
      population_size_df$initial_condition[current_row:(current_row+18149)] <- "Even spread, small population"
    }
    
    
    ###########################################################################
    # Loop through each line (simulation) of each file, 150 for each file
    
    population_size_df$population_size[current_row:(current_row+18149)] <- unlist(result_list)
    
    population_size_df$simulation_number[current_row:(current_row+18149)] <- rep(sim_number:(sim_number+149), each = 121)
    sim_number <- sim_number + 150
    
    population_size_df$time_step[current_row:(current_row+18149)] <- rep(0:120, 150)
    
    current_row <- current_row + 18150
  }
  
  
  ################### PLOT #####################
  p <- ggplot(population_size_df, aes(x=time_step, y=population_size, group=simulation_number, colour=initial_condition)) +
    geom_line(alpha=0.1) +
    labs(x = "Time step", y = "Population size",
      size = "Initial population",
      color = "Initial population") +
    theme_bw() +
    guides(linetype = guide_legend(override.aes = list(alpha = 1)))

  plot(p)
  
  ggsave("Challenge_F.png", width = 10, height = 8)
  # plot your graph here
  Sys.sleep(0.1)
  dev.off()
  
}
