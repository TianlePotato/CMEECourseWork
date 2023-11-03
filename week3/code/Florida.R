#!/usr/bin/env Rscript

require(tidyverse)

rm(list=ls())

load("../data/KeyWestAnnualMeanTemperature.RData")

ls()

head(ats)
plot(ats)

##############################################
# Calculating correlation
Sample_Random <- function(repeats){
    correlations <- rep(NA,repeats)

    for (i in 1:repeats){
    ats_new <- rep(NA,length(ats$Temp)) # Preallocates 100 length vector

    ats_new <- sample(ats$Temp, 100, replace = TRUE, prob = NULL) 
    # Assigns all temperatures to random positions in the vector

    spearman_list <- cor.test(ats$Year, ats_new, method = "spearman")

    correlations[i] <- as.numeric(spearman_list$estimate)

    }

    return(correlations)
}

actual_cor <- cor.test(ats$Year, ats$Temp, method = "spearman")

Random_corrs <- Sample_Random(10000)
Random_corrs <- as.data.frame(Random_corrs)


# MAKING THE GGPLOT HISTOGRAM
percentile_2.5 <- quantile(Random_corrs$Random_corrs, 0.025)
percentile_97.5 <- quantile(Random_corrs$Random_corrs, 0.975)

ggplot(Random_corrs, aes(x=Random_corrs)) + 
  geom_histogram(colour = "black", fill = "#f58742") +
  geom_vline(xintercept = percentile_2.5, color = "#000000", size = 1, linetype = "dashed") +
  geom_vline(xintercept = percentile_97.5, color = "#000000", size = 1, linetype = "dashed") +
  xlab("Correlation estimate (rho)") +
  ylab("Frequency") +
  theme_classic() +
  theme(axis.title.x = element_text(size = 14),  
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12))


num.above.actual.cor <- Random_corrs %>% count(Random_corrs > as.numeric(actual_cor$estimate))

