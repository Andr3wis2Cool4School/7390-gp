dt <- read.csv(file.choose(), header = T) 

str(dt)


library(NLP)
library(tm)

corpus <- iconv(dt$text, to = 'utf-8-mac') 

corpus <- Corpus(VectorSource(corpus))

inspect(corpus[1:5])

corpus <- tm_map(corpus, tolower) 

# Remove the Punctuation
corpus <- tm_map(corpus, removePunctuation)

# Remove all the numbers 
corpus <- tm_map(corpus, removeNumbers)


# Take out the english words that so common will add no value
cleanset <- tm_map(corpus, removeWords, stopwords('english'))


cleanset <- tm_map(cleanset, gsub, pattern = 'realdonaldtrump',
                   replacement = 'trump')

cleanset <- tm_map(cleanset, gsub, pattern = 'donaldtrump',
                   replacement = 'trump')

cleanset <- tm_map(cleanset, gsub, pattern = 'joebiden',
                   replacement = 'biden')


removeURL <- function(x) gsub('http[[:alnum:]]*', '', x)
cleanset <- tm_map(cleansetm, content_transformer(removeURL))







cleanset <- tm_map(cleanset, stripWhitespace)
inspect(cleanset[1:5])

# Term document matrix
tdm <- TermDocumentMatrix(cleanset)
tdm
tdm <- as.matrix(tdm)



w <- rowSums(tdm)
# Becaues we have 5000 tweets so we can take a subset of the w 
# We only cares about the words that appears more than 150times
w <- subset(w, w>=150)
w

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

