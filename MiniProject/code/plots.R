##################################### PACKAGES #################################
# PACKAGES
library(tidyverse)
library(minpack.lm)
library(patchwork)

data_modified <- read.csv("../data/data_modified.csv")

# List unique IDs
unique_IDs <- unique(data_modified$ID)

################################# FUNCTIONS ####################################
Calc_Values <- function(model, dataset) {
  if (is.na(model)) {
    return(NA)
  } else {
    RSS_Pow <- sum(residuals(model)^2) # Residual sum of squares
    TSS_Pow <- sum((dataset$log.PopBio - mean(dataset$log.PopBio))^2) # Total sum of squares
    RSq <- 1 - (RSS_Pow/TSS_Pow) # R-squared value
    
    n <- nrow(dataset) #set sample size
    parameters <- length(coef(model)) # get number of parameters in model
    
    AICC <- n + 2 + n * log((2 * pi) / n) + n * # AICC
      log(RSS_Pow) + 2 * parameters * (n / (n - parameters - 1))
    BIC <- n + 2 + n * log((2 * pi) / n) + n *  # BIC
      log(RSS_Pow) + (log(n)) * (parameters +1)
    
    return(c(RSq, AICC, BIC))
  }
}


################################# MODELS #######################################
# LOGISTIC MODEL - finds population at time t (N_t)
# t = time "t"
# r_max = Maximum growth rate
# K = Max carrying capacity
# N_0 = Initial Population
logistic_model <- function(t, r_max, K, N_0){ # The classic logistic equation
  return(N_0 * K * exp(r_max * t)/(K + N_0 * (exp(r_max * t) - 1)))
}

# GOMPERTZ MODEL - finds log(population) at time t (N_t)
# Largely same as above
# r_max is tangent of the inflection point
# t_lag = duration of delay, where the r_max tangent crosses the x-axis
gompertz_model <- function(t, r_max, K, N_0, t_lag){ # Modified gompertz growth model (Zwietering 1990)
  return(N_0 + (K - N_0) * exp(-exp(r_max * exp(1) * (t_lag - t)/((K - N_0) * log(10)) + 1)))
}   


############################ FOR LOOP PREP #####################################
# FIT MODEL
model_frame <- data.frame(matrix(nrow = 0, ncol = 4))
names(model_frame) <- c("Time", "log.PopBio", "Model", "id")

run_num <- 0

graphs_to_plot <- c(44, 101, 231, 285)

plots <- list()

