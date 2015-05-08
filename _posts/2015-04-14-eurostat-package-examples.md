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
kable(as.data.frame(ls("package:eurostat")))
{% endhighlight %}



{% highlight text %}
## Error in as.environment(pos): no item called "package:eurostat" on the search list
{% endhighlight %}


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
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "search_eurostat"
{% endhighlight %}



{% highlight r %}
# print the first 6 rows
kable(head(results))
{% endhighlight %}



{% highlight text %}
## Error in head(results): object 'results' not found
{% endhighlight %}

Or you can also download the whole table of contents of the database with `get_eurostat_toc`-function. In both cases the *values* in column `code` should be used to download a selected dataset.


{% highlight r %}
toc <- get_eurostat_toc()
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "get_eurostat_toc"
{% endhighlight %}



{% highlight r %}
# print the first 6 rows
kable(head(toc))
{% endhighlight %}



{% highlight text %}
## Error in head(toc): object 'toc' not found
{% endhighlight %}

## Downloading and plotting time-series data at the NUTS2 regional level

However, we are interested in the disposable household income and first we download the data and convert the time column into numeric format.


{% highlight r %}
library(eurostat)
{% endhighlight %}



{% highlight text %}
## Error in library(eurostat): there is no package called 'eurostat'
{% endhighlight %}



{% highlight r %}
# Clean the cache first
clean_eurostat_cache()
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "clean_eurostat_cache"
{% endhighlight %}



{% highlight r %}
# Download the income variable
dat <- get_eurostat("tgs00026", time_format = "raw")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "get_eurostat"
{% endhighlight %}



{% highlight r %}
# Extract the information on country in question. (First two character in region string mark the country)
dat$cntry <- substr(dat$geo, 1,2)
{% endhighlight %}



{% highlight text %}
## Error in substr(dat$geo, 1, 2): object 'dat' not found
{% endhighlight %}



{% highlight r %}
# Create the variable for proper countrynames using countryname-package
library(countrycode)
{% endhighlight %}



{% highlight text %}
## Error in library(countrycode): there is no package called 'countrycode'
{% endhighlight %}



{% highlight r %}
dat$countryname <- countrycode(dat$cntry, "iso2c", "country.name")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "countrycode"
{% endhighlight %}



{% highlight r %}
# convert time column from Date to numeric
dat$time <- eurotime2num(dat$time)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "eurotime2num"
{% endhighlight %}



{% highlight r %}
kable(head(dat))
{% endhighlight %}



{% highlight text %}
## Error in head(dat): object 'dat' not found
{% endhighlight %}

Then we plot the data at the regional level and color the lines using country names derived from [`countrycode`](http://cran.r-project.org/web/packages/countrycode/index.html)-package.



{% highlight r %}
library(ggplot2)
p <- ggplot(dat, aes(x=time,y=values,group=geo,color=countryname))
{% endhighlight %}



{% highlight text %}
## Error in ggplot(dat, aes(x = time, y = values, group = geo, color = countryname)): object 'dat' not found
{% endhighlight %}



{% highlight r %}
p <- p + geom_point() + geom_line()
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
# Add the region names at the end of each line
p <- p + geom_text(data=merge(dat, aggregate(time ~ geo, dat, max), 
                              by=c("time","geo")), 
                   aes(x=time, y = values, label=geo), hjust=-0.5,vjust=-1,size=3)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + labs(x="Year", y="Disposable income of private households (€ per year)")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
# Place the legend with country names on top in three rows
p <- p + theme(legend.direction = "horizontal", legend.position = "top")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + guides(color = guide_legend(title = "Country",
                                     title.position = "top", 
                                     title.hjust=.5,
                                     nrow=3,
                                     byrow=TRUE))
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}

### Labelling the data

Function `label_eurostat` provides a straighforward way to convert the codes in data into more meaningful labels. The `label_eurostat` function requires that the data is in the "default format" with no added columns. First, check unlabeled example data:


{% highlight r %}
# First, remove the cntry and countrycode columns that were added manually
cntry_cols <- dat[ , names(dat) %in% c("cntry","countryname")]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'dat' not found
{% endhighlight %}



{% highlight r %}
dat <- dat[ , !names(dat) %in% c("cntry","countryname")]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'dat' not found
{% endhighlight %}



{% highlight r %}
# Unlabeled data
kable(head(dat))
{% endhighlight %}



{% highlight text %}
## Error in head(dat): object 'dat' not found
{% endhighlight %}

Labeling the data based on definitions from dictionary:


{% highlight r %}
# apply the definitions from dictionary
datl <- label_eurostat(dat)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "label_eurostat"
{% endhighlight %}



