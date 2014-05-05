---
title: fingis vignette
layout: tutorial_page
package_name: fingis
package_name_show: fingis
author: Juuso Parkkinen, Leo Lahti, Joona Lehtomaki
meta_description: R tools for reading open geographical data in Finland.
github_user: ropengov
package_version: 0.9.10
header_descripton: R tools for reading open geographical data in Finland.
---






fingis - tutorial
===========

This R package provides tools to access open spatial data in Finland
as part of the [rOpenGov](http://ropengov.github.io) project.

For contact information and source code, see the [github page](https://github.com/rOpenGov/fingis)

## Available data sources

The following data sources are currently available:
* [Helsinki region district maps](#aluejakokartat) (Helsingin seudun aluejakokartat)
  * Aluejakokartat, äänestysaluejako from [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/)
* [Helsinki spatial data](#hel-spatial) (Helsingin seudun avoimia paikkatietoaineistoja)
  * Seutukartta, Helsingin piirijako, rakennusrekisterin ote from [Helsingin kaupungin Kiinteistövirasto](http://ptp.hel.fi/avoindata/)
* [National Land Survery data](#maanmittauslaitos) (Maanmittauslaitoksen avointa dataa)
  * Yleiskartat from [National Land Survery Finland](http://www.maanmittauslaitos.fi/en/opendata)
* [Geocoding](#geocoding)
  * Services: [OKF.fi Geocoding API Test Console](http://data.okf.fi/console/), [OpenStreetMap Nominatim](http://wiki.openstreetmap.org/wiki/Nominatim_usage_policy), [Google](http://code.google.com/apis/maps/documentation/geocoding/)

## Installation

Release version for general users:


{% highlight r %}
install.packages("fingis")
{% endhighlight %}


Development version for developers:


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("fingis", "ropengov")
{% endhighlight %}


Load package.


{% highlight r %}
library(fingis)
{% endhighlight %}



{% highlight text %}
## Loading required package: rgdal
## Loading required package: methods
## Loading required package: sp
## rgdal: version: 0.8-16, (SVN revision 498)
## Geospatial Data Abstraction Library extensions to R successfully loaded
## Loaded GDAL runtime: GDAL 1.9.2, released 2012/10/08
## Path to GDAL shared files: /Library/Frameworks/R.framework/Versions/3.0/Resources/library/rgdal/gdal
## Loaded PROJ.4 runtime: Rel. 4.8.0, 6 March 2012, [PJ_VERSION: 480]
## Path to PROJ.4 shared files: /Library/Frameworks/R.framework/Versions/3.0/Resources/library/rgdal/proj
## fingis R package: tools for open GIS data for Finland.
## This R package is part of rOpenGov <ropengov.github.io>.
## Copyright (C) 2010-2014 Leo Lahti, Juuso Parkkinen and Joona Lehtomaki.
## This is free software. You are free to use, modify and redistribute it under the FreeBSD license.
{% endhighlight %}


### Notes

The fingis package uses the [rgdal](http://cran.r-project.org/web/packages/rgdal/index.html) library, which depends on the [GDAL](http://www.gdal.org/) spatial framework. Some rgdal installation tips for various platforms lister below. If you encounter problems, please contact us by email: louhos@googlegroups.com.
* Windows: Install binaries from [CRAN](http://cran.r-project.org/web/packages/rgdal/index.html)
* OSX: Install binaries from [CRAN](http://cran.r-project.org/web/packages/rgdal/index.html). Check also [KyngChaos Wiki](http://www.kyngchaos.com/software/frameworks) 
* Linux: Try the installation scripts [here](https://github.com/louhos/takomo/tree/master/installation/) (not necessarily up-to-date!)

## <a name="aluejakokartat"></a>Helsinki region district maps

Helsinki region district maps (Helsingin seudun aluejakokartat) from [Helsingin kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/).

List available maps with `get_Helsinki_aluejakokartat()`.


{% highlight r %}
get_Helsinki_aluejakokartat()
{% endhighlight %}



{% highlight text %}
## [1] "kunta"             "pienalue"          "pienalue_piste"   
## [4] "suuralue"          "suuralue_piste"    "tilastoalue"      
## [7] "tilastoalue_piste" "aanestysalue"
{% endhighlight %}


Retrieve 'suuralue' spatial object with `get_Helsinki_aluejakokartat()`, and plot with `plot_shape()`.


{% highlight r %}
sp.suuralue <- get_Helsinki_aluejakokartat(map.specifier = "suuralue")
plot_shape(sp = sp.suuralue, varname = "Name", type = "discrete", plot = FALSE)
{% endhighlight %}

![plot of chunk hkk-suuralue1](http://i.imgur.com/VcmrwOj.png) 


Retrieve 'suuralue_piste' spatial object, containing the center points of the districts, and plot with `spplot()`.


{% highlight r %}
sp.suuralue.piste <- get_Helsinki_aluejakokartat(map.specifier = "suuralue_piste")
sp::spplot(obj = sp.suuralue.piste, zcol = "Name")
{% endhighlight %}

![plot of chunk hkk-suuralue2](http://i.imgur.com/H7iFDk8.png) 


Use `sp2df()` function to tranform the spatial objects into data frames. Plot with [ggplot2](http://ggplot2.org/), using blank map theme with `get_theme_map()`. 


{% highlight r %}
# Get data frames
df.suuralue <- sp2df(sp.suuralue, "Name")
df.suuralue.piste <- sp2df(sp.suuralue.piste, "Name")

# Set map theme
library(ggplot2)
theme_set(get_theme_map())
# Plot regions, add labels using the points data
ggplot(df.suuralue, aes(x = long, y = lat, fill = Name)) + geom_polygon() + 
    geom_text(data = df.suuralue.piste, aes(label = Name)) + theme(legend.position = "none")
{% endhighlight %}

![plot of chunk hkk-suuralue3](http://i.imgur.com/hycT9yW.png) 


Add background map from OpenStreetMap using `get_map()` from [ggmap](https://sites.google.com/site/davidkahle/ggmap) and plot again.


{% highlight r %}
# Add background map from OpenStreetMap using ggmap
library(ggmap)
# Get bounding box from sp.suuralue
hel.bbox <- as.vector(sp.suuralue@bbox)
# Get map using openstreetmap
hel.map <- ggmap::get_map(location = hel.bbox, source = "osm")
# Plot transparent districts on top the background map
ggmap(hel.map) + geom_polygon(data = df.suuralue, aes(x = long, y = lat, fill = Name), 
    alpha = 0.5) + geom_text(data = df.suuralue.piste, aes(x = long, y = lat, 
    label = Name)) + theme(legend.position = "none")
{% endhighlight %}

![plot of chunk hkk-suuralue4](http://i.imgur.com/e3r9Jc1.png) 


Retrieve and plot äänetysaluejako (election districts) with `get_Helsinki_aluejakokartat()` and `plot_shape()`.


{% highlight r %}
sp.aanestys <- get_Helsinki_aluejakokartat(map.specifier = "aanestysalue")
plot_shape(sp.aanestys, "KUNTA", type = "discrete", plot = FALSE)
{% endhighlight %}

![plot of chunk hkk-aanestysalue](http://i.imgur.com/FyydOvr.png) 


## <a name="hel-spatial"></a>Helsinki spatial data

Other Helsinki region spatial data from [Helsingin Kaupungin Kiinteistövirasto (HKK)](http://ptp.hel.fi/avoindata/).

List available spatial data with `get_Helsinki_spatial()`.


{% highlight r %}
get_Helsinki_spatial()
{% endhighlight %}



{% highlight text %}
## $seutukartta
##  [1] "A_es_pie"   "a_hy_suu"   "a_ki_pie"   "a_nu_til"   "a_tu_til"  
##  [6] "l_jrata"    " m_jarvet"  "N_MERI_R"   "A_es_suu"   "a_hy_til"  
## [11] "a_ki_suu"   "a_pkspie"   "a_va_kos"   "l_kiitor"   "m_joet"    
## [16] "N_MERI_S"   "a_es_til"   "a_ja_pie"   "a_ki_til"   "a_pkstil"  
## [21] "a_va_suu"   "l_metras"   "m_meri"     "  N_PAIK_R" "a_hk_osa"  
## [26] "a_ja_til"   "a_kunta"    " a_pksuur"  "a_vi_pie"   "l_metror"  
## [31] "m_rantav"   "N_PAIK_S"   "a_hk_per"   "a_ka_pie"   "a_ma_pie"  
## [36] "a_po_til"   "a_vi_suu"   "l_tiest2"   "m_teolal"   "a_hk_pie"  
## [41] "a_ka_til"   "a_ma_til"   "a_si_pie"   "a_vi_til"   "l_tiesto"  
## [46] "m_vihral"   "a_hk_suu"   "a_ke_pie"   "a_nu_pie"   "a_tu_pie"  
## [51] "Copyrig"    "Maankay2"   "N_KOS_R"    "a_hy_pie"   "a_ke_til"  
## [56] "a_nu_suu"   "a_tu_suu"   "l_jasema"   "m_asalue"   "N_KOS_S"   
## 
## $piirijako
## [1] "ALUEJAKO_KUNTA"             "ALUEJAKO_OSAALUE_TUNNUS"   
## [3] "ALUEJAKO_OSAALUE"           "ALUEJAKO_PERUSPIIRI_TUNNUS"
## [5] "ALUEJAKO_PERUSPIIRI"        "ALUEJAKO_PIENALUE_TUNNUS"  
## [7] "ALUEJAKO_PIENALUE"          "ALUEJAKO_SUURPIIRI_TUNNUS" 
## [9] "ALUEJAKO_SUURPIIRI"        
## 
## $rakennusrekisteri
## [1] "20m2_hkikoord" "etrsgk25"      "hkikoord"      "wgs84"
{% endhighlight %}



## <a name="maanmittauslaitos"></a>National Land Survery Finland

Spatial data from [National Land Survey Finland](http://www.maanmittauslaitos.fi/en/opendata)  (Maanmittauslaitos, MML). These data are preprocessed into RData format, see details [here](https://github.com/avoindata/mml/tree/master/rdata).

List available data sets with `list_mml_datasets()`.


{% highlight r %}
list_mml_datasets()
{% endhighlight %}



{% highlight text %}
## $`1_milj_Shape_etrs_shape`
##  [1] "AVI1_l"   "AVI1_p"   "airport"  "asemat"   "cityp"    "coast_l" 
##  [7] "coast_p"  "dcont_l"  "dcont_p"  "forest"   "hcont_l"  "hcont_p" 
## [13] "hpoint"   "kunta1_l" "kunta1_p" "lake_l"   "lake_p"   "maaku1_l"
## [19] "maaku1_p" "namep"    "pelto"    "railway"  "river"    "rivera_l"
## [25] "rivera_p" "road"     "suot"     "taajama" 
## 
## $`4_5_milj_shape_etrs-tm35fin`
##  [1] "AVI1_l"   "AVI1_p"   "AVI4_l"   "AVI4_p"   "airport"  "asemat"  
##  [7] "cityp"    "coast"    "coast_l"  "coast_p"  "dcont_l"  "dcont_p" 
## [13] "forest"   "hcont_l"  "hcont_p"  "hpoint"   "kunta1_l" "kunta1_p"
## [19] "kunta4_l" "kunta4_p" "lake"     "lake_l"   "lake_p"   "maaku1_l"
## [25] "maaku1_p" "maaku4_l" "maaku4_p" "namep"    "pelto"    "railway" 
## [31] "rajamuu"  "river"    "rivera_l" "rivera_p" "road"     "suot"    
## [37] "taajama" 
## 
## $`2012`
## character(0)
## 
## $`Maastotietokanta-tiesto1`
## [1] "N61_v"
## 
## $`Maastotietokanta-tiesto2`
## [1] "N62_p" "N62_s" "N62_t" "N62_v"
## 
## $`Yleiskartta-1000`
##  [1] "AmpumaRaja"          "HallintoAlue"        "HallintoalueRaja"   
##  [4] "KaasuJohto"          "KarttanimiPiste500"  "KarttanimiPiste1000"
##  [7] "KorkeusAlue"         "KorkeusViiva500"     "KorkeusViiva1000"   
## [10] "LentokenttaPiste"    "LiikenneAlue"        "MaaAlue"            
## [13] "Maasto1Reuna"        "Maasto2Alue"         "MetsaRaja"          
## [16] "PeltoAlue"           "RautatieViiva"       "SahkoLinja"         
## [19] "SuojaAlue"           "SuojametsaRaja"      "SuojeluAlue"        
## [22] "TaajamaAlue"         "TaajamaPiste"        "TieViiva"           
## [25] "VesiAlue"            "VesiViiva"          
## 
## $`Yleiskartta-4500`
##  [1] "HallintoAlue"        "HallintoalueRaja"    "KarttanimiPiste2000"
##  [4] "KarttanimiPiste4500" "KarttanimiPiste8000" "KorkeusAlue"        
##  [7] "KorkeusViiva"        "Maasto1Reuna"        "RautatieViiva"      
## [10] "TaajamaPiste2000"    "TaajamaPiste4500"    "TaajamaPiste8000"   
## [13] "TieViiva2000"        "TieViiva4500"        "TieViiva8000"       
## [16] "VesiAlue"            "VesiViiva2000"       "VesiViiva4500"      
## [19] "VesiViiva8000"
{% endhighlight %}


Retrieve regional borders for Finland with `get_MML()`.


{% highlight r %}
# Get a specific map
sp.mml <- get_MML(map.id = "Yleiskartta-4500", data.id = "HallintoAlue")

# Investigate available variables in this map
head(as.data.frame(sp.mml))
{% endhighlight %}



{% highlight text %}
##   Kohderyhma Kohdeluokk Enklaavi AVI Maakunta Kunta
## 0         71      84200        1   1       01   078
## 1         71      84200        1   1       01   149
## 2         71      84200        1   7       21   318
## 3         71      84200        1   1       01   710
## 4         71      84200        1   1       01   235
## 5         71      84200        1   7       21   062
##                            AVI_ni1
## 0 Etelä-Suomen aluehallintovirasto
## 1 Etelä-Suomen aluehallintovirasto
## 2       Ahvenanmaan valtionvirasto
## 3 Etelä-Suomen aluehallintovirasto
## 4 Etelä-Suomen aluehallintovirasto
## 5       Ahvenanmaan valtionvirasto
##                                    AVI_ni2            Maaku_ni1
## 0 Regionförvaltningsverket i Södra Finland              Uusimaa
## 1 Regionförvaltningsverket i Södra Finland              Uusimaa
## 2              Statens ämbetsverk på Åland Ahvenanmaan maakunta
## 3 Regionförvaltningsverket i Södra Finland              Uusimaa
## 4 Regionförvaltningsverket i Södra Finland              Uusimaa
## 5              Statens ämbetsverk på Åland Ahvenanmaan maakunta
##          Maaku_ni2  Kunta_ni1 Kunta_ni2 Kieli_ni1 Kieli_ni2
## 0           Nyland      Hanko     Hangö     Suomi    Ruotsi
## 1           Nyland       Ingå     Inkoo    Ruotsi     Suomi
## 2 Landskapet Åland      Kökar       N_A    Ruotsi       N_A
## 3           Nyland   Raseborg Raasepori    Ruotsi     Suomi
## 4           Nyland Kauniainen Grankulla     Suomi    Ruotsi
## 5 Landskapet Åland      Föglö       N_A    Ruotsi       N_A
##                             AVI.FI Kieli.FI          Maakunta.FI
## 0 Etelä-Suomen aluehallintovirasto    Suomi              Uusimaa
## 1 Etelä-Suomen aluehallintovirasto   Ruotsi              Uusimaa
## 2       Ahvenanmaan valtionvirasto   Ruotsi Ahvenanmaan maakunta
## 3 Etelä-Suomen aluehallintovirasto   Ruotsi              Uusimaa
## 4 Etelä-Suomen aluehallintovirasto    Suomi              Uusimaa
## 5       Ahvenanmaan valtionvirasto   Ruotsi Ahvenanmaan maakunta
##     Kunta.FI
## 0      Hanko
## 1      Inkoo
## 2      Kökar
## 3  Raasepori
## 4 Kauniainen
## 5      Föglö
{% endhighlight %}


Plot provinces (maakunnat) with `plot_shape()`.


{% highlight r %}
# Plot the shape file, colour provinces
plot_shape(sp = sp.mml, varname = "Maakunta", type = "discrete", plot = FALSE)
{% endhighlight %}

![plot of chunk MML_province](http://i.imgur.com/6RIXTtP.png) 


Plot municipalities (kunnat) with `plot_shape()`.


{% highlight r %}
# Plot the shape file, colour municipalities
plot_shape(sp = sp.mml, varname = "Kunta", type = "discrete", plot = FALSE)
{% endhighlight %}

![plot of chunk MML_municipality](http://i.imgur.com/MhJaSUi.png) 


## <a name="geocoding"></a>Geocoding

Get geocodes for given location (address etc.) using one of the available services. Please read carefully the usage policies for the different services:
* [OKF.fi Geocoding API Test Console](http://data.okf.fi/console/)
* [OpenStreetMap Nominatim](http://wiki.openstreetmap.org/wiki/Nominatim_usage_policy)
* [Google](http://code.google.com/apis/maps/documentation/geocoding/)

The function `get_geocode()` returns both latitude and longitude for the first hit, and the raw output (varies depending on the service used).

Warning! The geocode result may vary between sources, use with care!



{% highlight r %}
gc1 <- get_geocode("Mannerheimintie 100, Helsinki", service = "okf")
unlist(gc1[1:2])
{% endhighlight %}



{% highlight text %}
##   lat   lon 
## 60.17 24.94
{% endhighlight %}



{% highlight r %}
gc2 <- get_geocode("Mannerheimintie 100, Helsinki", service = "openstreetmap")
unlist(gc2[1:2])
{% endhighlight %}



{% highlight text %}
##   lat   lon 
## 60.19 24.92
{% endhighlight %}



{% highlight r %}
gc3 <- get_geocode("Mannerheimintie 100, Helsinki", service = "google")
unlist(gc3[1:2])
{% endhighlight %}



{% highlight text %}
##   lat   lon 
## 60.19 24.92
{% endhighlight %}


### Citing the package

**Citing the data:** See `help()` to get citation information for each data source individually.

**Citing the R package:**


{% highlight r %}
citation("fingis")
{% endhighlight %}



{% highlight text %}

Kindly cite the helsinki R package as follows:

  (C) Juuso Parkkinen, Leo Lahti and Joona Lehtomaki 2014. fingis
  R package

A BibTeX entry for LaTeX users is

  @Misc{,
    title = {fingis R package},
    author = {Juuso Parkkinen and Leo Lahti and Joona Lehtomaki},
    year = {2014},
  }

Many thanks for all contributors! For more info, see:
https://github.com/rOpenGov/fingis
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
##  [1] mapproj_1.2-2   maps_2.3-6      ggmap_2.3       ggplot2_0.9.3.1
##  [5] rgeos_0.3-4     maptools_0.8-29 fingis_0.9.10   rgdal_0.8-16   
##  [9] sp_1.0-14       knitr_1.5      
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


