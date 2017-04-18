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
knitr::kable(as.data.frame(ls("package:eurostat")))
{% endhighlight %}



|ls("package:eurostat")  |
|:-----------------------|
|clean_eurostat_cache    |
|cut_to_classes          |
|dic_order               |
|ea_countries            |
|efta_countries          |
|eu_candidate_countries  |
|eu_countries            |
|eurotime2date           |
|eurotime2num            |
|get_eurostat            |
|get_eurostat_dic        |
|get_eurostat_geospatial |
|get_eurostat_json       |
|get_eurostat_toc        |
|grepEurostatTOC         |
|harmonize_country_code  |
|label_eurostat          |
|label_eurostat_tables   |
|label_eurostat_vars     |
|merge_eurostat_geodata  |
|search_eurostat         |


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



|title                                                                                                               |code        |type    |last update of data |last table structure change |data start |data end |values |
|:-------------------------------------------------------------------------------------------------------------------|:-----------|:-------|:-------------------|:---------------------------|:----------|:--------|:------|
|Share of housing cost in disposable income by level of activity limitation, sex and age                             |hlth_dhc050 |dataset |07.03.2017          |07.03.2017                  |2005       |2015     |NA     |
|Gini coefficient of equivalised disposable income - EU-SILC survey                                                  |ilc_di12    |dataset |28.03.2017          |31.01.2017                  |1995       |2016     |NA     |
|Gini coefficient of equivalised disposable income before social transfers (pensions included in social transfers)   |ilc_di12b   |dataset |28.03.2017          |31.01.2017                  |2003       |2016     |NA     |
|Gini coefficient of equivalised disposable income before social transfers (pensions excluded from social transfers) |ilc_di12c   |dataset |28.03.2017          |31.01.2017                  |2003       |2016     |NA     |

Or you can also download the whole table of contents of the database with `get_eurostat_toc`-function. In both cases the *values* in column `code` should be used to download a selected dataset.


{% highlight r %}
toc <- get_eurostat_toc()
# print the first 6 rows
kable(head(toc))
{% endhighlight %}



|title                                                    |code      |type    |last update of data |last table structure change |data start |data end |values |
|:--------------------------------------------------------|:---------|:-------|:-------------------|:---------------------------|:----------|:--------|:------|
|Database by themes                                       |data      |folder  |NA                  |NA                          |NA         |NA       |NA     |
|General and regional statistics                          |general   |folder  |NA                  |NA                          |NA         |NA       |NA     |
|European and national indicators for short-term analysis |euroind   |folder  |NA                  |NA                          |NA         |NA       |NA     |
|Business and consumer surveys (source: DG ECFIN)         |ei_bcs    |folder  |NA                  |NA                          |NA         |NA       |NA     |
|Consumer surveys (source: DG ECFIN)                      |ei_bcs_cs |folder  |NA                  |NA                          |NA         |NA       |NA     |
|Consumers - monthly data                                 |ei_bsco_m |dataset |30.03.2017          |30.03.2017                  |1980M01    |2017M03  |NA     |

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
# Select only countries starting with F letter
dat <- dat[grepl("^C", dat$countryname),]
kable(head(dat))
{% endhighlight %}



|unit     |na_item |geo  | time| values|cntry |countryname    |
|:--------|:-------|:----|----:|------:|:-----|:--------------|
|PPCS_HAB |B6N     |CY00 | 2003|  11900|CY    |Cyprus         |
|PPCS_HAB |B6N     |CZ01 | 2003|  11300|CZ    |Czech Republic |
|PPCS_HAB |B6N     |CZ02 | 2003|   9100|CZ    |Czech Republic |
|PPCS_HAB |B6N     |CZ03 | 2003|   8100|CZ    |Czech Republic |
|PPCS_HAB |B6N     |CZ04 | 2003|   7400|CZ    |Czech Republic |
|PPCS_HAB |B6N     |CZ05 | 2003|   7800|CZ    |Czech Republic |

