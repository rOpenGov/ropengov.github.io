---
title: sorvi vignette
layout: tutorial_page
package_name: sorvi
package_name_show: sorvi
author: Leo Lahti, Juuso Parkkinen, Joona Lehtomaki, Juuso Haapanen, Jussi, Paananen, Einari Happonen
meta_description: Algorithms for Finnish Open Government Data
github_user: ropengov
package_version: 0.4.24
header_descripton: Algorithms for Finnish Open Government Data
---



Finnish open government data toolkit for R
===========

This is an R package for Finnish open government data. New
contributions are [welcome!](http://louhos.github.com/contact.html).

This work is part of the [rOpenGov](http://ropengov.github.com)
project.


## Installation

General users (CRAN release version):


{% highlight r %}
install.packages("sorvi")
library(sorvi)
{% endhighlight %}


Developers (Github development version):


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("sorvi", "ropengov")
library(sorvi)
{% endhighlight %}


Further installation and development instructions can be found at the
project [home page](http://ropengov.github.com/sorvi). 


## Using the package

For further usage
examples, see [Louhos-blog](http://louhos.wordpress.com) and
[Datawiki](https://github.com/louhos/sorvi/wiki/Data).


### Personal identification number (HETU)

Extracting information from a Finnish personal identification number:


{% highlight r %}
library(sorvi)
hetu("111111-111C")
{% endhighlight %}



{% highlight text %}
## $hetu
## [1] "111111-111C"
## 
## $gender
## [1] "Male"
## 
## $personal.number
## [1] 111
## 
## $checksum
## [1] "C"
## 
## $date
## [1] "1911-11-11"
## 
## $day
## [1] 11
## 
## $month
## [1] 11
## 
## $year
## [1] 1911
## 
## $century.char
## [1] "-"
## 
## attr(,"class")
## [1] "hetu"
{% endhighlight %}


Validating Finnish personal identification number:


{% highlight r %}
valid.hetu("010101-0101")  # TRUE/FALSE
{% endhighlight %}



{% highlight text %}
## [1] TRUE
{% endhighlight %}


### Postal codes

Get Finnish postal codes vs. municipalities table from Wikipedia


{% highlight r %}
postal.code.table <- GetPostalCodeInfo()
head(postal.code.table)
{% endhighlight %}



{% highlight text %}
##   postal.code municipality municipality.ascii
## 1       07230       Askola             Askola
## 2       07500       Askola             Askola
## 3       07510       Askola             Askola
## 4       07530       Askola             Askola
## 5       07580       Askola             Askola
## 6       07590       Askola             Askola
{% endhighlight %}


### IP Location

Get geographic coordinates for a given IP-address from 
http://www.datasciencetoolkit.org//ip2coordinates/


{% highlight r %}
ip_location("137.224.252.10")
{% endhighlight %}



{% highlight text %}
## [1] "51.9667015075684" "5.66669988632202"
{% endhighlight %}



### Municipality information

Finnish municipality information is available through Population
Registry (Vaestorekisterikeskus), Statistics Finland (Tilastokeskus)
and Land Survey Finland (Maanmittauslaitos). We provide separate
download routine for each data set. The row names are in harmonized
format and can be used to match data sets from different sources, as
different data sets may carry slightly different versions of certain
municipality names. Examples for each case:

Finnish municipality information from Land Survey Finland ([Maanmittauslaitos, MML](http://www.maanmittauslaitos.fi/aineistot-palvelut/latauspalvelut/avoimien-aineistojen-tiedostopalvelu)). 


{% highlight r %}
municipality.info.mml <- GetMunicipalityInfoMML()
municipality.info.mml[1:2, ]
{% endhighlight %}



{% highlight text %}
##           Kohderyhma Kohdeluokk AVI Maakunta Kunta
## Äänekoski         71      84200   4       13   992
## Ähtäri            71      84200   4       14   989
##                                             AVI_ni1
## Äänekoski Länsi- ja Sisä-Suomen aluehallintovirasto
## Ähtäri    Länsi- ja Sisä-Suomen aluehallintovirasto
##                                                      AVI_ni2
## Äänekoski Regionförvaltningsverket i Västra och Inre Finland
## Ähtäri    Regionförvaltningsverket i Västra och Inre Finland
##                 Maaku_ni1         Maaku_ni2 Kunta_ni1 Kunta_ni2 Kieli_ni1
## Äänekoski     Keski-Suomi Mellersta Finland Äänekoski       N_A     Suomi
## Ähtäri    Etelä-Pohjanmaa Södra Österbotten    Ähtäri    Etseri     Suomi
##           Kieli_ni2                                    AVI.FI Kieli.FI
## Äänekoski       N_A Länsi- ja Sisä-Suomen aluehallintovirasto    Suomi
## Ähtäri       Ruotsi Länsi- ja Sisä-Suomen aluehallintovirasto    Suomi
##                Maakunta.FI  Kunta.FI
## Äänekoski      Keski-Suomi Äänekoski
## Ähtäri    EtelÃ¤-Pohjanmaa    Ähtäri
{% endhighlight %}


Get information of Finnish provinces from Statistics Finland ([Tilastokeskus](http://pxweb2.stat.fi/Database/Kuntien%20perustiedot/Kuntien%20perustiedot/Kuntaportaali.px))


{% highlight r %}
municipality.info.statfi <- GetMunicipalityInfoStatFi()
municipality.info.statfi[1:2, ]
{% endhighlight %}



{% highlight text %}
##                Alue Maapinta-ala, km2 1.1.2013 Taajama-aste, % 1.1.2012
## Äänekoski Äänekoski                        884                     76.1
## Ähtäri       Ähtäri                        805                     61.9
##           Väkiluku 31.12.2012 Väkiluvun muutos, % 2011 - 2012
## Äänekoski               20265                            -0.3
## Ähtäri                   6363                            -0.8
##           0-14 -vuotiaiden osuus väestöstä, % 31.12.2012
## Äänekoski                                           17.4
## Ähtäri                                              14.9
##           15-64 -vuotiaiden osuus väestöstä, % 31.12.2012
## Äänekoski                                            61.1
## Ähtäri                                               60.4
##           65 vuotta täyttäneiden osuus väestöstä, % 31.12.2012
## Äänekoski                                                 21.5
## Ähtäri                                                    24.6
##           Ruotsinkielisten osuus väestöstä, % 31.12.2012
## Äänekoski                                            0.1
## Ähtäri                                               0.1
##           Ulkomaiden kansalaisten osuus väestöstä, % 31.12.2012
## Äänekoski                                                   1.1
## Ähtäri                                                      0.8
##           Kuntien välinen muuttovoitto/-tappio, henkilöä 2012
## Äänekoski                                                 -67
## Ähtäri                                                    -35
##           Syntyneiden enemmyys, henkilöä 2012
## Äänekoski                                 -14
## Ähtäri                                    -20
##           Perheiden lukumäärä 31.12.2012
## Äänekoski                           5570
## Ähtäri                              1807
##           Valtionveronalaiset tulot, euroa/tulonsaaja  2011
## Äänekoski                                             23540
## Ähtäri                                                21744
##           Asuntokuntien lukumäärä 31.12.2012
## Äänekoski                               9624
## Ähtäri                                  2957
##           Vuokra-asunnossa asuvien asuntokuntien osuus, % 31.12.2012
## Äänekoski                                                       26.0
## Ähtäri                                                          20.3
##           Rivi- ja pientaloissa asuvien asuntokuntien osuus asuntokunnista, % 31.12.2012
## Äänekoski                                                                           65.1
## Ähtäri                                                                              86.8
##           Kesämökkien lukumäärä 31.12.2012
## Äänekoski                             2551
## Ähtäri                                1354
##           Vähintään keskiasteen tutkinnon suorittaneiden osuus 15 vuotta täyttäneistä, % 31.12.2011
## Äänekoski                                                                                      63.2
## Ähtäri                                                                                         64.2
##           Korkea-asteen tutkinnon suorittaneiden osuus 15 vuotta täyttäneistä, % 31.12.2011
## Äänekoski                                                                              19.5
## Ähtäri                                                                                 19.9
##           Kunnassa olevien työpaikkojen lukumäärä 31.12.2011
## Äänekoski                                               7972
## Ähtäri                                                  2453
##           Työllisten osuus 18-74-vuotiaista, % 31.12.2011
## Äänekoski                                            54.2
## Ähtäri                                               55.3
##           Työttömyysaste, % 31.12.2011
## Äänekoski                         15.5
## Ähtäri                            11.3
##           Kunnassa asuvan työllisen työvoiman määrä 31.12.2011
## Äänekoski                                                 7679
## Ähtäri                                                    2475
##           Asuinkunnassaan työssäkäyvien osuus työllisestä työvoimasta, % 31.12. 2011
## Äänekoski                                                                       77.3
## Ähtäri                                                                          77.3
##           Alkutuotannon työpaikkojen osuus, % 31.12.2011
## Äänekoski                                            2.8
## Ähtäri                                               9.1
##           Jalostuksen työpaikkojen osuus, % 31.12.2011
## Äänekoski                                         43.7
## Ähtäri                                            27.7
##           Palvelujen työpaikkojen osuus, % 31.12.2011
## Äänekoski                                        52.5
## Ähtäri                                           62.0
##           Toimialaltaan tuntemattomien työpaikkojen osuus, % 31.12.2011
## Äänekoski                                                           1.0
## Ähtäri                                                              1.2
##           Taloudellinen huoltosuhde, työvoiman ulkopuolella tai työttömänä olevat yhtä työllistä kohti 31.12.2011
## Äänekoski                                                                                                    1.65
## Ähtäri                                                                                                       1.59
##           Eläkkeellä olevien osuus väestöstä, % 31.12.2011
## Äänekoski                                             28.1
## Ähtäri                                                31.3
##           Yritystoimipaikkojen lukumäärä 2012     Kunta
## Äänekoski                                  NA Äänekoski
## Ähtäri                                    478    Ähtäri
{% endhighlight %}


List the province for each municipality in Finland:

{% highlight r %}

# Specific municipalities
m2p <- FindProvince(c("Helsinki", "Tampere", "Turku"))
head(m2p)
{% endhighlight %}



{% highlight text %}
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
{% endhighlight %}



{% highlight r %}

# All municipalities
m2p <- FindProvince(municipality.info.statfi$Kunta)

# Speeding up with predefined municipality info table:
m2p <- FindProvince(c("Helsinki", "Tampere", "Turku"), municipality.info.mml)
head(m2p)
{% endhighlight %}



{% highlight text %}
##          Helsinki           Tampere             Turku 
##         "Uusimaa"       "Pirkanmaa" "Varsinais-Suomi"
{% endhighlight %}


Convert municipality codes and names:

{% highlight r %}
municipality_ids <- ConvertMunicipalityCodes()
head(municipality_ids)
{% endhighlight %}



{% highlight text %}
##            id      name
## Äänekoski 992 Äänekoski
## Ähtäri    989    Ähtäri
## Akaa      020      Akaa
## Alajärvi  005  Alajärvi
## Alavieska 009 Alavieska
## Alavus    010    Alavus
{% endhighlight %}


Translate municipality names Finnish/English:


{% highlight r %}
translations <- LoadData("translations")
head(translations)
{% endhighlight %}



{% highlight text %}
##   Ã\u0085land Islands         South Karelia Southern Ostrobothnia 
##          "Ahvenanmaa"      "EtelÃĪ-Karjala"    "EtelÃĪ-Pohjanmaa" 
##      Southern Savonia                Kainuu       Tavastia Proper 
##         "EtelÃĪ-Savo"              "Kainuu"         "Kanta-HÃĪme"
{% endhighlight %}


### Retrieve population register data

Municipality-level population information from [Vaestorekisterikeskus](http://vrk.fi/default.aspx?docid=5127&site=3&id=0):


{% highlight r %}
df <- GetPopulationRegister()
head(df)
{% endhighlight %}



{% highlight text %}
##           Koodi     Kunta    Kommun  Male Female Total
## Äänekoski   992 Äänekoski Äänekoski 10187  10121 20308
## Ähtäri      989    Ähtäri    Etseri  3231   3222  6453
## Akaa        020      Akaa      Akaa  8452   8637 17089
## Alajärvi    005  Alajärvi  Alajärvi  5226   5214 10440
## Alavieska   009 Alavieska Alavieska  1420   1350  2770
## Alavus      010    Alavus    Alavus  4619   4634  9253
{% endhighlight %}


### Province information

Get information of Finnish provinces from Wikipedia:


{% highlight r %}
tab <- GetProvinceInfoWikipedia()
head(tab)
{% endhighlight %}



{% highlight text %}
##          Province  Area Population PopulationDensity
## 1         Uusimaa  9132    1550362             170.4
## 2 Varsinais-Suomi 10664     457789              42.9
## 3       Satakunta  7956     229360              28.8
## 4      Kanta-Häme  5199     169952              32.7
## 5       Pirkanmaa 12446     472181              37.9
## 6     Päijät-Häme  5127     199235              38.9
{% endhighlight %}


### Company subsidies from the Finnish government

Finnish broadcasting company YLE published a large data set on Finnish company subsidies ([(C) MOT 10.9.2012](http://ohjelmat.yle.fi/mot/10_9) over 15 years. See the site for more information; CC-BY-SA 3.0-license. 


{% highlight r %}
tuet <- GetMOTYritystuet()
{% endhighlight %}



{% highlight text %}
## Error: cannot open the connection
{% endhighlight %}



{% highlight r %}
head(tuet)
{% endhighlight %}



{% highlight text %}
## Error: object 'tuet' not found
{% endhighlight %}



### Visualization routines

Line fit with confidence smoothers:


{% highlight r %}
library(sorvi)
data(iris)
p <- vwReg(Sepal.Length ~ Sepal.Width, iris)
print(p)
{% endhighlight %}

![plot of chunk regressionline](../../figs/sorvi_tutorial/regressionline.png) 


Plot matrix:


{% highlight r %}
mat <- rbind(c(1, 2, 3), c(1, 3, 1), c(4, 2, 2))
pm <- PlotMatrix(mat, "twoway", midpoint = 2)
{% endhighlight %}

![plot of chunk unnamed-chunk-1](../../figs/sorvi_tutorial/unnamed-chunk-1.png) 

{% highlight r %}

# Plotting the scale sc <- PlotScale(pm$colors, pm$breaks)
{% endhighlight %}


## Licensing and Citations

This work can be freely used, modified and distributed under the 
[Two-clause FreeBSD license](http://en.wikipedia.org/wiki/BSD\_licenses).

Kindly cite the work, if appropriate, as 'Leo Lahti, Juuso Parkkinen
ja Joona Lehtomaki (2011). sorvi - suomalainen avoimen datan
tyokalupakki. URL: http://louhos.github.com/sorvi)'. A full list of
authors and contributors and the relevant contact information is
[here](http://louhos.github.com/contact).

## Session info


This vignette was created with


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
##  [1] RColorBrewer_1.0-5 ggplot2_0.9.3.1    XML_3.98-1.1      
##  [4] pxR_0.29           stringr_0.6.2      reshape_0.8.4     
##  [7] plyr_1.8.1         sorvi_0.4.24       helsinki_0.9.09   
## [10] maptools_0.8-29    sp_1.0-14          RCurl_1.95-4.1    
## [13] bitops_1.0-6       rjson_0.2.13       knitr_1.5         
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 dichromat_2.0-0  digest_0.6.4     evaluate_0.5.1  
##  [5] foreign_0.8-55   formatR_0.10     grid_3.0.2       gtable_0.1.2    
##  [9] labeling_0.2     lattice_0.20-27  MASS_7.3-29      munsell_0.4.2   
## [13] proto_0.3-10     Rcpp_0.11.0      reshape2_1.2.2   scales_0.2.3    
## [17] tools_3.0.2
{% endhighlight %}