{% highlight r %}
# Labeled data
kable(head(datl))
{% endhighlight %}



{% highlight text %}
## Error in head(datl): object 'datl' not found
{% endhighlight %}



{% highlight r %}
# Bind the country name columns back to the labelled data 
datl2 <- cbind(datl,cntry_cols)
{% endhighlight %}



{% highlight text %}
## Error in cbind(datl, cntry_cols): object 'datl' not found
{% endhighlight %}

For clarity, we plot first four countries in alphabetical order in their own facets with region names.


{% highlight r %}
# subset the first 4 countries in albhabetical order
datl3 <- datl2[datl2$countryname %in% sort(unique(datl2$countryname))[1:4],]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'datl2' not found
{% endhighlight %}



{% highlight r %}
# plot the data using country facets
library(ggplot2)
p <- ggplot(datl3,aes(x=time,y=values,group=geo))
{% endhighlight %}



{% highlight text %}
## Error in ggplot(datl3, aes(x = time, y = values, group = geo)): object 'datl3' not found
{% endhighlight %}



{% highlight r %}
p <- p + geom_point(color="grey") + geom_line(color="grey")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + geom_text(data=merge(datl3, aggregate(time ~ geo, datl3, max), 
                              by=c("time","geo")), 
                   aes(x=time, y = values, label=geo), vjust=1,size=3)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + coord_cartesian(xlim=c(min(datl2$time):max(datl2$time)+3))
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + facet_wrap(~countryname, scales = "free", ncol = 1)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + labs(title=paste0(unique(datl3$indic_na),"\n(",unique(datl3$unit),")"),
                x="Year",y="Disposable income of private households (€ per year)")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}

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
{% endhighlight %}



{% highlight text %}
## Error in library(eurostat): there is no package called 'eurostat'
{% endhighlight %}



{% highlight r %}
df <- get_eurostat("tgs00026", time_format = "raw")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "get_eurostat"
{% endhighlight %}



{% highlight r %}
# convert time column from Date to numeric
df$time <- eurotime2num(df$time)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): could not find function "eurotime2num"
{% endhighlight %}



{% highlight r %}
# subset time to have data for 2000, 2005 and 2011
df <- df[df$time %in% c(2000,2005,2011),]
{% endhighlight %}



{% highlight text %}
## Error in df$time: object of type 'closure' is not subsettable
{% endhighlight %}



{% highlight r %}
# spread the data into wide format
library(tidyr)
dw <- spread(df, time, values)
{% endhighlight %}



{% highlight text %}
## Error in UseMethod("spread_"): no applicable method for 'spread_' applied to an object of class "function"
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
## Error in eval(expr, envir, enclos): object 'dw' not found
{% endhighlight %}



{% highlight r %}
# Spatial dataframe has 467 rows and attribute data 275.
# We need to make attribute data to have similar number of rows
NUTS_ID <- as.character(map_nuts2$NUTS_ID)
VarX <- rep(NA, 316)
dat <- data.frame(NUTS_ID,VarX)
# then we shall merge this with Eurostat data.frame
dat2 <- merge(dat,dw,by.x="NUTS_ID",by.y="geo", all.x=TRUE)
{% endhighlight %}



{% highlight text %}
## Error in merge(dat, dw, by.x = "NUTS_ID", by.y = "geo", all.x = TRUE): error in evaluating the argument 'y' in selecting a method for function 'merge': Error: object 'dw' not found
{% endhighlight %}



{% highlight r %}
## merge this manipulated attribute data with the spatialpolygondataframe
## rownames
row.names(dat2) <- dat2$NUTS_ID
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'dat2' not found
{% endhighlight %}



{% highlight r %}
row.names(map_nuts2) <- as.character(map_nuts2$NUTS_ID)
## order data
dat2 <- dat2[order(row.names(dat2)), ]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'dat2' not found
{% endhighlight %}



{% highlight r %}
map_nuts2 <- map_nuts2[order(row.names(map_nuts2)), ]
## join
library(maptools)
dat2$NUTS_ID <- NULL
{% endhighlight %}



{% highlight text %}
## Error in dat2$NUTS_ID <- NULL: object 'dat2' not found
{% endhighlight %}



{% highlight r %}
shape <- spCbind(map_nuts2, dat2)
{% endhighlight %}



{% highlight text %}
## Error in spCbind(map_nuts2, dat2): error in evaluating the argument 'x' in selecting a method for function 'spCbind': Error: object 'dat2' not found
{% endhighlight %}

### Preparing the data for ggplot2 visualization

