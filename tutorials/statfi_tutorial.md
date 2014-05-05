---
title: statfi vignette
layout: tutorial_page
package_name: statfi
package_name_show: statfi
author: Leo Lahti, Juuso Parkkinen, Joona Lehtomaki
meta_description: Statistics Finland (Tilastokeskus) Open Data R Tools
github_user: ropengov
package_version: 0.9.7
header_descripton: Statistics Finland (Tilastokeskus) Open Data R Tools
---



Statistics Finland (Tilastokeskus) R tools
===========

This R package provides tools to access open data from [Statistics
Finland](http://www.stat.fi/tup/tilastotietokannat/index_fi.html),
including about 3000 data sets from [Statistics
Finland](http://www.stat.fi/org/lainsaadanto/avoin_data.html). 

This R package is part of the [rOpenGov](http://ropengov.github.io)
project.


## Installation

Release version for general use:


{% highlight r %}
install.packages("statfi")
library(statfi)
{% endhighlight %}


Development version (potentially unstable):


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("statfi", "ropengov")
library(statfi)
{% endhighlight %}



## Available data sets

The listings of [Statistics Finland (StatFi) open
data](http://www.stat.fi/org/lainsaadanto/avoin_data.html) are
available for browsing in PCAxis, CSV and XML format. These include
the following data collections:

 * StatFi [PCAxis](http://pxweb2.stat.fi/database/StatFin/databasetree_fi.asp) [CSV](http://pxweb2.stat.fi/database/StatFin/StatFin_rap_csv.csv) [XML](http://pxweb2.stat.fi/database/StatFin/StatFin_rap_xml.csv)  
 * Eurostat [PCAxis](http://pxweb2.stat.fi/Database/Eurostat/databasetree_fi.asp) [CSV](http://pxweb2.stat.fi/database/StatFin/StatFin_rap.csv)  
 * International statistics [PC Axis](http://pxweb2.stat.fi/Database/Kansainvalisen_tiedon_tietokanta/databasetree_fi.asp)

In summary, browse these listings to find the URL for your data set of
interest. Then use the get_statfi function to download the data in
R. For examples, see below.

### Listing the data sets in R

Download statfi open data listings in R as follows:


{% highlight r %}
# Load the library
library(statfi)

# Statistics Finland open data listing
datasets.statfi <- list_statfi_files()

# Descriptions of the first entries
head(datasets.statfi$DESCRIPTION)
{% endhighlight %}



{% highlight text %}
## [1] "Asuntokunnat koon ja asunnon talotyypin mukaan 1985-2012"                                 
## [2] "Asuntokunnat ja asuntoväestö asuntokunnan koon, huoneluvun ja talotyypin mukaan 2005-2012"
## [3] "Asuntokunnat ja asuntoväestö asumisväljyyden mukaan 1989-2012"                            
## [4] "Asuntokunnat koon, vanhimman iän ja sukupuolen sekä talotyypin mukaan 2005-2012"          
## [5] "Asuntokunnat ja asuntoväestö asuntokunnan koon ja hallintaperusteen mukaan 2005-2012"     
## [6] "Asunnot (lkm) talotyypin, käytössäolon ja rakennusvuoden mukaan 31.12.2012"
{% endhighlight %}



{% highlight r %}

# Investigate the first entry in StatFi data
print(datasets.statfi[1, ])
{% endhighlight %}



{% highlight text %}
##                                                                  File
## 1 http://pxweb2.stat.fi/database/StatFin/asu/asas/010_asas_tau_101.px
##      size          created          updated variables
## 1 1230502 2012-02-13 12:27 2014-04-02 16:58         4
##                  tablesize     type LANGUAGE
## 1 (321x8x5) x 28 = 359520  Maksuton       fi
##                                                                  TITLE
## 1 Asuntokunnat muuttujina Alue, Asuntokunnan koko, Talotyyppi ja Vuosi
##                                                DESCRIPTION
## 1 Asuntokunnat koon ja asunnon talotyypin mukaan 1985-2012
{% endhighlight %}


This provides the list of statfi data sets. For other international
open statistics available via Statfi, [browse the data sets
manually](http://pxweb2.stat.fi/Database/Kansainvalisen_tiedon_tietokanta/databasetree_fi.asp)
to find the URL for your dataset of interest. For Eurostat data, we
recommend the [eurostat](http://github.com/ropengov/eurostat) R
package.


## Retrieving the data

Retrieve data from Statfi by defining URL of the data set. For the
listing of available data sets and their corresponding URLs, see
above.


{% highlight r %}
library(statfi)

# Define URL (see list_statfi_files() or browse manually as described above)
url <- "http://pxweb2.stat.fi/Database/StatFin/tul/tvt/2009/120_tvt_2009_2011-02-18_tau_112_fi.px"

# Download the data
df <- get_statfi(url)
df[1:3, ]
{% endhighlight %}



{% highlight text %}
##                           Tiedot    Kunta Vuosi     dat
## 1                    Tulonsaajia Koko maa  2005 4314900
## 2 Veronalaiset tulot keskimäärin Koko maa  2005   21695
## 3   Veronalaiset tulot, mediaani Koko maa  2005   17793
{% endhighlight %}



## Licensing and Citations

### Citing the Data

Regarding the data, kindly cite [Statfi](http://www.statfi.fi/). We
are grateful to Statistics Finland open data personnell for their
support during the R package development.

### Citing the R package

This work can be freely used, modified and distributed under the
[Two-clause FreeBSD
license](http://en.wikipedia.org/wiki/BSD\_licenses). Kindly cite the
R package as 'Leo Lahti, Juuso Parkkinen ja Joona Lehtomäki (C)
2010-2014. statfi R package. URL: http://ropengov.github.io/statfi'.


### Session info

This tutorial was created with


{% highlight r %}
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.0.2 (2013-09-25)
## Platform: x86_64-suse-linux-gnu (64-bit)
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
## [1] methods   stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
##  [1] statfi_0.9.7    pxR_0.29        stringr_0.6.2   sotkanet_0.9.05
##  [5] sorvi_0.4.25    helsinki_0.9.13 RCurl_1.95-4.1  bitops_1.0-6   
##  [9] rjson_0.2.13    ggplot2_0.9.3.1 rgeos_0.3-4     maptools_0.8-29
## [13] fingis_0.9.10   rgdal_0.8-16    sp_1.0-15       knitr_1.5      
## 
## loaded via a namespace (and not attached):
##  [1] boot_1.3-9         coda_0.16-1        colorspace_1.2-4  
##  [4] deldir_0.1-5       dichromat_2.0-0    digest_0.6.4      
##  [7] evaluate_0.5.3     foreign_0.8-55     formatR_0.10      
## [10] grid_3.0.2         gtable_0.1.2       labeling_0.2      
## [13] lattice_0.20-29    LearnBayes_2.12    MASS_7.3-29       
## [16] Matrix_1.0-14      munsell_0.4.2      nlme_3.1-111      
## [19] plyr_1.8.1         proto_0.3-10       RColorBrewer_1.0-5
## [22] Rcpp_0.11.1        reshape_0.8.4      reshape2_1.2.2    
## [25] scales_0.2.3       spdep_0.5-71       splines_3.0.2     
## [28] tools_3.0.2        XML_3.98-1.1
{% endhighlight %}

