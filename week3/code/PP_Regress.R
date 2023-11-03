#!/usr/bin/env Rscript

require(tidyverse)
require(scales)

#####################################################
# DATA WRANGLING
data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Convert feeding interactions into FACTOR
data$Type.of.feeding.interaction <- as.factor(data$Type.of.feeding.interaction)
data$Predator.lifestage <- as.factor(data$Predator.lifestage)
data$Prey.mass.unit <- as.factor(data$Prey.mass.unit)

##!!! NOT ALL MASSES SAME UNIT, BUT SAMRAAT GRAPH SEEMS TO HAVE IGNORED THIS !!!##
# Changing all masses into grams
#data$Prey.mass[data$Prey.mass.unit == "mg"] <- data$Prey.mass[data$Prey.mass.unit == "mg"] / 1000

# Removing un-needed columns
data <- data.frame(data$Predator.mass, data$Type.of.feeding.interaction, data$Prey.mass, data$Predator.lifestage)
colnames(data) <- c("Predator.mass", "Type.of.feeding.interaction", "Prey.mass", "Predator.lifestage")


#####################################################
# PLOTTING
ggplot(data, aes(x=log10(Prey.mass), y=log10(Predator.mass))) +
  geom_point(aes(colour=Predator.lifestage), shape=3) +
  geom_smooth(aes(colour=Predator.lifestage),method = "lm", fullrange=TRUE, size=0.5) +
  facet_grid(Type.of.feeding.interaction ~.) +
  theme_bw() +
  labs(x="Prey Mass in grams", y="Predator mass in grams") +
  theme(legend.position = "bottom",
        legend.title = element_text(face = "bold"),
        ) +
  guides(colour = guide_legend(nrow = 1)) +
  coord_fixed(ratio = 0.5) +
  scale_x_continuous(labels = scientific) +
  scale_y_continuous(labels = scientific)

ggsave("../results/PP_Regress.pdf", width = 8, height = 10)

#####################################################
# STATISTICS
fitted_models <- data %>% 
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>% 
  do(model = lm(log10(Predator.mass) ~ log10(Prey.mass), data = .))

#fitted_models <- fitted_models[c(-6,-8),] #Removed models with unsuitable numbers of data-points


results_lm <- data.frame(matrix(nrow=18,ncol=7))

colnames(results_lm) <- c("Type.of.feeding.interaction",
      "Predator.lifestage",
      "Slope",
      "Intercept",
      "R.squared", # summary(fitted_models$insectivorous)$r.squared
      "F.value", # summary(fitted_models$insectivorous)$fstatistic[1]
      "P.value") # pf(summary(fitted_models$insectivorous)$fstatistic[1], summary(fitted_models$insectivorous)$fstatistic[2], summary(fitted_models$insectivorous)$fstatistic[3], lower.tail = FALSE)

results_lm$Type.of.feeding.interaction <- fitted_models$Type.of.feeding.interaction
results_lm$Predator.lifestage <- fitted_models$Predator.lifestage

for (row in 1:18){
  
  # INTERCEPT
  if (is.null(as.numeric(coef(fitted_models[[3]][[row]])[1])) == TRUE) {
    results_lm$Intercept[row] <- NA
  } else {
    results_lm$Intercept[row] <- as.numeric(coef(fitted_models[[3]][[row]])[1])
  }
  # SLOPE
  if (is.null(as.numeric(coef(fitted_models[[3]][[row]])[2])) == TRUE) {
    results_lm$Slope[row] <- NA
  } else {
    results_lm$Slope[row] <- as.numeric(coef(fitted_models[[3]][[row]])[2])
  }
  # R-SQUARED
  if (is.null(summary(fitted_models[[3]][[row]])$r.squared) == TRUE) {
    results_lm$R.squared[row] <- NA
  } else {
    results_lm$R.squared[row] <- summary(fitted_models[[3]][[row]])$r.squared
  }
  # F-VALUE & P-VALUE
  if (is.null(summary(fitted_models[[3]][[row]])$fstatistic[1]) == TRUE) {
    results_lm$F.value[row] <- NA
    results_lm$P.value[row] <- NA
  } else {
    results_lm$F.value[row] <-summary(fitted_models[[3]][[row]])$fstatistic[1]
    results_lm$P.value[row] <-pf(summary(fitted_models[[3]][[row]])$fstatistic[1], summary(fitted_models[[3]][[row]])$fstatistic[2], summary(fitted_models[[3]][[row]])$fstatistic[3], lower.tail = FALSE)
  }
  
}

write.csv(results_lm, "../results/PP_Regress_Results.csv", row.names = F)