As we are using ggplot2-package for plotting, we have to fortify the `SpatialPolygonDataFrame` into regular `data.frame`-class. As we have income data from several years, we have to also `gather` the data into long format for plotting.


{% highlight r %}
## fortify spatialpolygondataframe into data.frame
library(ggplot2)
library(rgeos)
shape$id <- rownames(shape@data)
{% endhighlight %}



{% highlight text %}
## Error in rownames(shape@data): object 'shape' not found
{% endhighlight %}



{% highlight r %}
map.points <- fortify(shape, region = "id")
{% endhighlight %}



{% highlight text %}
## Error in fortify(shape, region = "id"): object 'shape' not found
{% endhighlight %}



{% highlight r %}
map.df <- merge(map.points, shape, by = "id")
{% endhighlight %}



{% highlight text %}
## Error in merge(map.points, shape, by = "id"): error in evaluating the argument 'x' in selecting a method for function 'merge': Error: object 'map.points' not found
{% endhighlight %}



{% highlight r %}
# As we want to plot map faceted by years from 2003 to 2011
# we have to melt it into long format

# (variable with numerical names got X-prefix during the spCbind-merge,
# therefore the X-prefix in variable names)
library(tidyr)
# lets convert unit variable (that is a list) into character
map.df$unit <- as.character(map.df$unit)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'map.df' not found
{% endhighlight %}



{% highlight r %}
map.df.l <- gather(map.df, "year", "value", 15:17)
{% endhighlight %}



{% highlight text %}
## Error in setNames(as.list(seq_along(vars)), vars): object 'map.df' not found
{% endhighlight %}



{% highlight r %}
# year variable (variable) is class string and type X20xx.
# Lets remove the X and convert it to numerical
library(stringr)
map.df.l$year <- str_replace_all(map.df.l$year, "X","")
{% endhighlight %}



{% highlight text %}
## Error in check_string(string): object 'map.df.l' not found
{% endhighlight %}



{% highlight r %}
map.df.l$year <- factor(map.df.l$year)
{% endhighlight %}



{% highlight text %}
## Error in factor(map.df.l$year): object 'map.df.l' not found
{% endhighlight %}



{% highlight r %}
map.df.l$year <- as.numeric(levels(map.df.l$year))[map.df.l$year]
{% endhighlight %}



{% highlight text %}
## Error in levels(map.df.l$year): object 'map.df.l' not found
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
{% endhighlight %}



{% highlight text %}
## Error in unique(map.df.l$year): object 'map.df.l' not found
{% endhighlight %}



{% highlight r %}
# Loop over the three years
for (year in years) {
  
  # subset data
  plot_map <- map.df.l[map.df.l$year == year,]
  # set the breaks
  plot_map$value_cat <- categories(plot_map$value)
  
  p <- ggplot(data=plot_map, aes(long,lat,group=group))
  p <- p + geom_polygon(data = map.df.l, aes(long,lat),fill=NA,colour="white",size = .7)
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



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'years' not found
{% endhighlight %}

We are done! That was a small exercise on how to use the main functions in the `eurostat`-package. We hope you find the package useful! All suggestions, bug reports, and contributions are warmly welcome at: <https://github.com/ropengov/eurostat>. When using the packages, please cite accordingly:


{% highlight r %}
citation("eurostat")
{% endhighlight %}



{% highlight text %}
## Error in citation("eurostat"): package 'eurostat' not found
{% endhighlight %}





{% highlight r %}
sessionInfo() 
{% endhighlight %}



{% highlight text %}
## R version 3.2.0 (2015-04-16)
## Platform: x86_64-unknown-linux-gnu (64-bit)
## Running under: Ubuntu 14.10
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  methods  
## [8] base     
## 
## other attached packages:
## [1] scales_0.2.4    stringr_0.6.2   rgeos_0.3-8     maptools_0.8-34
## [5] rgdal_0.9-2     sp_1.0-17       tidyr_0.2.0     ggplot2_1.0.1  
## [9] knitr_1.9      
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.11.5      magrittr_1.5     MASS_7.3-40      munsell_0.4.2   
##  [5] colorspace_1.2-6 lattice_0.20-31  plyr_1.8.2       dplyr_0.4.1     
##  [9] tools_3.2.0      parallel_3.2.0   gtable_0.1.2     DBI_0.3.1       
## [13] lazyeval_0.1.10  digest_0.6.8     assertthat_0.1   reshape2_1.4.1  
## [17] formatR_1.2      codetools_0.2-11 evaluate_0.7     foreign_0.8-63  
## [21] proto_0.3-10
{% endhighlight %}




[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
