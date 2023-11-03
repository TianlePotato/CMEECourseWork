require(tidyverse)

data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Convert feeding interactions into FACTOR
data$Type.of.feeding.interaction <- as.factor(data$Type.of.feeding.interaction)


# Figure 1 - Predator mass
predator.data <- tapply(data$Predator.mass, data$Type.of.feeding.interaction, FUN = log10)

pdf("../results/Pred_Subplots.pdf")

par(mfrow=c(3,2))

for (i in 1:length(predator.data)){
  hist(predator.data[[i]], xlab = ("logged mass (g)"), main = names(predator.data[i]))
}

graphics.off()


# Figure 2 - Prey mass
prey.data <- tapply(data$Prey.mass, data$Type.of.feeding.interaction, FUN = log10)

pdf("../results/Prey_Subplots.pdf")

par(mfrow=c(3,2))

for (i in 1:length(prey.data)){
  hist(prey.data[[i]], xlab = ("logged mass (g)"), main = names(prey.data[i]))
}

graphics.off()


# Figure 3 - Size ratio of prey mass over predator mass
data$ratio <- data$Prey.mass / data$Predator.mass
ratio.data <- tapply(data$ratio, data$Type.of.feeding.interaction, FUN = log10)

pdf("../results/SizeRatio_Subplots.pdf")

par(mfrow=c(3,2))

for (i in 1:length(ratio.data)){
  hist(ratio.data[[i]], xlab = ("logged ratio of prey:predator mass"), main = names(ratio.data[i]))
}

graphics.off()


# CSV writeup
PP_Results <- data %>% 
  group_by(Type.of.feeding.interaction) %>%
  summarise(median.mass.pred=log(median(Predator.mass)), 
            mean.mass.pred=log(mean(Predator.mass)),
            median.mass.prey=log(median(Prey.mass)), 
            mean.mass.prey=log(mean(Prey.mass)),
            median.ratio=log(median(Prey.mass)/median(Predator.mass)),
            mean.ratio=log(mean(Prey.mass)/mean(Predator.mass)))

write.csv(PP_Results, "../results/PP_Results.csv", row.names = F)
