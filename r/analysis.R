library( tidyverse )
library(dplyr)
library(knitr)
library(grid)
library(gridBase)
library(gridExtra)

gapminder.words <- read.csv("E:/term3/545/hw09-Sukeysun/data/gapminder_words.csv")

myt <- ttheme_default( 
	# Use hjust and x to center the text
	# Alternate the row fill colours
	core = list( fg_params=list( hjust = 0.5 , x = 0.5 ),   # 1: right 0:left 0.5:center
				 bg_params=list( fill=c( "green", "pink" ) ) ),
	
	# Change column header to white text and red background
	colhead = list( fg_params=list( col="white" ),
					bg_params=list( fill="red" ) ) )

spreadplt.new <- gapminder.words %>%
	mutate( continent = fct_reorder( continent, gdpPercap, mean ) ) %>% 
	ggplot( aes( x = continent, y = gdpPercap ) )+
	geom_boxplot( aes( colour = continent ),
				  outlier.alpha = 0.1 )+
	## add mean value on the graph
	stat_summary( fun.y=mean, colour="darkred", geom="point", size=2,show.legend  = TRUE ) +
	stat_summary( fun.y=mean, colour="red", geom="text", size = 4, show.legend  = TRUE, 
				  vjust=-0.7, aes( label=round( ..y.., digits=1 ) ) ) +
	## add "$"

	theme_bw()+
	
	
	labs( x = "continent", y = "gdp/capita") +
	theme(
		axis.text.x = element_text( size = 12 ),
		axis.text.y = element_text( size = 12 ),
		axis.title = element_text( size = 14),
		legend.text = element_text( size = 14 ),
		legend.title = element_text( size = 15),
		plot.background = element_rect( fill = "white", colour = "grey50" ),
		panel.border = element_rect(linetype = "dashed", fill = NA)
	)


new_colors <- c("mean" = "black", "median" = "blue","standard deviation" = "red" )

range_captia <- gapminder.words %>%
	group_by( continent ) %>% 
	summarize( min_gdp = min( gdpPercap ), max_gdp = max( gdpPercap ),
			   mean_gdp = mean( gdpPercap ), md_gdp = median( gdpPercap ),
			   sd_gdp = sd( gdpPercap )) %>%  # summarize the basic info of gdp in each continent
	mutate( gdp_range = paste( min_gdp, max_gdp, sep = " ~ ")) %>% # separate minimum and maximum value by ~
	select( continent, gdp_range, mean_gdp, md_gdp, sd_gdp)



rangeplt.new <- range_captia %>%
	ggplot() +
	geom_line( aes( x = continent, y = mean_gdp, color = "mean",group = 1 ))+
	geom_line( aes( x = continent,y = md_gdp,color = "median",group = 1 )) +
	
	geom_line( aes( x = continent,y = sd_gdp,color = "standard deviation",group = 1 ))+

	
	labs(x = "continent", y = "gdp/capita") +
	
	
	
	scale_colour_manual( "Statistic summary:",  
						 values = new_colors,
						 breaks = c("mean", "median","standard deviation" ), # The original values 
						 labels = c(" The Mean", "The Median","The Stdev")   # What you want to call them 
	)+
	theme_bw()+
	theme(
		axis.text.x = element_text( size = 10 ),
		axis.text.y = element_text( size = 10 ),
		axis.title = element_text( size = 14),
		legend.text = element_text( size = 14 ),
		legend.title = element_text( size = 15),
		plot.background = element_rect( fill = "white", colour = "black" ),
		panel.border = element_rect(linetype = "dashed", fill = NA)
	)


graph <- grid.arrange( top=textGrob( "Spread of GDP per capita within the continents",
									 gp=gpar( fontsize = 22,font = 8 ) ),
					   
					   tableGrob( range_captia,
					   		   theme = myt,
					   		   rows = NULL),
					   spreadplt.new,
					   rangeplt.new,
					   nrow = 2)


ggsave("E:/term3/545/hw09-Sukeysun/pictures/analysis.png",graph, width=50, height=30, units = "cm")
