

library( tidyr )

library( dplyr )


gapminder <- read.csv("E:/term3/545/hw09-Sukeysun/data/gapminder.csv")
words <- readLines("E:/term3/545/hw09-Sukeysun/data/words.txt")
words.dataframe <- as.data.frame( words)
gapminder.words <- left_join(gapminder,words.dataframe, 
							 by = c("country" = "words")
							 )
gapminder.words$X <- NULL
write.csv(gapminder.words,"E:/term3/545/hw09-Sukeysun/data/gapminder_words.csv")
