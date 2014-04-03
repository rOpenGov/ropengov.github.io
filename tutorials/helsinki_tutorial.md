---
title: helsinki vignette
layout: tutorial_page
package_name: helsinki
package_name_show: helsinki
author: Leo Lahti, Juuso Parkkinen, Joona Lehtomaki
meta_description: Helsinki R Tools
github_user: ropengov
package_version: 0.9.09
header_descripton: Helsinki R Tools
---



Helsinki  R tools
===========

The helsinki R package is part of the
[rOpenGov](http://ropengov.github.com/helsinki) project.


### Installation

Release version for general users (NOT AVAILABLE YET!)


{% highlight r %}
# install.packages('helsinki') library(helsinki)
{% endhighlight %}


Development version for developers:


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("helsinki", "ropengov")
library(helsinki)
{% endhighlight %}


Further installation and development instructions at the [home
page](http://ropengov.github.com/helsinki).


## Helsinki region environmental services (Helsingin seudun ympäristöpalvelut HSY)



### Population grid

Download population information from [HSY database](http://www.hsy.fi/seututieto/kaupunki/paikkatiedot/Sivut/Avoindata.aspx) ((C) 2011 HSY) and visualize on the Helsinki map. For data documentation, see [HSY website](http://www.hsy.fi/seututieto/Documents/Paikkatiedot/Tietokuvaukset_kaikki.pdf). Population size, density, and age structure per grid.


{% highlight r %}
# http://ropengov.github.com/helsinki
library(helsinki)

# Get population grid (Vaestotietoruudukko)
sp <- get_HSY_data("Vaestotietoruudukko")

# Visualize population grid library(gisfi) Define limits of the color scale
# at <- c(seq(0, 2000, 250), Inf) q <- PlotShape(sp, 'ASUKKAITA', type =
# 'oneway', at = at, ncol = length(at))
{% endhighlight %}


Inspect data manually. Some rarely populated grids are censored with
'99' to guarantee privacy.


{% highlight r %}
df <- as.data.frame(sp)
head(df)
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

Information of buildings in Helsinki region. Data obtained from (C)
HSY 2011. Grid-level (500mx500m) information on building counts
(lukumaara), built area (kerrosala), usage (kayttotarkoitus), region
efficiency (aluetehokkuus).


{% highlight r %}
sp <- get_HSY_data("Rakennustietoruudukko")
df <- as.data.frame(sp)
head(df)
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

Building area capacity per municipal region (kaupunginosittain summattu tieto rakennusmaavarannosta). Data obtained from (C) HSY 2011. 


{% highlight r %}
sp <- get_HSY_data("seutuRAMAVA_kosa")
{% endhighlight %}



{% highlight text %}
## Error: Invalid 'which.data' argument
{% endhighlight %}



{% highlight r %}
df <- as.data.frame(sp)
head(df)
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



### Further HSY data

[HSY website](http://www.hsy.fi/seututieto/kaupunki/paikkatiedot/Sivut/Avoindata.aspx) has data for 2010-2011. More is coming, add later and allow temporal analysis.


## Helsinki Real Estate Department (Helsingin kaupungin kiinteistövirasto, HKK)

Retrieve [HKK](http://kartta.hel.fi/avoindata/index.html) data sets.

### Helsinki address information


{% highlight r %}
dat <- get_HKK_address_data("Helsingin osoiteluettelo")
head(dat)
{% endhighlight %}



{% highlight text %}
##           katunimi osoitenumero osoitenumero2 osoitekirjain       N
## 1         Haapatie           24            NA             b 6682555
## 2        Pallokuja           12            NA               6678084
## 3       Poutunkuja            4            NA               6678926
## 4       Haukkakuja            1            NA               6683284
## 5       Haukkakuja            4            NA               6683307
## 6 Merikapteenintie            4            NA               6681909
##          E kaupunki           gatan      staden tyyppi tyyppi_selite
## 1 25499401 Helsinki        Aspvägen Helsingfors      1  osoite, katu
## 2 25508664 Helsinki     Bollgränden Helsingfors      1  osoite, katu
## 3 25494428 Helsinki   Pouttugränden Helsingfors      1  osoite, katu
## 4 25503858 Helsinki     Falkgränden Helsingfors      1  osoite, katu
## 5 25503852 Helsinki     Falkgränden Helsingfors      1  osoite, katu
## 6 25512316 Helsinki Sjökaptensvägen Helsingfors      1  osoite, katu
{% endhighlight %}



{% highlight r %}
dat <- get_HKK_address_data("Seudullinen osoiteluettelo")
head(dat)
{% endhighlight %}



{% highlight text %}
##          katunimi osoitenumero osoitenumero2 osoitekirjain       N
## 1    Gråängsvägen            0            NA               6673565
## 2        Grådalen            0            NA               6673640
## 3      Lillaisarn            0            NA               6665767
## 4 Herrö Träskholm            0            NA               6663250
## 5      Stora Bodö            0            NA               6666765
## 6      Torraisarn            0            NA               6664992
##          E kaupunki            gatan staden tyyppi   tyyppi_selite
## 1 25478911    Espoo  Harmaaniityntie   Esbo      1 osoite tai katu
## 2 25478711    Espoo     Harmaalaakso   Esbo      1 osoite tai katu
## 3 25483084    Espoo       Lillaisarn   Esbo      1 osoite tai katu
## 4 25481439    Espoo Herrön Träskholm   Esbo      1 osoite tai katu
## 5 25485583    Espoo       Stora Bodö   Esbo      1 osoite tai katu
## 6 25482421    Espoo       Torraisarn   Esbo      1 osoite tai katu
{% endhighlight %}



### Licensing and Citations

This work can be freely used, modified and distributed under the
[Two-clause FreeBSD
license](http://en.wikipedia.org/wiki/BSD\_licenses). Cite Helsinki R
package and and the appropriate data provider, including a url
link. Kindly cite the R package as 'Leo Lahti, Juuso Parkkinen ja
Joona Lehtomäki (2013-2014). helsinki R package. URL:
http://ropengov.github.io/helsinki'.

For further usage examples, see
[Louhos-blog](http://louhos.wordpress.com) and
[takomo](https://github.com/louhos/takomo/tree/master/Helsinki).


### Session info


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
## [1] helsinki_0.9.09 maptools_0.8-29 sp_1.0-14       RCurl_1.95-4.1 
## [5] bitops_1.0-6    rjson_0.2.13    knitr_1.5      
## 
## loaded via a namespace (and not attached):
## [1] evaluate_0.5.1  foreign_0.8-55  formatR_0.10    grid_3.0.2     
## [5] lattice_0.20-27 stringr_0.6.2   tools_3.0.2
{% endhighlight %}


