---
title: helsinki vignette
layout: tutorial_page
package_name: helsinki
package_name_show: helsinki
author: Juuso Parkkinen, Leo Lahti, Joona Lehtomaki
meta_description: ["Tools for accessing various open data sources in the Helsinki", "region in Finland. Current data sources include the Real Estate Department", "and the Environmental Services Authority."]
github_user: ropengov
package_version: 0.9.19
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
* [Helsinki region Service Map API](http://api.hel.fi/servicemap/v1/) (Pääkaupunkiseudun Palvelukartta)
* [Helsinki Linked Event API](http://api.hel.fi/linkedevents/v0.1/)
* [Omakaupunki](http://api.omakaupunki.fi/) (requires personal API key, no examples given)

[Helsinki Region Infoshare statistics API](#hri_stats)
* [Aluesarjat (original source)](http://www.aluesarjat.fi/) (regional time series data)
* Source: [Helsinki Region Infoshare statistics API](http://dev.hel.fi/stats/)

[Economic data](#economy)
* [Taloudellisia tunnuslukuja](http://www.hri.fi/fi/data/paakaupunkiseudun-kuntien-taloudellisia-tunnuslukuja/) (economic indicators)

[Demographic data](#demography)
* [Väestöennuste 2012-2050](http://www.hri.fi/fi/data/helsingin-ja-helsingin-seudun-vaestoennuste-sukupuolen-ja-ian-mukaan-2012-2050/) (population projection 2012-2050)
 

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
str(aluejakokartat, m=2)
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

Population grid (väestötietoruudukko) with 250m x 250m grid size in year 2013 contains the number of people in different age groups. The most rarely populated grids are left out (0-4 persons), and grids with less than 99 persons are censored with '99' to guarantee privacy.


{% highlight r %}
sp.vaesto <- get_hsy(which.data="Vaestotietoruudukko", which.year=2013)
head(sp.vaesto@data)
{% endhighlight %}



{% highlight text %}
##   INDEX ASUKKAITA ASVALJYYS IKA0_9 IKA10_19 IKA20_29 IKA30_39 IKA40_49
## 0   688         5        50     99       99       99       99       99
## 1   703         6        42     99       99       99       99       99
## 2   710         7        36     99       99       99       99       99
## 3   711         7        64     99       99       99       99       99
## 4   715        16        28     99       99       99       99       99
## 5   864        10        65     99       99       99       99       99
##   IKA50_59 IKA60_69 IKA70_79 IKA_YLI80
## 0       99       99       99        99
## 1       99       99       99        99
## 2       99       99       99        99
## 3       99       99       99        99
## 4       99       99       99        99
## 5       99       99       99        99
{% endhighlight %}


### Helsinki building information

Building information grid (rakennustietoruudukko) in Helsinki region on grid-level (500m x 500m): building counts (lukumäärä), built area (kerrosala), usage (käyttötarkoitus), and region
efficiency (aluetehokkuus).


{% highlight r %}
sp.rakennus <- get_hsy(which.data="Rakennustietoruudukko", which.year=2013)  
head(sp.rakennus@data)
{% endhighlight %}



{% highlight text %}
##   INDEX RAKLKM RAKLKM_AS RAKLKM_MUU KERALA_YHT KERALA_AS KERALA_MUU
## 0   688      3         2          1        324       282         42
## 1   691      3         2          1         90        80         10
## 2   692      9         4          5        286       206         80
## 3   702      2         2          0        262       262          0
## 4   703      3         2          1        373       326         47
## 5   710      6         2          4        370       302         68
##   KATAKER1  KATAKER2  KATAKER3 SUMMA1    SUMMA2    SUMMA3 ALUETEHOK
## 0       11       941 999999999    282        42 999999999  0.005288
## 1       41       941 999999999     80        10 999999999  0.001440
## 2       41       941       931    206        47        33  0.007304
## 3       11 999999999 999999999    262 999999999 999999999  0.004192
## 4       11       941 999999999    326        47 999999999  0.005968
## 5       11       931       941    302        39        29  0.005920
##   KATAKER1.description    KATAKER2.description    KATAKER3.description
## 0  Yhden asunnon talot       Talousrakennukset Puuttuvan tiedon merkki
## 1   Vapaa-ajan asunnot       Talousrakennukset Puuttuvan tiedon merkki
## 2   Vapaa-ajan asunnot       Talousrakennukset        Saunarakennukset
## 3  Yhden asunnon talot Puuttuvan tiedon merkki Puuttuvan tiedon merkki
## 4  Yhden asunnon talot       Talousrakennukset Puuttuvan tiedon merkki
## 5  Yhden asunnon talot        Saunarakennukset       Talousrakennukset
{% endhighlight %}

### Helsinki building area capacity

Building area capacity per municipal region (kaupunginosittain summattua tietoa rakennusmaavarannosta). Plot with number of buildlings with `spplot()`.


{% highlight r %}
sp.ramava <- get_hsy(which.data="SeutuRAMAVA_tila", which.year=2013)  
head(sp.ramava@data)
{% endhighlight %}



{% highlight text %}
##   KUNTA    KOKOTUN TILANRO            NIMI RAKLKM YKSLKM RAKEOIKEUS
## 0   049 0491013000     013 KILO-KARAKALLIO   2245    915    1871538
## 1   235 2351003000     003            <NA>    326    214     218052
## 2   049 0495051000     051 KANTA-KAUKLAHTI    952    396     321345
## 3   092 0926081000     081           KORSO   1511    965     519438
## 4   092 0927096000     096     ITÄ-HAKKILA    994    687     278428
## 5   049 0491014000     014     LAAKSOLAHTI   3749   1998     807561
##   KARA_YHT KARA_AS KARA_MUU RAKERA_YHT RAKERA_AS RAKERA_MUU VARA_YHT
## 0  1225666  607609   618057      40653     22814      17839   646923
## 1   171017  103585    67432       7411      6206       1205    47053
## 2   195116  144274    50842      41179     34061       7118    98379
## 3   419911  334123    85788       3963      3355        608    98692
## 4   193025  127626    65399       2067      1720        347    77453
## 5   600636  547178    53458      33286     29987       3299   174097
##   VARA_AS VARA_AP VARA_AK VARA_MUU VANHINRAKE UUSINRAKE OMLAJI_1
## 0   93878   68728   25150   553045       1900      2013       11
## 1   42653   40606    2047     4400       1907      2013       11
## 2   76698   72958    3740    21681       1900      2013        3
## 3   59018   54779    4239    39674       1890      2013        9
## 4   22339   22339       0    55114       1900      2013        9
## 5  135184  130252    4932    38913       1870      2013        9
##                        OMLAJI_1S OMLAJI_2                      OMLAJI_2S
## 0 Asunto-osakeyhtiö tai asunto-o       11 Asunto-osakeyhtiö tai asunto-o
## 1 Asunto-osakeyhtiö tai asunto-o       11 Asunto-osakeyhtiö tai asunto-o
## 2                          Espoo        3                          Espoo
## 3         Muu yksityinen henkilö        9         Muu yksityinen henkilö
## 4         Muu yksityinen henkilö        9         Muu yksityinen henkilö
## 5         Muu yksityinen henkilö        9         Muu yksityinen henkilö
##   OMLAJI_3                      OMLAJI_3S
## 0       11 Asunto-osakeyhtiö tai asunto-o
## 1       11 Asunto-osakeyhtiö tai asunto-o
## 2        3                          Espoo
## 3        9         Muu yksityinen henkilö
## 4        9         Muu yksityinen henkilö
## 5        9         Muu yksityinen henkilö
{% endhighlight %}



{% highlight r %}
# Values with less than five units are given as 999999999, set those to zero
sp.ramava@data[sp.ramava@data==999999999] <- 0
# Plot number of buildings for each region
spplot(sp.ramava, zcol="RAKLKM", main="Number of buildings in each 'tilastoalue'", col.regions=colorRampPalette(c('blue', 'gray80', 'red'))(100))
{% endhighlight %}

![plot of chunk hsy_ramava](../../figs/helsinki_tutorial/hsy_ramava.png) 


## <a name="servicemap"></a>Service and event information

Function `get_servicemap()` retrieves regional service data from the new [Service Map API](http://api.hel.fi/servicemap/v1/), that contains data from the [Service Map](http://dev.hel.fi/servicemap/).


{% highlight r %}
# Search for "puisto" (park) (specify q="query")
search.puisto <- get_servicemap(query="search", q="puisto")
# Study results
str(search.puisto, m=1)
{% endhighlight %}



{% highlight text %}
## List of 4
##  $ count   : num 1403
##  $ next    : chr "http://api.hel.fi/servicemap/v1/search/?page=2&q=puisto"
##  $ previous: NULL
##  $ results :List of 20
{% endhighlight %}



{% highlight r %}
# A lot of results found (count > 1000)
# Get names for the first 20 results
sapply(search.puisto$results, function(x) x$name$fi)
{% endhighlight %}



{% highlight text %}
##  [1] "Sibeliuksen puiston yleisövessa"      
##  [2] "Sinebrychoffin puiston yleisövessa"   
##  [3] "Topeliuksen puiston yleisövessa"      
##  [4] "Puistot ja viheralueet"               
##  [5] "Matti Heleniuksen puiston yleisövessa"
##  [6] "Thurmaninpuisto"                      
##  [7] "Asematien puisto"                     
##  [8] "Hurtigin puisto"                      
##  [9] "Kasavuoren puisto"                    
## [10] "Kaupungintalon puisto"                
## [11] "Stenbergin puisto"                    
## [12] "Leikkipaikka Härkävaljakon puisto"    
## [13] "Leikkipaikka Ilkantien puisto"        
## [14] "Leikkipaikka Johanneksen puisto"      
## [15] "Leikkipaikka Katajanokan puisto"      
## [16] "Leikkipaikka Kivitorpan puisto"       
## [17] "Leikkipaikka Museon puisto"           
## [18] "Leikkipaikka Pajalahden puisto"       
## [19] "Leikkipaikka Rikun puisto"            
## [20] "Leikkipaikka Rukkilan puisto"
{% endhighlight %}



{% highlight r %}
# See what data is given for one service
names(search.puisto$results[[1]])
{% endhighlight %}



{% highlight text %}
##  [1] "connections"               "id"                       
##  [3] "data_source_url"           "name"                     
##  [5] "description"               "provider_type"            
##  [7] "department"                "organization"             
##  [9] "street_address"            "address_zip"              
## [11] "phone"                     "email"                    
## [13] "www_url"                   "address_postal_full"      
## [15] "municipality"              "picture_url"              
## [17] "picture_caption"           "origin_last_modified_time"
## [19] "services"                  "divisions"                
## [21] "keywords"                  "root_services"            
## [23] "location"                  "object_type"              
## [25] "score"
{% endhighlight %}



{% highlight r %}
# More results could be retrieved by specifying 'page=2' etc.
{% endhighlight %}

Function `get_linkedevents()` retrieves regional event data from the new [Linked Events API](http://api.hel.fi/linkedevents/v0.1/).


{% highlight r %}
# Searh for current events
events <- get_linkedevents(query="event")
# Get names for the first 20 results
sapply(events$results, function(x) x$name$fi)
{% endhighlight %}



{% highlight text %}
##  [1] "Mikko Maltsusta"                           
##  [2] "Valokuvia ja maalauksia Vietnamista"       
##  [3] "Helsingin Poliisisoittokunta ja Anssi Kela"
##  [4] "Kalevala klubi"                            
##  [5] "Nuori taide"                               
##  [6] "Bulgarian nykykirjallisuutta tutummaksi"   
##  [7] "Tanssimme sinulle Itämaista"               
##  [8] "Kuuma ankanpoikanen: Let´s Fat"            
##  [9] "Louise Lapointe: Puppetry Arts in Québec"  
## [10] "Studio 90:n tanssioppilaiden kevätnäytös"  
## [11] "Studio 90:n tanssioppilaiden kevätnäytös"  
## [12] "Muutos"                                    
## [13] "Laulan!"                                   
## [14] "Vispilänkauppaa ja jumihäitä"              
## [15] "Teatteriryhmä Vire: Munkkikeikka"          
## [16] "Teatteriryhmä Vire: Munkkikeikka"          
## [17] "Teatteriryhmä Vire: Munkkikeikka"          
## [18] "Anita-Ullas dolda liv"                     
## [19] "Anita-Ullas dolda liv"                     
## [20] "Don*Gnu (Tanska): Men in Sandals"
{% endhighlight %}



{% highlight r %}
# See what data is given for the first event
names(events$results[[1]])
{% endhighlight %}



{% highlight text %}
##  [1] "location"            "keywords"            "super_event"        
##  [4] "event_status"        "id"                  "data_source"        
##  [7] "origin_id"           "custom_fields"       "image"              
## [10] "created_time"        "last_modified_time"  "date_published"     
## [13] "start_time"          "end_time"            "target_group"       
## [16] "name"                "location_extra_info" "url"                
## [19] "description"         "@id"                 "@type"
{% endhighlight %}


Function `get_omakaupunki()` retrieves regional service and event data from the [Omakaupunki API](http://api.omakaupunki.fi/). However, the API needs a personal key, so no examples are given here.

## <a name="hri_stats"></a> Helsinki Region Infoshare statistics API

Function `get_hri_stats()` retrieves data from the [Helsinki Region Infoshare statistics API](http://dev.hel.fi/stats/).


{% highlight r %}
# Retrieve list of available data
stats.list <- get_hri_stats(query="")
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
stats.res <- get_hri_stats(query=stats.list[1])
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

The implementation will be updated and more examples will be added in the near future.

## <a name="economy"></a> Economic data

Function `get_economic_indicators()` retrieves [economic indicator](http://www.hri.fi/fi/data/paakaupunkiseudun-kuntien-taloudellisia-tunnuslukuja/) data for Helsinki, Espoo, Vantaa and Kauniainen from years 1998-2010. 


{% highlight r %}
# Retrieve data
ec.res <- get_economic_indicators()
# See first results
head(ec.res$data)
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


## <a name="demography"></a> Demographic data

Function `get_population_projection()` retrieves [population projection](http://www.hri.fi/fi/data/helsingin-ja-helsingin-seudun-vaestoennuste-sukupuolen-ja-ian-mukaan-2012-2050/) data for Helsinki and Helsinki region by age and gender.


{% highlight r %}
# Retrieve data
pop.res <- get_population_projection()
# See first results
head(pop.res$data[1:6])
{% endhighlight %}



{% highlight text %}
##   Alue.Region Vuosi.Year Yhteensä.Total Miehet.Male   m0   m1
## 1    Helsinki       2011         588549      276361 3416 3049
## 2    Helsinki       2012         594483      279383 3364 3289
## 3    Helsinki       2013         599822      282099 3428 3231
## 4    Helsinki       2014         604561      284485 3487 3289
## 5    Helsinki       2015         609373      286899 3535 3348
## 6    Helsinki       2016         614246      289334 3577 3395
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
## R version 3.1.0 (2014-04-10)
## Platform: x86_64-pc-linux-gnu (64-bit)
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
## [1] helsinki_0.9.19 ggplot2_1.0.0   rgeos_0.3-4     maptools_0.8-29
## [5] gisfin_0.9.15   rgdal_0.8-16    sp_1.0-15       knitr_1.6      
## 
## loaded via a namespace (and not attached):
##  [1] boot_1.3-11      coda_0.16-1      colorspace_1.2-4 deldir_0.1-5    
##  [5] digest_0.6.4     evaluate_0.5.5   foreign_0.8-61   formatR_0.10    
##  [9] grid_3.1.0       gtable_0.1.2     labeling_0.2     lattice_0.20-29 
## [13] LearnBayes_2.12  MASS_7.3-33      Matrix_1.1-3     munsell_0.4.2   
## [17] nlme_3.1-117     plyr_1.8.1       proto_0.3-10     Rcpp_0.11.1     
## [21] RCurl_1.95-4.1   reshape2_1.4     rjson_0.2.13     scales_0.2.4    
## [25] spdep_0.5-71     splines_3.1.0    stringr_0.6.2    tools_3.1.0     
## [29] XML_3.98-1.1
{% endhighlight %}