########################### FOR LOOP ######################
for (id in graphs_to_plot){
  
  data_subset <- filter(data_modified, ID == unique_IDs[id])
  
  timepoints <- data_subset$Time
  
  ############## Logistic
  N_0_start <- min(data_subset$log.PopBio)
  K_start <- max(data_subset$log.PopBio)
  r_max_start <- (max(data_subset$log.PopBio)-min(data_subset$log.PopBio))/
    (max(data_subset$Time)-min(data_subset$Time))
  
  tryCatch({
    fit_logistic <- nlsLM(log.PopBio ~ logistic_model(t = Time, r_max, K, N_0), data_subset,
                          list(r_max=r_max_start, N_0 = N_0_start, K = K_start))
    
    logistic_points <- logistic_model(t = timepoints, 
                                      r_max = coef(fit_logistic)["r_max"], 
                                      K = coef(fit_logistic)["K"], 
                                      N_0 = coef(fit_logistic)["N_0"])
    df1 <- data.frame(timepoints, logistic_points)
    df1$model <- "Logistic model"
    
  }, error = function(e) {
    cat(conditionMessage(e), id,"\n Logistic Fit Error", run_num,"\n")
    
    df1 <<- data.frame(matrix(ncol = 3, nrow = 0))
  })
  
  
  ############## Gompertz
  N_0_start <- min(data_subset$log.PopBio) # lowest population size, note log scale
  K_start <- max(data_subset$log.PopBio) # highest population size, note log scale
  r_max_start <- (max(data_subset$log.PopBio)-min(data_subset$log.PopBio))/
    (max(data_subset$Time)-min(data_subset$Time)) 
  t_lag_start <- data_subset$Time[which.max(diff(diff(data_subset$log.PopBio)))] # find last timepoint of lag phase
  
  tryCatch({
    fit_gompertz <- nlsLM(log.PopBio ~ gompertz_model(t = Time, r_max, K, N_0, t_lag), data_subset,
                          list(t_lag=t_lag_start, r_max=r_max_start, N_0 = N_0_start, K = K_start))
    
    gompertz_points <- gompertz_model(t = timepoints, 
                                      r_max = coef(fit_gompertz)["r_max"], 
                                      K = coef(fit_gompertz)["K"], 
                                      N_0 = coef(fit_gompertz)["N_0"], 
                                      t_lag = coef(fit_gompertz)["t_lag"])
    
    df2 <- data.frame(timepoints, gompertz_points)
    df2$model <- "Gompertz model"

  }, error = function(e) {
    cat(conditionMessage(e), id,"\n Gompertz Fit Error", run_num,"\n")
    
    df2 <<- data.frame(matrix(ncol = 3, nrow = 0))
  })
  
  
  ############## QUADRATIC
  tryCatch({
    QuaFit <- lm(log.PopBio ~ poly(Time, 2) ,data = data_subset)
    
    quadratic_points <- predict.lm(QuaFit, data.frame(Time = timepoints))
    
    df3 <- data.frame(timepoints, quadratic_points)
    df3$model <- "Quadratic model"

  }, error = function(e) {
    cat(conditionMessage(e), id,"\n Quadratic Fit Error", run_num, "\n")
    
    df3 <<- data.frame(matrix(ncol = 3, nrow = 0))
  })
  
  
  ############## CUBIC
  tryCatch({
    CubicFit <- lm(log.PopBio ~ poly(Time, 3) ,data = data_subset)
    
    cubic_points <- predict.lm(CubicFit, data.frame(Time = timepoints))
    
    df4 <- data.frame(timepoints, cubic_points)
    df4$model <- "Cubic model"

  }, error = function(e) {
    cat(conditionMessage(e), id,"\n Cubic Fit Error", run_num, "\n")
    
    df4 <<- data.frame(matrix(ncol = 3, nrow = 0))
  })
  
  
  ############## PLOT
  names(df1) <- c("Time", "log.PopBio", "Model")
  names(df2) <- c("Time", "log.PopBio", "Model")
  names(df3) <- c("Time", "log.PopBio", "Model")
  names(df4) <- c("Time", "log.PopBio", "Model")
  
  model_frame <- rbind(df1, df2, df3, df4)
  p <- ggplot(data_subset, aes(x = Time, y = log.PopBio)) +
    geom_point(size = 3) +
    geom_line(data = model_frame, aes(x = Time, y = log.PopBio, col = Model), linewidth = 1) +
    theme_bw() +
    theme(aspect.ratio=1)+ # make the plot square 
    labs(x = "Time", y = "Logged Abundance")
  
  plots <- c(plots, list(p))
  
  fit_logistic <- NA
  fit_gompertz <- NA
  QuaFit <- NA
  CubicFit <- NA
}


combined_plot <- plots[[1]] + 
  theme(legend.position = 'none',
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10)) +
  annotate("text", x = -Inf, y = Inf, hjust = 0, vjust = 1, label = "A)", size = 8) +
  
  plots[[2]] + 
  theme(legend.position = 'none',
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10)) +
  annotate("text", x = -Inf, y = Inf, hjust = 0, vjust = 1, label = "B)", size = 8) +
  
  plots[[3]] + 
  theme(legend.position = 'none',
        axis.title.x = element_text(size = 14),
        axis.title.y = element_text(size = 14),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10)) +
  annotate("text", x = -Inf, y = Inf, hjust = 0, vjust = 1, label = "C)", size = 8) +
  
  plots[[4]] + 
  theme(legend.position = c(0.7, 0.3),
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12),
        axis.title.x = element_text(size = 14),
        axis.title.y = element_blank(),
        axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 10)) +
  annotate("text", x = -Inf, y = Inf, hjust = 0, vjust = 1, label = "D)", size = 8) +
  
  plot_layout(ncol = 2, byrow = TRUE)

# Display the combined plot
print(combined_plot)

ggsave("../results/combined.png", width = 10, height = 10)