dt <- read.csv(file.choose(), header = T) 
bd <- read.csv(file.choose(), header = T)

str(df)


library(reshape2)
library(ggplot2)
library(ggridges)
library(maps)



tp$handle <- 'Trump'
bd$handle <- 'Biden'

df <- rbind(tp, bd)

allTweets <- lat_lng(df)
par(mar = rep(12, 4))
map("state", lwd = .25)


with(allTweets, points(longitude, latitude,
                       pch = 16, cex = .25,
                       col = rgb(.8, .2, 0, .2)))
