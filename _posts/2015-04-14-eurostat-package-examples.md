---
title: "Searching, downloading and manipulating Eurostat data with R"
author:
  image: markus.jpg
  name: Markus Kainu
date: "2015-05-01 12:53:45"
excerpt: New package eurostat released in CRAN
layout: post
draft: false
categories: R
---

 



## Introduction

We have published a new package `eurostat` in [CRAN](http://cran.r-project.org/). To install the package in R, use:


{% highlight r %}
install.packages("eurostat")
{% endhighlight %}

The eurostat package is based on the [SmarterPoland](http://cran.r-project.org/web/packages/SmarterPoland/index.html) package, which was revised and expanded with new functionality. The new eurostat package includes the following functions:



{% highlight r %}
library(eurostat)
kable(as.data.frame(ls("package:eurostat")))
{% endhighlight %}



|ls("package:eurostat") |
|:----------------------|
|clean_eurostat_cache   |
|eurotime2date          |
|eurotime2num           |
|get_eurostat           |
|get_eurostat_dic       |
|getEurostatDictionary  |
|get_eurostat_toc       |
|getEurostatTOC         |
|grepEurostatTOC        |
|label_eurostat         |
|label_eurostat_tables  |
|label_eurostat_vars    |
|search_eurostat        |


This blog post will walk you through the basic functionalities of the package. To reproduce the examples, run the following code to install the required dependencies.



{% highlight r %}
PACKAGES <- c("eurostat","ggplot2","countrycode","tidyr","dplyr","knitr")
#  Install packages
inst <- match(PACKAGES, .packages(all=TRUE))
need <- which(is.na(inst))
if (length(need) > 0) install.packages(PACKAGES[need])
# Load packages
lapply(PACKAGES, require, character.only=T)
{% endhighlight %}

In this exercise we use indicator [`tgs00026`](http://ec.europa.eu/eurostat/en/web/products-datasets/-/TGS00026), (*Disposable income of private households by NUTS 2 regions*) from Eurostat. Most indicators in Eurostat database are of *country-year* -type,  however, some indicators have data also at lower level of regional breakdown, as `tgs00026` at [NUTS2](http://en.wikipedia.org/wiki/Nomenclature_of_Territorial_Units_for_Statistics)-level. (See more information on regional classification [here](http://ec.europa.eu/eurostat/ramon/nomenclatures/index.cfm?TargetUrl=DSP_GEN_DESC_VIEW_NOHDR&StrNom=NUTS_33&StrLanguageCode=EN)).

## Searching and downloading data from Eurostat

Though we have already picked the data for following demonstrations you can search the available variables using `search_eurostat`-function. Data for *tables* resides in *Datasets* that are in *folders*. You can specify in the function whether you want to look for *table*, *dataset* or a *folder*.


{% highlight r %}
results <- search_eurostat("disposable income", type = "dataset")
# print the first 6 rows
kable(head(results))
{% endhighlight %}



|     |title                                                                                                               |code        |type    |last.update.of.data |last.table.structure.change |data.start |data.end |values |
|:----|:-------------------------------------------------------------------------------------------------------------------|:-----------|:-------|:-------------------|:---------------------------|:----------|:--------|:------|
|1820 |Share of housing cost in disposable income by level of activity limitation, sex and age                             |hlth_dhc050 |dataset |16.10.2014          |                            |2005       |2012     |NA     |
|3526 |Gini coefficient of equivalised disposable income (source: SILC)                                                    |ilc_di12    |dataset |12.03.2015          |16.02.2015                  |1995       |2014     |NA     |
|3527 |Gini coefficient of equivalised disposable income before social transfers (pensions included in social transfers)   |ilc_di12b   |dataset |12.03.2015          |16.02.2015                  |2003       |2014     |NA     |
|3528 |Gini coefficient of equivalised disposable income before social transfers (pensions excluded from social transfers) |ilc_di12c   |dataset |12.03.2015          |16.02.2015                  |2003       |2014     |NA     |

Or you can also download the whole table of contents of the database with `get_eurostat_toc`-function. In both cases the *values* in column `code` should be used to download a selected dataset.


{% highlight r %}
toc <- get_eurostat_toc()
# print the first 6 rows
kable(head(toc))
{% endhighlight %}



|title                                                    |code      |type    |last.update.of.data |last.table.structure.change |data.start |data.end |values |
|:--------------------------------------------------------|:---------|:-------|:-------------------|:---------------------------|:----------|:--------|:------|
|Database by themes                                       |data      |folder  |                    |                            |           |         |NA     |
|General and regional statistics                          |general   |folder  |                    |                            |           |         |NA     |
|European and national indicators for short-term analysis |euroind   |folder  |                    |                            |           |         |NA     |
|Business and consumer surveys (source: DG ECFIN)         |ei_bcs    |folder  |                    |                            |           |         |NA     |
|Consumer surveys (source: DG ECFIN)                      |ei_bcs_cs |folder  |                    |                            |           |         |NA     |
|Consumers - monthly data                                 |ei_bsco_m |dataset |29.04.2015          |29.04.2015                  |1985M01    |2015M04  |NA     |

## Downloading and plotting time-series data at the NUTS2 regional level

However, we are interested in the disposable household income and first we download the data and convert the time column into numeric format.


{% highlight r %}
library(eurostat)
# Clean the cache first
clean_eurostat_cache()
# Download the income variable
dat <- get_eurostat("tgs00026", time_format = "raw")
# Extract the information on country in question. (First two character in region string mark the country)
dat$cntry <- substr(dat$geo, 1,2)
# Create the variable for proper countrynames using countryname-package
library(countrycode)
dat$countryname <- countrycode(dat$cntry, "iso2c", "country.name")
# convert time column from Date to numeric
dat$time <- eurotime2num(dat$time)
kable(head(dat))
{% endhighlight %}



|indic_na |unit     |geo  | time| values|cntry |countryname |
|:--------|:--------|:----|----:|------:|:-----|:-----------|
|B6N_U    |PPCS_HAB |AT11 | 2000|  13900|AT    |Austria     |
|B6N_U    |PPCS_HAB |AT12 | 2000|  15600|AT    |Austria     |
|B6N_U    |PPCS_HAB |AT13 | 2000|  17300|AT    |Austria     |
|B6N_U    |PPCS_HAB |AT21 | 2000|  14100|AT    |Austria     |
|B6N_U    |PPCS_HAB |AT22 | 2000|  14400|AT    |Austria     |
|B6N_U    |PPCS_HAB |AT31 | 2000|  14900|AT    |Austria     |

Then we plot the data at the regional level and color the lines using country names derived from [`countrycode`](http://cran.r-project.org/web/packages/countrycode/index.html)-package.



{% highlight r %}
library(ggplot2)
p <- ggplot(dat, aes(x=time,y=values,group=geo,color=countryname))
p <- p + geom_point() + geom_line()
# Add the region names at the end of each line
p <- p + geom_text(data=merge(dat, aggregate(time ~ geo, dat, max), 
                              by=c("time","geo")), 
                   aes(x=time, y = values, label=geo), hjust=-0.5,vjust=-1,size=3)
p <- p + labs(x="Year", y="Disposable income of private households (€ per year)")
# Place the legend with country names on top in three rows
p <- p + theme(legend.direction = "horizontal", legend.position = "top")
p <- p + guides(color = guide_legend(title = "Country",
                                     title.position = "top", 
                                     title.hjust=.5,
                                     nrow=3,
                                     byrow=TRUE))
p
{% endhighlight %}

![center](/figs/2015-04-14-eurostat-package-examples/unnamed-chunk-7-1.png) 

### Labelling the data

Function `label_eurostat` provides a straighforward way to convert the codes in data into more meaningful labels. The `label_eurostat` function requires that the data is in the "default format" with no added columns. First, check unlabeled example data:


{% highlight r %}
# First, remove the cntry and countrycode columns that were added manually
cntry_cols <- dat[ , names(dat) %in% c("cntry","countryname")]
dat <- dat[ , !names(dat) %in% c("cntry","countryname")]
# Unlabeled data
kable(head(dat))
{% endhighlight %}



|indic_na |unit     |geo  | time| values|
|:--------|:--------|:----|----:|------:|
|B6N_U    |PPCS_HAB |AT11 | 2000|  13900|
|B6N_U    |PPCS_HAB |AT12 | 2000|  15600|
|B6N_U    |PPCS_HAB |AT13 | 2000|  17300|
|B6N_U    |PPCS_HAB |AT21 | 2000|  14100|
|B6N_U    |PPCS_HAB |AT22 | 2000|  14400|
|B6N_U    |PPCS_HAB |AT31 | 2000|  14900|

Labeling the data based on definitions from dictionary:


{% highlight r %}
# apply the definitions from dictionary
datl <- label_eurostat(dat)
# Labeled data
kable(head(datl))
{% endhighlight %}



|indic_na                      |unit                                                                |geo              | time| values|
|:-----------------------------|:-------------------------------------------------------------------|:----------------|----:|------:|
|Disposable income, net (uses) |Purchasing power standard based on final consumption per inhabitant |Burgenland (AT)  | 2000|  13900|
|Disposable income, net (uses) |Purchasing power standard based on final consumption per inhabitant |Niederösterreich | 2000|  15600|
|Disposable income, net (uses) |Purchasing power standard based on final consumption per inhabitant |Wien             | 2000|  17300|
|Disposable income, net (uses) |Purchasing power standard based on final consumption per inhabitant |Kärnten          | 2000|  14100|
|Disposable income, net (uses) |Purchasing power standard based on final consumption per inhabitant |Steiermark       | 2000|  14400|
|Disposable income, net (uses) |Purchasing power standard based on final consumption per inhabitant |Oberösterreich   | 2000|  14900|



{% highlight r %}
# Bind the country name columns back to the labelled data 
datl2 <- cbind(datl,cntry_cols)
{% endhighlight %}

For clarity, we plot first four countries in alphabetical order in their own facets with region names.


{% highlight r %}
# subset the first 4 countries in albhabetical order
datl3 <- datl2[datl2$countryname %in% sort(unique(datl2$countryname))[1:4],]
# plot the data using country facets
library(ggplot2)
p <- ggplot(datl3,aes(x=time,y=values,group=geo))
p <- p + geom_point(color="grey") + geom_line(color="grey")
p <- p + geom_text(data=merge(datl3, aggregate(time ~ geo, datl3, max), 
                              by=c("time","geo")), 
                   aes(x=time, y = values, label=geo), vjust=1,size=3)
p <- p + coord_cartesian(xlim=c(min(datl2$time):max(datl2$time)+3))
p <- p + facet_wrap(~countryname, scales = "free", ncol = 1)
p <- p + labs(title=paste0(unique(datl3$indic_na),"\n(",unique(datl3$unit),")"),
                x="Year",y="Disposable income of private households (€ per year)")
p
{% endhighlight %}

![center](/figs/2015-04-14-eurostat-package-examples/unnamed-chunk-8-1.png) 

## Mapping the household incomes at NUTS2 level

In the following exercise we are plotting household income data from Eurostat on map from three different years. In addition to downloading and manipulating data from EUROSTAT, we will demonstrate how to access and use shapefiles of Europe published by EUROSTAT at [Administrative units / Statistical units](http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units).

For this exercise you need few more dependencies that can be installed running the following script.


{% highlight r %}
PACKAGES <- c("rgdal","maptools","rgeos","stringr","scales","grid")
#  Install packages
inst <- match(PACKAGES, .packages(all=TRUE))
need <- which(is.na(inst))
if (length(need) > 0) install.packages(PACKAGES[need])
# Load packages
lapply(PACKAGES, require, character.only=T)
{% endhighlight %}


### Downloading and manipulating the tabular data

First, we shall retrieve the nuts2-level figures of variable `tgs00026` (Disposable income of private households by NUTS 2 regions) and manipulate the extract the information for creating `unit` and `geo` variables.


{% highlight r %}
library(eurostat)
df <- get_eurostat("tgs00026", time_format = "raw")
# convert time column from Date to numeric
df$time <- eurotime2num(df$time)
# subset time to have data for 2000, 2005 and 2011
df <- df[df$time %in% c(2000,2005,2011),]
# spread the data into wide format
library(tidyr)
dw <- spread(df, time, values)
{% endhighlight %}

### Downloading and manipulating the spatial data

Second, we will download the zipped shapefile in 1:60 million scale from year 2010 and subset it at the level of NUTS2.


{% highlight r %}
# Load the GISCO shapefile
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2010_60M_SH.zip", destfile="NUTS_2010_60M_SH.zip")
# unzip
unzip("NUTS_2010_60M_SH.zip")
library(rgdal)
# read into SpatialPolygonsDataFrame
map <- readOGR(dsn = "./NUTS_2010_60M_SH/NUTS_2010_60M_SH/data", layer = "NUTS_RG_60M_2010")
{% endhighlight %}



{% highlight text %}
## OGR data source with driver: ESRI Shapefile 
## Source: "./NUTS_2010_60M_SH/NUTS_2010_60M_SH/data", layer: "NUTS_RG_60M_2010"
## with 1920 features
## It has 4 fields
{% endhighlight %}



{% highlight r %}
# subset the spatialpolygondataframe at NUTS2-level
map_nuts2 <- subset(map, STAT_LEVL_ == 2)
{% endhighlight %}

### Joining tabular data with spatial data

Third, we will make the both datas of same lenght, give then identical rownames and then merge the tabular data with the spatial data.


{% highlight r %}
# dim show how many regions are in the spatialpolygondataframe
dim(map_nuts2)
{% endhighlight %}



{% highlight text %}
## [1] 316   4
{% endhighlight %}



{% highlight r %}
# dim show how many regions are in the data.frame
dim(dw)
{% endhighlight %}



{% highlight text %}
## [1] 275   6
{% endhighlight %}



{% highlight r %}
# Spatial dataframe has 467 rows and attribute data 275.
# We need to make attribute data to have similar number of rows
NUTS_ID <- as.character(map_nuts2$NUTS_ID)
VarX <- rep(NA, 316)
dat <- data.frame(NUTS_ID,VarX)
# then we shall merge this with Eurostat data.frame
dat2 <- merge(dat,dw,by.x="NUTS_ID",by.y="geo", all.x=TRUE)
## merge this manipulated attribute data with the spatialpolygondataframe
## rownames
row.names(dat2) <- dat2$NUTS_ID
row.names(map_nuts2) <- as.character(map_nuts2$NUTS_ID)
## order data
dat2 <- dat2[order(row.names(dat2)), ]
map_nuts2 <- map_nuts2[order(row.names(map_nuts2)), ]
## join
library(maptools)
dat2$NUTS_ID <- NULL
shape <- spCbind(map_nuts2, dat2)
{% endhighlight %}

### Preparing the data for ggplot2 visualization

As we are using ggplot2-package for plotting, we have to fortify the `SpatialPolygonDataFrame` into regular `data.frame`-class. As we have income data from several years, we have to also `gather` the data into long format for plotting.


{% highlight r %}
## fortify spatialpolygondataframe into data.frame
library(ggplot2)
library(rgeos)
shape$id <- rownames(shape@data)
map.points <- fortify(shape, region = "id")
map.df <- merge(map.points, shape, by = "id")
# As we want to plot map faceted by years from 2003 to 2011
# we have to melt it into long format

# (variable with numerical names got X-prefix during the spCbind-merge,
# therefore the X-prefix in variable names)
library(tidyr)
# lets convert unit variable (that is a list) into character
map.df$unit <- as.character(map.df$unit)
map.df.l <- gather(map.df, "year", "value", 15:17)
# year variable (variable) is class string and type X20xx.
# Lets remove the X and convert it to numerical
library(stringr)
map.df.l$year <- str_replace_all(map.df.l$year, "X","")
map.df.l$year <- factor(map.df.l$year)
map.df.l$year <- as.numeric(levels(map.df.l$year))[map.df.l$year]
{% endhighlight %}

### Plotting the maps using ggplot2

Breaks in the map are set at equal intervals between yearly regional maximun and minimun values.



{% highlight r %}
library(ggplot2)
library(scales)
library(grid)

# Creating a custom function for creating the breaks and makeing them look neat
categories <- function(x, cat=5) {
  
  library(stringr)
  levs <- as.data.frame(as.character(levels(cut_interval(x, cat))))
  names(levs) <- "orig"
  levs$mod <- str_replace_all(levs$orig, "\\[", "")
  levs$mod <- str_replace_all(levs$mod, "\\]", "")
  levs$mod <- str_replace_all(levs$mod, "\\(", "")
  levs$lower <- gsub(",.*$","", levs$mod)
  levs$upper <- gsub(".*,","", levs$mod)
  
  levs$lower <- factor(levs$lower)
  levs$lower <- round(as.numeric(levels(levs$lower))[levs$lower],0)
  
  levs$upper <- factor(levs$upper)
  levs$upper <- round(as.numeric(levels(levs$upper))[levs$upper],0)
  
  levs$labs <- paste(levs$lower,levs$upper, sep=" - ")
  
  labs <- as.character(c(levs$labs))
  y <- cut_interval(x, cat, right = FALSE, labels = labs)
  y <- as.character(y)
  y[is.na(y)] <- "No Data"
  y <- factor(y, levels=c("No Data",labs[1:cat]))
}

# years for for loop
years <- unique(map.df.l$year)

# Loop over the three years
for (year in years) {
  
  # subset data
  plot_map <- map.df.l[map.df.l$year == year,]
  # set the breaks
  plot_map$value_cat <- categories(plot_map$value)
  
  p <- ggplot(data=plot_map, aes(long,lat,group=group))
  p <- p + geom_polygon(data = map.df.l, aes(long,lat),fill=NA,colour="white",size = 1)
  p <- p + geom_polygon(aes(fill = value_cat),colour="white",size=.2)
  p <- p + scale_fill_manual(values=c("Dim Grey","#d7191c","#fdae61","#ffffbf","#a6d96a","#1a9641")) 
  p <- p + coord_map(project="orthographic", xlim=c(-22,34), ylim=c(35,70))
  p <- p + labs(title = paste0("Disposable household incomes in  ",year))
  p <- p +  theme(legend.position = c(0.03,0.40), 
                          legend.justification=c(0,0),
                          legend.key.size=unit(6,'mm'),
                          legend.direction = "vertical",
                          legend.background=element_rect(colour=NA, fill=alpha("white", 2/3)),
                          legend.text=element_text(size=12), 
                          legend.title=element_text(size=12), 
                          title=element_text(size=16), 
                          panel.background = element_blank(), 
                          plot.background = element_blank(),
                          panel.grid.minor = element_line(colour = 'Grey80', size = .5, linetype = 'solid'),
                          panel.grid.major = element_line(colour = 'Grey80', size = .5, linetype = 'solid'),
                          axis.text = element_blank(), 
                          axis.title = element_blank(), 
                          axis.ticks = element_blank(), 
                          plot.margin = unit(c(-3,-1.5, -3, -1.5), "cm"))
  p <- p + guides(fill = guide_legend(title = "€ per Year",
                                     title.position = "top", 
                                     title.hjust=0))
  print(p)
}
{% endhighlight %}

![center](/figs/2015-04-14-eurostat-package-examples/eurostat_map4-1.png) ![center](/figs/2015-04-14-eurostat-package-examples/eurostat_map4-2.png) ![center](/figs/2015-04-14-eurostat-package-examples/eurostat_map4-3.png) 

We are done! That was a small exercise on how to use the main functions in the `eurostat`-package. We hope you find the package useful! All suggestions, bug reports, and contributions are warmly welcome at: <https://github.com/ropengov/eurostat>. When using the packages, please cite accordingly:


{% highlight r %}
citation("eurostat")
{% endhighlight %}



{% highlight text %}
## 
## Kindly cite the eurostat R package as follows:
## 
##   (C) Leo Lahti, Przemyslaw Biecek, Janne Huovari and Markus Kainu
##   2014-2015. eurostat R package URL:
##   https://github.com/rOpenGov/eurostat
## 
## A BibTeX entry for LaTeX users is
## 
##   @Misc{,
##     title = {eurostat R package},
##     author = {Leo Lahti and Przemyslaw Biecek and Janne Huovari and Markus Kainu},
##     year = {2014},
##     url = {https://github.com/rOpenGov/eurostat},
##   }
{% endhighlight %}





{% highlight r %}
sessionInfo() 
{% endhighlight %}



{% highlight text %}
## R version 3.2.0 (2015-04-16)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 14.04.2 LTS
## 
## locale:
##  [1] LC_CTYPE=en_GB.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_GB.UTF-8        LC_COLLATE=en_GB.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_GB.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  methods  
## [8] base     
## 
## other attached packages:
##  [1] dplyr_0.4.1      mapproj_1.2-2    maps_2.3-9       scales_0.2.4    
##  [5] stringr_1.0.0    rgeos_0.3-8      maptools_0.8-36  rgdal_0.9-2     
##  [9] sp_1.1-0         tidyr_0.2.0      ggplot2_1.0.1    countrycode_0.18
## [13] eurostat_1.0.16  knitr_1.10      
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.11.6      magrittr_1.5     MASS_7.3-39      munsell_0.4.2   
##  [5] colorspace_1.2-6 lattice_0.20-31  highr_0.5        plyr_1.8.2      
##  [9] tools_3.2.0      parallel_3.2.0   gtable_0.1.2     DBI_0.3.1       
## [13] lazyeval_0.1.10  assertthat_0.1   digest_0.6.8     reshape2_1.4.1  
## [17] formatR_1.2      codetools_0.2-11 evaluate_0.7     labeling_0.3    
## [21] stringi_0.4-1    foreign_0.8-63   proto_0.3-10
{% endhighlight %}




[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
