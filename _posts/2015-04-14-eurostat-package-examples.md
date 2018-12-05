---
title: "Searching, downloading and manipulating Eurostat data with R"
author:
  image: markus.jpg
  name: Markus Kainu
date: "2015-05-01 12:53:45"
draft: no
excerpt: New package eurostat released in CRAN
layout: post
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
{% endhighlight %}



{% highlight text %}
## Error in library(eurostat): there is no package called 'eurostat'
{% endhighlight %}



{% highlight r %}
knitr::kable(as.data.frame(ls("package:eurostat")))
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
{% endhighlight %}



{% highlight text %}
## Error in contrib.url(repos, type): trying to use CRAN without setting a mirror
{% endhighlight %}



{% highlight r %}
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
## Error in search_eurostat("disposable income", type = "dataset"): could not find function "search_eurostat"
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
## Error in get_eurostat_toc(): could not find function "get_eurostat_toc"
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
## Error in clean_eurostat_cache(): could not find function "clean_eurostat_cache"
{% endhighlight %}



{% highlight r %}
# Download the income variable
dat <- get_eurostat("tgs00026", time_format = "raw")
{% endhighlight %}



{% highlight text %}
## Error in get_eurostat("tgs00026", time_format = "raw"): could not find function "get_eurostat"
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
dat$countryname <- countrycode(dat$cntry, "iso2c", "country.name")
{% endhighlight %}



{% highlight text %}
## Error in mode(sourcevar): object 'dat' not found
{% endhighlight %}



{% highlight r %}
# convert time column from Date to numeric
dat$time <- eurotime2num(dat$time)
{% endhighlight %}



{% highlight text %}
## Error in eurotime2num(dat$time): could not find function "eurotime2num"
{% endhighlight %}



{% highlight r %}
# Select only countries starting with F letter
dat <- dat[grepl("^C", dat$countryname),]
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'dat' not found
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
# p <- p + geom_text(data=merge(dat, aggregate(time ~ geo, dat, max), 
#                               by=c("time","geo")), 
#                    aes(x=time, y = values, label=geo), hjust=-0.5,vjust=-1,size=3)
p <- p + geom_label(data=dat %>%  group_by(geo) %>% na.omit() %>% 
                     filter(time %in% c(min(time),max(time))),
                   aes(fill=countryname,label=geo),color="white", alpha=.3, show.legend = F)
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
p <- p + theme(legend.position = "top")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + guides(color = guide_legend(title = "Country",
                                     title.position = "top", 
                                     title.hjust=.5,
                                     nrow=1,
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
## Error in label_eurostat(dat): could not find function "label_eurostat"
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
p <- p + ggrepel::geom_text_repel(data=merge(datl3, aggregate(time ~ geo, datl3, max), 
                              by=c("time","geo")), 
                   aes(x=time, y = values, label=geo), nudge_y=1,size=3)
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

First, we shall retrieve the nuts2-level figures of variable `tgs00026` (Disposable income of private households by NUTS 2 regions) and filter out only the year 2011.


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
## Error in get_eurostat("tgs00026", time_format = "raw"): could not find function "get_eurostat"
{% endhighlight %}



{% highlight r %}
# convert time column from Date to numeric
df$time <- eurotime2num(df$time)
{% endhighlight %}



{% highlight text %}
## Error in eurotime2num(df$time): could not find function "eurotime2num"
{% endhighlight %}



{% highlight r %}
# subset time to have data for 2011
df <- df[df$time== 2011,]
{% endhighlight %}



{% highlight text %}
## Error in df$time: object of type 'closure' is not subsettable
{% endhighlight %}

Second, we use `cut_to_classes`-function to classify our numeric `values` for the choropleth map.


{% highlight r %}
df$value_cat <- cut_to_classes(df$values, n = 5)
{% endhighlight %}



{% highlight text %}
## Error in cut_to_classes(df$values, n = 5): could not find function "cut_to_classes"
{% endhighlight %}

Third, we use `merge_eurostat_geospatial`-function to download the shapefile at 1:60 million resolution from year 2010 and merge it with our Eurostat attribute data.



{% highlight r %}
map.df <- merge_eurostat_geodata(data = df, geocolumn = "geo", resolution = "60", all_regions = TRUE, output_class = "df")
{% endhighlight %}



{% highlight text %}
## Error in merge_eurostat_geodata(data = df, geocolumn = "geo", resolution = "60", : could not find function "merge_eurostat_geodata"
{% endhighlight %}

### Plotting the maps using ggplot2


{% highlight r %}
library(ggplot2)
library(scales)
library(grid)

# Loop over the three years
p <- ggplot(data=map.df, aes(long,lat,group=group))
{% endhighlight %}



{% highlight text %}
## Error in ggplot(data = map.df, aes(long, lat, group = group)): object 'map.df' not found
{% endhighlight %}



{% highlight r %}
p <- p + geom_polygon(data = map.df, aes(long,lat),fill=NA,colour="white",size = 1)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + geom_polygon(aes(fill = value_cat),colour="dim grey",size=.2)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + scale_fill_manual(values=c("#d7191c","#fdae61","#ffffbf","#a6d96a","#1a9641")) 
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + coord_map(project="orthographic", xlim=c(-22,34), ylim=c(35,70))
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p +  theme(legend.position = c(0.1,0.40), 
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
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + guides(fill = guide_legend(title = "€ per Year",
                                   title.position = "top", 
                                   title.hjust=0))
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
p <- p + labs(title = "Disposable household incomes in  2011")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'p' not found
{% endhighlight %}



{% highlight r %}
print(p)
{% endhighlight %}



{% highlight text %}
## Error in print(p): object 'p' not found
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
## R version 3.5.1 (2018-07-02)
## Platform: x86_64-suse-linux-gnu (64-bit)
## Running under: openSUSE Tumbleweed
## 
## Matrix products: default
## BLAS: /usr/lib64/R/lib/libRblas.so
## LAPACK: /usr/lib64/R/lib/libRlapack.so
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=C                  LC_COLLATE=fi_FI.UTF-8    
##  [5] LC_MONETARY=fi_FI.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=fi_FI.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  methods  
## [8] base     
## 
## other attached packages:
##  [1] scales_1.0.0      rgeos_0.4-2       maptools_0.9-4   
##  [4] rgdal_1.3-6       sp_1.3-1          dplyr_0.7.8      
##  [7] tidyr_0.8.2       countrycode_1.1.0 ggplot2_3.1.0    
## [10] stringr_1.3.1     reshape2_1.4.3    knitr_1.20       
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.0       bindr_0.1.1      magrittr_1.5     tidyselect_0.2.5
##  [5] munsell_0.5.0    lattice_0.20-35  colorspace_1.3-2 R6_2.3.0        
##  [9] rlang_0.3.0.1    plyr_1.8.4       tools_3.5.1      gtable_0.2.0    
## [13] withr_2.1.2      lazyeval_0.2.1   assertthat_0.2.0 tibble_1.4.2    
## [17] crayon_1.3.4     bindrcpp_0.2.2   purrr_0.2.5      glue_1.3.0      
## [21] evaluate_0.12    stringi_1.2.4    compiler_3.5.1   pillar_1.3.0    
## [25] foreign_0.8-70   pkgconfig_2.0.2
{% endhighlight %}




[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
