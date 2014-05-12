---
title: helsinki vignette
layout: tutorial_page
package_name: helsinki
package_name_show: helsinki
author: Juuso Parkkinen, Leo Lahti, Joona Lehtomaki
meta_description: ["Tools for accessing various open data sources in the Helsinki", "region in Finland. Current data sources include the Real Estate Department", "and the Environmental Services Authority."]
github_user: ropengov
package_version: 0.9.16
header_descripton: ["Tools for accessing various open data sources in the Helsinki", "region in Finland. Current data sources include the Real Estate Department", "and the Environmental Services Authority."]
---







helsinki - tutorial
===========

This R package provides tools to access open data from the Helsinki region in Finland
as part of the [rOpenGov](http://ropengov.github.io) project.

For contact information and source code, see the [github page](https://github.com/rOpenGov/helsinki). 

## Available data sources

[Helsinki region district maps](#aluejakokartat) (Helsingin seudun aluejakokartat)
* Aluejakokartat: kunta, pien-, suur-, tilastoalueet (Helsinki region district maps)
* Äänestysaluejako: (Helsinki region election district maps)
* Source: [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/)

Helsinki Real Estate Department (HKK:n avointa dataa)
* Spatial data from [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/) availabe in the [gisfin](https://github.com/rOpenGov/gisfin) package, see [gisfin tutorial](https://github.com/rOpenGov/gisfin/blob/master/vignettes/gisfin_tutorial.md) for examples

[Helsinki region environmental services](#hsy) (HSY:n avointa dataa)
* Väestötietoruudukko (population grid)
* Rakennustietoruudukko (building information grid)
* SeutuRAMAVA (building land resource information(?))
* Source: [Helsingin seudun ympäristöpalvelut, HSY](http://www.hsy.fi/seututieto/kaupunki/paikkatiedot/Sivut/Avoindata.aspx)

[Service and event information](#servicemap)
* [Helsinki region Service Map](http://www.hel.fi/palvelukartta/Default.aspx?language=fi&city=91) (Pääkaupunkiseudun Palvelukartta)
* [Omakaupunki](http://api.omakaupunki.fi/) (requires personal API key, no examples given)

[Helsinki Region Infoshare statistics API](#hri_stats)
* [Aluesarjat (original source)](http://www.aluesarjat.fi/) (regional time series data)
* More data coming...
* Source: [Helsinki Region Infoshare statistics API](http://dev.hel.fi/stats/)

[Economic data](#economy)
* [Taloudellisia tunnuslukuja](http://www.hri.fi/fi/data/paakaupunkiseudun-kuntien-taloudellisia-tunnuslukuja/) (economic indicators)
 
List of potential data sources to be added to the package can be found [here](https://github.com/rOpenGov/helsinki/blob/master/vignettes/todo-datasets.md).

## Installation

Release version for general users:


{% highlight r %}
install.packages("helsinki")
{% endhighlight %}


Development version for developers:


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("helsinki", "ropengov")
{% endhighlight %}


Load package.


{% highlight r %}
library(helsinki)
{% endhighlight %}


## <a name="aluejakokartat"></a>Helsinki region district maps

Helsinki region district maps (Helsingin seudun aluejakokartat) and election maps (äänestysalueet) from [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/) are available in the helsinki package with `data(aluejakokartat)`. The data are available as both spatial object (`sp`) and data frame (`df`). These are preprocessed in the [gisfin](https://github.com/rOpenGov/gisfin) package, and more examples can be found in the [gisfin tutorial](https://github.com/rOpenGov/gisfin/blob/master/vignettes/gisfin_tutorial.md). 


{% highlight r %}
# Load aluejakokartat and study contents
data(aluejakokartat)
str(aluejakokartat, m = 2)
{% endhighlight %}



{% highlight text %}
## List of 2
##  $ sp:List of 8
##   ..$ kunta            :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ pienalue         :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ pienalue_piste   :Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..$ suuralue         :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ suuralue_piste   :Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..$ tilastoalue      :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..$ tilastoalue_piste:Formal class 'SpatialPointsDataFrame' [package "sp"] with 5 slots
##   ..$ aanestysalue     :Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##  $ df:List of 8
##   ..$ kunta            :'data.frame':	1664 obs. of  7 variables:
##   ..$ pienalue         :'data.frame':	33594 obs. of  7 variables:
##   ..$ pienalue_piste   :'data.frame':	295 obs. of  3 variables:
##   ..$ suuralue         :'data.frame':	6873 obs. of  7 variables:
##   ..$ suuralue_piste   :'data.frame':	23 obs. of  3 variables:
##   ..$ tilastoalue      :'data.frame':	17279 obs. of  7 variables:
##   ..$ tilastoalue_piste:'data.frame':	125 obs. of  3 variables:
##   ..$ aanestysalue     :'data.frame':	35349 obs. of  11 variables:
{% endhighlight %}



## <a name="hsy"></a> Helsinki region environmental services

Retrieve data from [Helsingin seudun ympäristöpalvelut (HSY)](http://www.hsy.fi/seututieto/kaupunki/paikkatiedot/Sivut/Avoindata.aspx) with `get_hsy()`.

### Population grid 

Population grid (väestötietoruudukko) with 250m x 250m grid size in year 2013 contains the number of people in different age groups. The most rarely populated grids are left out (0-4 persons), and grids wiht less than 99 persons are censored with '99' to guarantee privacy.


{% highlight r %}
sp.vaesto <- get_hsy(which.data = "Vaestotietoruudukko", which.year = 2013)
head(sp.vaesto@data)
{% endhighlight %}



### Helsinki building information

Building information grid (rakennustietoruudukko) in Helsinki region on grid-level (500m x 500m): building counts (lukumäärä), built area (kerrosala), usage (käyttötarkoitus), and region
efficiency (aluetehokkuus).


{% highlight r %}
sp.rakennus <- get_hsy(which.data = "Rakennustietoruudukko", which.year = 2013)
head(sp.rakennus@data)
{% endhighlight %}


### Helsinki building area capacity

Building area capacity per municipal region (kaupunginosittain summattua tietoa rakennusmaavarannosta). Plot with number of buildlings with `spplot()`.


{% highlight r %}
sp.ramava <- get_hsy(which.data = "SeutuRAMAVA_tila", which.year = 2013)
head(sp.ramava@data)
# Values with less than five units are given as 999999999, set those to zero
sp.ramava@data[sp.ramava@data == 999999999] <- 0
# Plot number of buildings for each region
spplot(sp.ramava, zcol = "RAKLKM", main = "Number of buildings in each 'tilastoalue'")
{% endhighlight %}

![plot of chunk hsy_ramava](../../figs/helsinki_tutorial/hsy_ramava.png) 



## <a name="servicemap"></a>Service and event information

Function `get_servicemap()` retrieves regional service data from the [Service Map](http://www.hel.fi/palvelukartta/Default.aspx?language=fi&city=91) [API](http://www.hel.fi/palvelukarttaws/rest/ver2_en.html).


{% highlight r %}
# Get servicetree
pk.servicetree <- get_servicemap("servicetree")
# Get id for parks
str(pk.servicetree[[1]]$children[[7]]$children[[2]])
# Get parks data
parks.data <- get_servicemap("unit", service = 25664)
{% endhighlight %}



{% highlight text %}
## Error: Proxy Error: remote host didn't send any data - URL "http://10.231.128.27:10058/tprek/rest/v2/unit/?service=25664"
{% endhighlight %}



{% highlight r %}
# Check what data is given for the first park
str(parks.data[[1]])
{% endhighlight %}



{% highlight text %}
## Error: object 'parks.data' not found
{% endhighlight %}


Function `get_omakaupunki()` retrieves regional service and event data from the [Omakaupunki API](http://api.omakaupunki.fi/). However, the API needs a personal key, so no examples are given here.

## <a name="hri_stats"></a> Helsinki Region Infoshare statistics API

Function `get_hri_stats()` retrieves data from the [Helsinki Region Infoshare statistics API](http://dev.hel.fi/stats/). Note! The implementation will be updated!


{% highlight r %}
# Retrieve list of available data
stats.list <- get_hri_stats(query = "")
# Show first results
head(stats.list)
{% endhighlight %}



{% highlight text %}
##                             Helsingin väestö äidinkielen mukaan 1.1. 
##                            "aluesarjat_a03s_hki_vakiluku_aidinkieli" 
##                                           Syntyneet äidin iän mukaan 
##                             "aluesarjat_hginseutu_va_vm04_syntyneet" 
##   Vantaalla asuva työllinen työvoima sukupuolen ja iän mukaan 31.12. 
##                             "aluesarjat_c01s_van_tyovoima_sukupuoli" 
## Espoon lapsiperheet lasten määrän mukaan (0-17-vuotiaat lapset) 1.1. 
##                            "aluesarjat_b03s_esp_lapsiperheet_alle18" 
##                                 Väestö iän ja sukupuolen mukaan 1.1. 
##                          "aluesarjat_hginseutu_va_vr01_vakiluku_ika" 
##         Helsingin asuntotuotanto rahoitusmuodon ja huoneluvun mukaan 
##                         "aluesarjat_a03hki_astuot_rahoitus_huonelkm"
{% endhighlight %}


Specify a dataset to retrieve. The output is currently a three-dimensional array.


{% highlight r %}
# Retrieve a specific dataset
stats.res <- get_hri_stats(query = stats.list[1])
# Show the structure of the results
str(stats.res)
{% endhighlight %}



{% highlight text %}
##  num [1:22, 1:4, 1:197] 497526 501518 508659 515765 525031 ...
##  - attr(*, "dimnames")=List of 3
##   ..$ vuosi     : chr [1:22] "1992" "1993" "1994" "1995" ...
##   ..$ aidinkieli: chr [1:4] "Kaikki äidinkielet" "Suomi ja saame" "Ruotsi" "Muu kieli"
##   ..$ alue      : chr [1:197] "091 Helsinki" "091 1 Eteläinen suurpiiri" "091 101 Vironniemen peruspiiri" "091 10 Kruununhaka" ...
{% endhighlight %}


More examples to be added.

## <a name="economy"></a> Economic data

Function `get_economic_indicators()` retrieves [economic indicator](http://www.hri.fi/fi/data/paakaupunkiseudun-kuntien-taloudellisia-tunnuslukuja/) data for Helsinki, Espoo, Vantaa and Kauniainen from years 1998-2010. 


{% highlight r %}
# Retrieve data
ec.res <- get_economic_indicators()
# See first results
head(ec.res$indicators)
{% endhighlight %}



{% highlight text %}
##       Alue                         Tunnusluku     1998     1999     2000
## 1 Helsinki                  Asukasluku 31.12. 546317.0 551123.0 555474.0
## 2 Helsinki               Tuloveroprosentti 1)     16.5     16.5     16.5
## 3 Helsinki     Verotettavat tulot, EUR/as. 2)  13856.0  14677.0  15512.0
## 4 Helsinki Verotettavien tulojen muutos, % 2)      6.8      7.3      6.6
## 5 Helsinki        Verotulot yhteensä, EUR/as.   3386.0   3336.0   3894.0
## 6 Helsinki           - Kunnallisvero, EUR/as.   2129.0   2187.0   2425.0
##       2001     2002     2003     2004     2005     2006     2007     2008
## 1 559718.0 559716.0 559330.0 559046.0 560905.0 564521.0 568531.0 574564.0
## 2     16.5     16.5     17.5     17.5     17.5     17.5     17.5     17.5
## 3  16077.0  16463.0  16424.0  16613.0  17111.0  17947.0  19022.0  19989.0
## 4      4.5      3.2     -0.2      1.1      2.9      5.2      6.7      5.8
## 5   4072.0   3556.0   3548.0   3448.0   3535.0   3709.0   3979.0   4199.0
## 6   2677.0   2860.0   2937.0   2863.0   2935.0   3096.0   3274.0   3437.0
##       2009 2010
## 1 583350.0   NA
## 2     17.5 17.5
## 3  19840.0   NA
## 4      0.3   NA
## 5   4120.0   NA
## 6   3477.0   NA
{% endhighlight %}


### Citation

**Citing the data:** See `help()` to get citation information for each data source individually.

**Citing the R package:**


{% highlight r %}
citation("helsinki")
{% endhighlight %}



{% highlight text %}

Kindly cite the helsinki R package as follows:

  (C) Juuso Parkkinen, Leo Lahti and Joona Lehtomaki 2014.
  helsinki R package

A BibTeX entry for LaTeX users is

  @Misc{,
    title = {helsinki R package},
    author = {Juuso Parkkinen and Leo Lahti and Joona Lehtomaki},
    year = {2014},
  }

Many thanks for all contributors! For more info, see:
https://github.com/rOpenGov/helsinki
{% endhighlight %}


### Session info


This vignette was created with


{% highlight r %}
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.0.3 (2014-03-06)
## Platform: x86_64-apple-darwin10.8.0 (64-bit)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] methods   stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
##  [1] helsinki_0.9.16 mapproj_1.2-2   maps_2.3-6      rgeos_0.3-4    
##  [5] maptools_0.8-29 gisfin_0.9.14   ggmap_2.3       ggplot2_0.9.3.1
##  [9] fingis_0.9.12   rgdal_0.8-16    sp_1.0-14       knitr_1.5      
## 
## loaded via a namespace (and not attached):
##  [1] boot_1.3-10         coda_0.16-1         colorspace_1.2-4   
##  [4] deldir_0.1-5        dichromat_2.0-0     digest_0.6.4       
##  [7] evaluate_0.5.1      foreign_0.8-60      formatR_0.10       
## [10] grid_3.0.3          gtable_0.1.2        labeling_0.2       
## [13] lattice_0.20-27     LearnBayes_2.12     MASS_7.3-30        
## [16] Matrix_1.1-2-2      munsell_0.4.2       nlme_3.1-115       
## [19] plyr_1.8.1          png_0.1-7           proto_0.3-10       
## [22] RColorBrewer_1.0-5  Rcpp_0.11.1         RCurl_1.95-4.1     
## [25] reshape2_1.2.2      RgoogleMaps_1.2.0.5 rjson_0.2.13       
## [28] RJSONIO_1.0-3       scales_0.2.3        spdep_0.5-71       
## [31] splines_3.0.3       stringr_0.6.2       tools_3.0.3        
## [34] XML_3.95-0.2
{% endhighlight %}


