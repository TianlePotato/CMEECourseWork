library(ggplot2)

load("../data/GPDDFiltered.RData")

world_map <- map_data("world")

bruhmap <- ggplot() + 
  geom_polygon(data = world_map, aes(x=long, y=lat, group=group), fill = "grey") +
  geom_point(data = gpdd, aes(x=long, y=lat)) +
  theme_bw()
  
bruhmap

# Biases: The data points on the map are mostly distributed in Either North America
# or Europe. Only 1 data point represent the continents of Asia and Africa each.
# There are no data points in South America or Australia. This means much of the
# world's variation is ignored.
