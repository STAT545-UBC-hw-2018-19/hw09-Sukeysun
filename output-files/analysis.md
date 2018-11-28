---
title: "analysis"
author: "Sukey"
output:
  html_document:
    keep_md: yes
---


```r
library( gapminder )
library( tidyverse )
library(dplyr)
library(knitr)
library(grid)
library(gridBase)
library(gridExtra)
```




# Look at the spread of GDP per capita within the continents.



![](E:/term3/545/hw09-Sukeysun/pictures/analysis.png)


Except summarizing the spread of each continent by table, we can also use boxplot and line. Boxplot gives us the maximum and minimum values , quartiles and outliers of a group data, but it cannot show the standard deviation of data. From the figures above, Asia has the highest gdp/capita and the highest standaed deviation while Afica has the lowest gdp/capita and standard deviation.