Then we plot the data at the regional level and color the lines using country names derived from [`countrycode`](http://cran.r-project.org/web/packages/countrycode/index.html)-package.



{% highlight r %}
library(ggplot2)
p <- ggplot(dat, aes(x=time,y=values,group=geo,color=countryname))
p <- p + geom_point() + geom_line()
# Add the region names at the end of each line
# p <- p + geom_text(data=merge(dat, aggregate(time ~ geo, dat, max), 
#                               by=c("time","geo")), 
#                    aes(x=time, y = values, label=geo), hjust=-0.5,vjust=-1,size=3)
p <- p + geom_label(data=dat %>%  group_by(geo) %>% na.omit() %>% 
                     filter(time %in% c(min(time),max(time))),
                   aes(fill=countryname,label=geo),color="white", alpha=.3, show.legend = F)
p <- p + labs(x="Year", y="Disposable income of private households (€ per year)")
# Place the legend with country names on top in three rows
p <- p + theme(legend.position = "top")
p <- p + guides(color = guide_legend(title = "Country",
                                     title.position = "top", 
                                     title.hjust=.5,
                                     nrow=1,
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



|unit     |na_item |geo  | time| values|
|:--------|:-------|:----|----:|------:|
|PPCS_HAB |B6N     |CY00 | 2003|  11900|
|PPCS_HAB |B6N     |CZ01 | 2003|  11300|
|PPCS_HAB |B6N     |CZ02 | 2003|   9100|
|PPCS_HAB |B6N     |CZ03 | 2003|   8100|
|PPCS_HAB |B6N     |CZ04 | 2003|   7400|
|PPCS_HAB |B6N     |CZ05 | 2003|   7800|

Labeling the data based on definitions from dictionary:


{% highlight r %}
# apply the definitions from dictionary
datl <- label_eurostat(dat)
# Labeled data
kable(head(datl))
{% endhighlight %}



|unit                                                                |na_item                |geo           | time| values|
|:-------------------------------------------------------------------|:----------------------|:-------------|----:|------:|
|Purchasing power standard based on final consumption per inhabitant |Disposable income, net |Kypros        | 2003|  11900|
|Purchasing power standard based on final consumption per inhabitant |Disposable income, net |Praha         | 2003|  11300|
|Purchasing power standard based on final consumption per inhabitant |Disposable income, net |Strední Cechy | 2003|   9100|
|Purchasing power standard based on final consumption per inhabitant |Disposable income, net |Jihozápad     | 2003|   8100|
|Purchasing power standard based on final consumption per inhabitant |Disposable income, net |Severozápad   | 2003|   7400|
|Purchasing power standard based on final consumption per inhabitant |Disposable income, net |Severovýchod  | 2003|   7800|



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
p <- p + ggrepel::geom_text_repel(data=merge(datl3, aggregate(time ~ geo, datl3, max), 
                              by=c("time","geo")), 
                   aes(x=time, y = values, label=geo), nudge_y=1,size=3)
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

First, we shall retrieve the nuts2-level figures of variable `tgs00026` (Disposable income of private households by NUTS 2 regions) and filter out only the year 2011.


{% highlight r %}
library(eurostat)
df <- get_eurostat("tgs00026", time_format = "raw")
# convert time column from Date to numeric
df$time <- eurotime2num(df$time)
# subset time to have data for 2011
df <- df[df$time== 2011,]
{% endhighlight %}

Second, we use `cut_to_classes`-function to classify our numeric `values` for the choropleth map.


{% highlight r %}
df$value_cat <- cut_to_classes(df$values, n = 5)
{% endhighlight %}

Third, we use `merge_eurostat_geospatial`-function to download the shapefile at 1:60 million resolution from year 2010 and merge it with our Eurostat attribute data.



{% highlight r %}
map.df <- merge_eurostat_geodata(data = df, geocolumn = "geo", resolution = "60", all_regions = TRUE, output_class = "df")
{% endhighlight %}

### Plotting the maps using ggplot2


{% highlight r %}
library(ggplot2)
library(scales)
library(grid)

# Loop over the three years
p <- ggplot(data=map.df, aes(long,lat,group=group))
p <- p + geom_polygon(data = map.df, aes(long,lat),fill=NA,colour="white",size = 1)
p <- p + geom_polygon(aes(fill = value_cat),colour="dim grey",size=.2)
p <- p + scale_fill_manual(values=c("#d7191c","#fdae61","#ffffbf","#a6d96a","#1a9641")) 
p <- p + coord_map(project="orthographic", xlim=c(-22,34), ylim=c(35,70))
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
p <- p + guides(fill = guide_legend(title = "€ per Year",
                                   title.position = "top", 
                                   title.hjust=0))
p <- p + labs(title = "Disposable household incomes in  2011")
print(p)
{% endhighlight %}

![center](/figs/2015-04-14-eurostat-package-examples/eurostat_map4-1.png)

We are done! That was a small exercise on how to use the main functions in the `eurostat`-package. We hope you find the package useful! All suggestions, bug reports, and contributions are warmly welcome at: <https://github.com/ropengov/eurostat>. When using the packages, please cite accordingly:


{% highlight r %}
citation("eurostat")
{% endhighlight %}



{% highlight text %}
## 
## Kindly cite the eurostat R package as follows:
## 
##   (C) Leo Lahti, Janne Huovari, Markus Kainu, Przemyslaw Biecek. R
##   Journal 2017. Accepted for publication. Retrieval and analysis
##   of Eurostat open data with the eurostat package R package
##   version 3.1.100091 Package URL:
##   http://ropengov.github.io/eurostat Manuscript preprint URL:
##   https://journal.r-project.org/archive/2017/RJ-2017-019/index.html
## 
## A BibTeX entry for LaTeX users is
## 
##   @Misc{,
##     title = {eurostat R package},
##     author = {Leo Lahti and Janne Huovari and Markus Kainu and Przemyslaw Biecek},
##     journal = {R Journal. Accepted for publication. Preprint available on-line.},
##     year = {2017},
##     url = {https://journal.r-project.org/archive/2017/RJ-2017-019/index.html},
##     note = {R package version 3.1.100091},
##   }
{% endhighlight %}





{% highlight r %}
sessionInfo() 
{% endhighlight %}



{% highlight text %}
## R version 3.3.2 (2016-10-31)
## Platform: x86_64-pc-linux-gnu (64-bit)
## Running under: Ubuntu 16.04.2 LTS
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
##  [3] LC_TIME=de_BE.UTF-8        LC_COLLATE=en_US.UTF-8    
##  [5] LC_MONETARY=de_BE.UTF-8    LC_MESSAGES=en_US.UTF-8   
##  [7] LC_PAPER=de_BE.UTF-8       LC_NAME=C                 
##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
## [11] LC_MEASUREMENT=de_BE.UTF-8 LC_IDENTIFICATION=C       
## 
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  methods  
## [8] base     
## 
## other attached packages:
##  [1] scales_0.4.1        stringr_1.2.0       rgeos_0.3-22       
##  [4] maptools_0.9-1      rgdal_1.2-5         sp_1.2-4           
##  [7] dplyr_0.5.0         tidyr_0.6.1         countrycode_0.18   
## [10] ggplot2_2.2.1       eurostat_3.1.100091 knitr_1.15.1       
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.10       RColorBrewer_1.1-2 highr_0.6         
##  [4] plyr_1.8.4         class_7.3-14       tools_3.3.2       
##  [7] digest_0.6.12      jsonlite_1.3       evaluate_0.10     
## [10] tibble_1.3.0       gtable_0.2.0       lattice_0.20-34   
## [13] DBI_0.6            mapproj_1.2-4      ggrepel_0.6.9     
## [16] e1071_1.6-8        httr_1.2.1         maps_3.1.1        
## [19] hms_0.3            classInt_0.1-23    R6_2.2.0          
## [22] foreign_0.8-67     readr_1.1.0        magrittr_1.5      
## [25] assertthat_0.1     colorspace_1.3-2   labeling_0.3      
## [28] stringi_1.1.5      lazyeval_0.2.0     munsell_0.4.3
{% endhighlight %}




[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
