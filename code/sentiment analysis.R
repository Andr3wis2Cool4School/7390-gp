# Sentiment analysis
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

tp <- read.csv(file.choose(), header = T)

tweets <- iconv(tp$text, to = 'utf-8-mac')

# get the sentiment scores
s <- get_nrc_sentiment(tweets)
head(s)

#bar plot 
barplot(colSums(s),
        las = 2,
        col = rainbow(10),
        ylab = 'Count',
        main = 'Sentiment scores for Biden tweets')
