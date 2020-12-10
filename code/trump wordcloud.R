#Read file
dt <- read.csv(file.choose(), header = T) 
# Read a csv file, it will open a interface let u to choose
# dt stands for trump
# 5000 obs means 5000 tweets
str(dt)


# tweets
library(NLP)
library(tm)
corpus <- iconv(dt$text, to = 'utf-8-mac') 
#utf-8-mac only mac can use it, change it to the format your computer can run
corpus <- Corpus(VectorSource(corpus))
# Let's see the first five tweets
inspect(corpus[1:5])


# data text cleaning
# ignore the warning message, it will be fine 
#make everything lower case
corpus <- tm_map(corpus, tolower) 

# Remove the Punctuation
corpus <- tm_map(corpus, removePunctuation)

# Remove all the numbers 
corpus <- tm_map(corpus, removeNumbers)


# Take out the english words that so common will add no value
cleanset <- tm_map(corpus, removeWords, stopwords('english'))


# See the first five tweets, how they look like now 
inspect(cleanset[1:5])


# Remove the urls
removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
cleanset <- tm_map(cleansetm, content_transformer(removeURL))

# don't run this 

cleanset <- tm_map(cleanset, gsub, pattern = 'donaldtrump',
                                   replacement = 'trump')

cleanset <- tm_map(cleanset, gsub, pattern = 'realdonaldtrump',
                                   replacement = 'trump')

cleanset <- tm_map(cleanset, gsub, pattern = 'donald',
                                   replacement = 'trump')

cleanset <- tm_map(cleanset, gsub, pattern = 'joebiden',
                                   replacement = 'biden')

cleanset <- tm_map(cleanset, gsub, pattern = 'americans',
                                   replacement = 'america')

cleanset <- tm_map(cleanset, gsub, pattern = 'realtrump',
                                   replacement = 'trump')

cleanset <- tm_map(cleanset, gsub, pattern = 'trump???',
                                   replacement = 'trump')

cleanset <- tm_map(cleanset, removeWords, c('???', '??????', '  ???'))


# get rid of the white space
cleanset <- tm_map(cleanset, stripWhitespace)
inspect(cleanset[1:5])

# Term document matrix
tdm <- TermDocumentMatrix(cleanset)
tdm
tdm <- as.matrix(tdm)
# LOOK THE FIRST 10 WORDS AND 1-20 COLUMNS
tdm[1:10, 1:20]

# Bar Plot
# Find how many times each terms appear in this tdm by doing rowsum
w <- rowSums(tdm)
# Becaues we have 5000 tweets so we can take a subset of the w 
# We only cares about the words that appears more than 150times
w <- subset(w, w>=150)
w


# make a bar plot 
barplot(w,
        las = 2,
        col = rainbow(100))



# WordCloud
library(RColorBrewer)
library(wordcloud)

w <- sort(rowSums(tdm), decreasing = TRUE)
set.seed(222)
wordcloud(words = names(w), freq = w, max.words = 150, 
          random.order = F, min.freq = 20, colors = brewer.pal(8, 'Dark2'))


# different scale word cloud
wordcloud(words = names(w), 
          freq = w, 
          max.words = 150, 
          random.order = F, 
          min.freq = 20, 
          colors = brewer.pal(8, 'Dark2'),
          scale = c(5, 0.3),
          rot.per = 0.3)

# Wordcloud 2
library(wordcloud2)

w <- data.frame(names(w), w)
colnames(w) <- c('word', 'freq')
head(w)
wordcloud2(w, 
           size = 1,
           shape = 'star',
           rotateRatio = 0.3,
           minSize = 1)






































