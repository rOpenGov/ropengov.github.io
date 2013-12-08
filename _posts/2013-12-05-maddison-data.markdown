---
layout: post
title:  "Maddison prject in R "
date:   2013-12-05 18:53:45
categories: general

excerpt: "There is a growing trend of new methods for assessing economic data in R"

author:
  name: Markus Kainu
  image: markus.jpg
---

## Economic data in R

There is a growing trend of new methods for assessing economic data in R. Packages as [WDI: World Development indicators](https://github.com/vincentarelbundock/WDI), [Quandl](http://www.quandl.com/help/packages/r), [pwt: Penn World Table](http://cran.r-project.org/web/packages/pwt/index.html). Also the **data sets** -section in [CRAN Task View: Computational Econometrics](http://cran.r-project.org/web/views/Econometrics.html) is worth looking.

## Maddison Project database

One which is seemingly missing is the mighty [Maddison Project database](http://www.ggdc.net/maddison/maddison-project/home.htm) that is often used especially by economic historians. Data includes estimates of economic growth in the world economic between **AD 1 and 2010**. A major update was done in January 2013 and a detailed documentation of that update can be read from [Bolt and Van Zanden (2013). The First Update of the Maddison Project; Re-Estimating Growth Before 1820, Maddison Project Working Paper 4.](http://www.ggdc.net/maddison/maddison-project/publications/wp4.pdf). The actual data as .xlsx-file is here: [mpd_2013-01.xlsx](http://www.ggdc.net/maddison/maddison-project/data/mpd_2013-01.xlsx)

## The Exercise

Below is a stepwise explanation on how to visualize the data.

### Load the data


{% highlight r %}
library(gdata)
url <- "http://www.ggdc.net/maddison/maddison-project/data/mpd_2013-01.xlsx"
dat <- read.xls(url, header = TRUE, skip = 1, stringsAsFactors = FALSE)
{% endhighlight %}


### Manipulating the data

Excel-sheets usually require some processing in R. Below I'm removing row not needed and melting the data in long format, and convert in to numerical.



{% highlight r %}
column.names <- as.character(dat[1, ])
column.names[1] <- "year"
df.mad <- dat[-1, ]
names(df.mad) <- column.names
library(reshape2)
df.mad.l <- melt(df.mad, id.vars = "year")
df.mad.l$value <- as.numeric(df.mad.l$value)
df.mad.l <- df.mad.l[!is.na(df.mad.l$value), ]
{% endhighlight %}


### Subset the data

My research emphasises in post-socialist space and therefore I will subset the data. In addition to post-socialist countries I'm including some Western countries, too.


{% highlight r %}
cntry.list <- c("Czech Republic", "Estonia", "Hungary", "Bulgaria", "Latvia", 
    "Lithuania", "Poland", "Slovakia", "Slovenia", "Romania", "Albania", "Bosnia", 
    "Bulgaria", "Croatia", "Macedonia", "Montenegro", "Kosovo", "Serbia", "Armenia", 
    "Azerbaijan", "Belarus", "Georgia", "Kazakhstan", "Kyrgyzstan", "Moldova", 
    "Mongolia", "Russia", "Tajikistan", "Ukraine", "Uzbekistan", "F. USSR", 
    "USA", "Japan", "Finland", "Sweden")
library(stringr)
df.mad.l$variable <- str_trim(df.mad.l$variable, side = "both")
df.mad.l2 <- df.mad.l[df.mad.l$variable %in% cntry.list, ]
{% endhighlight %}


Then I will group the countries in one sensible way.


{% highlight r %}

library(car)
df.mad.l2$group[df.mad.l2$variable %in% c("Czech Republic", "Estonia", "Hungary", 
    "Bulgaria", "Latvia", "Lithuania", "Poland", "Slovakia", "Slovenia", "Romania", 
    "Bulgaria")] <- "CEE"
df.mad.l2$group[df.mad.l2$variable %in% c("Albania", "Bosnia", "Croatia", "Macedonia", 
    "Montenegro", "Kosovo", "Serbia")] <- "Balkan"
df.mad.l2$group[df.mad.l2$variable %in% c("Armenia", "Azerbaijan", "Belarus", 
    "Georgia", "Kazakhstan", "Kyrgyzstan", "Moldova", "Mongolia", "Russia", 
    "Tajikistan", "Ukraine", "Uzbekistan")] <- "CIS"
df.mad.l2$group[df.mad.l2$variable %in% c("USA", "Japan", "Finland", "Sweden")] <- "WEST"
df.mad.l2$group[df.mad.l2$variable %in% c("F. USSR")] <- "USSR"
{% endhighlight %}


### Plotting the data from 1850 to 2010

As I mentioned in the beginning the data extends for over 2000 years. My interest is more of contemporary nature, so I will subset data to cover only the last 160 years from 1850 to 2010. Also, I will add some major historical events during that period that have had an effect on economic growth, too.


{% highlight r %}
library(ggplot2)
ggplot(data = df.mad.l2[df.mad.l2$year > 1850, ], aes(x = year, y = value, group = variable, 
    color = group)) + geom_line() + geom_point() + geom_text(data = df.mad.l2[df.mad.l2$year == 
    2010, ], aes(x = year, y = value, label = variable)) + annotate("rect", 
    xmin = 1914, xmax = 1918, ymin = 5, ymax = 20000, alpha = 0.2) + annotate("text", 
    x = 1916, y = 21000, label = "WW1") + annotate("rect", xmin = 1939, xmax = 1945, 
    ymin = 5, ymax = 20000, alpha = 0.2) + annotate("text", x = 1942, y = 21000, 
    label = "WW2") + annotate("segment", x = 1991, xend = 1991, y = 0, yend = 30000, 
    colour = "blue") + annotate("text", x = 1991, y = 31000, label = "Dissolution of \n the Soviet Union") + 
    theme_minimal() + theme(legend.position = "top")
{% endhighlight %}

![center](/figs/2013-12-05-maddison-data/maddison5.png) 





[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
