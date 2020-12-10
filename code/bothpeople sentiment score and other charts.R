library(tm)
library(lubridate)
library(dplyr)
library(plotly)
library(scales)
library(formattable)
library(RSentiment)
library(stringr)
library(broom)
library(tidyr)
library(tidytext)
library(igraph)
library(ggplot2)






# Load the files 
tp <- read.csv(file.choose(), header = T, stringsAsFactors = F)
bd <- read.csv(file.choose(), header = T, stringsAsFactors = F)


tp$handle <- 'Trump'
bd$handle <- 'Biden'

df <- rbind(tp, bd)
str(df)


# dates and time 
df$created <- gsub('T', ' ', df$created)
df$created <- as.POSIXct(df$created, format='%Y-%m-%d %H:%M:%S', tz='GMT')


# We are spliting the time var into the day, hour and month
df$day <- day(df$created)
df$month <- month(df$created)
df$hour <- hour(df$created)

str(df)
# df$day
# df$month
# df$hour

# time trend

# day trend
temp <- df %>% select(handle, day)
temp <- temp %>% group_by(handle, day)%>% summarise(n=n())
ggplotly((ggplot(temp, aes(x=day, y=n, colour=handle)) + geom_line() + geom_point(shape=21,size=4)))


# hour trend
temp <- df %>% select(handle, hour)
temp <- temp %>% group_by(handle, hour) %>% summarise(n=n())
ggplotly((ggplot(temp, aes(x=hour, y=n, colour=handle)) + geom_line() + geom_point(shape=21, size=4))) 


temp <- df %>% select(text, handle, hour)
temp$text <- str_replace_all(temp$text, '[^[:alnum:]]',' ')
temp$text = gsub("[[:digit:]]", " ", temp$text)
temp$text = gsub("[ \t]{2,}", " ", temp$text)
temp$line <- seq(from=1, to=dim(temp)[1], by=1)
words <- temp %>%unnest_tokens(word, text)%>%filter(!word %in% stop_words$word,str_detect(word, "^[a-z']+$"))
polar_words <- calculate_score(words$word)
words$polar_words <- polar_words
polar_line <- words %>% group_by(line, handle, hour) %>% summarise(score=sum(polar_words))
# histogram
ggplot(polar_line, aes(x=score, fill=handle)) + geom_histogram(position = "identity", alpha=0.4, binwidth = 1)


# BoxPlot
ggplot(polar_line, aes(x=(handle), y=score)) + geom_boxplot() + 
  stat_summary(fun.y = 'mean', geom = 'point', shape=23, size=3, fill='white')



# Change by the hour 
polar_line <- polar_line %>% group_by(handle,hour) %>% summarise(mean_score=mean(score))
ggplot(polar_line, aes(x=hour, y=mean_score, fill=handle)) +
  geom_bar(position="dodge",stat='identity')

# Retweets and favorites
plot <- ggplot(df, aes(x=retweetCount, y=favoriteCount, colour=handle)) + 
  geom_point(alpha=0.5, size=3) + 
  scale_color_discrete("") +
  xlim(0, 1000) +
  ylim(0, 500) +
  xlab('Retweets') + 
  ylab('Favorites') + 
  ggtitle('Trump Vs Biden: Retweets and Favorites') + 
  theme_light(base_size=12) +
  theme(legend.position = 'top', legend.direction = 'horizontal')

plot









