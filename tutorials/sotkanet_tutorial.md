---
title: sotkanet vignette
layout: package_page
package_name: sotkanet
package_name_show: sotkanet
author: Leo Lahti, Einari Happonen, Juuso Parkkinen, Joona Lehtomaki
meta_description: Sotkanet API R Tools
github_user: ropengov
package_version: 0.9.01
header_descripton: Sotkanet API R Tools
---



Sotkanet API R tools
===========

This is the [sotkanet](http://ropengov.github.com/sotkanet) R package to access data from the [Sotkanet portal](http://uusi.sotkanet.fi/portal/page/portal/etusivu/hakusivu) that provides over 2000 demographic indicators across Finland and Europe, maintained by the National Institute for Health and Welfare (THL). For more information, see [Sotkanet indicator database](http://uusi.sotkanet.fi/portal/page/portal/etusivu/tietoa_palvelusta) and [API description](http://uusi.sotkanet.fi/portal/pls/portal/!PORTAL.wwpob_page.show?_docname=22001.PDF). This package is part of [rOpenGov](http://ropengov.github.com/).


### Installation

Release version for general users:


{% highlight r %}
install.packages("sotkanet")
library(sotkanet)
{% endhighlight %}


Development version for developers:


{% highlight r %}
install.packages("devtools")
library(devtools)
install_github("sotkanet", "ropengov")
library(sotkanet)
{% endhighlight %}


### Listing available indicators

List available Sotkanet indicators:


{% highlight r %}
library(sotkanet)
sotkanet.indicators <- SotkanetIndicators(type = "table")
head(sotkanet.indicators)
{% endhighlight %}



{% highlight text %}
##   indicator
## 1         4
## 2         5
## 3         6
## 4         7
## 5        74
## 6       127
##                                                                            indicator.title.fi
## 1  Mielenterveyden häiriöihin sairaalahoitoa saaneet 0 - 17-vuotiaat / 1 000 vastaavanikäistä
## 2                     Toimeentulotukea saaneet 25-64-vuotiaat, % vastaavanikäisestä väestöstä
## 3 Somaattisen erikoissairaanhoidon hoitopäivät 75 vuotta täyttäneillä / 1000 vastaavanikäistä
## 4                                                                 0 - 6-vuotiaat, % väestöstä
## 5                                                      Yksinhuoltajaperheet, % lapsiperheistä
## 6                                                                               Väestö 31.12.
##   indicator.organization        indicator.organization.title.fi
## 1                      2 Terveyden ja hyvinvoinnin laitos (THL)
## 2                      2 Terveyden ja hyvinvoinnin laitos (THL)
## 3                      2 Terveyden ja hyvinvoinnin laitos (THL)
## 4                      3                          Tilastokeskus
## 5                      3                          Tilastokeskus
## 6                      3                          Tilastokeskus
{% endhighlight %}


List geographical regions with available indicators:


{% highlight r %}
sotkanet.regions <- SotkanetRegions(type = "table")
head(sotkanet.regions)
{% endhighlight %}



{% highlight text %}
##   region                 region.title.fi region.code     region.category
## 1    833          Etelä-Suomen AVIn alue           1 ALUEHALLINTOVIRASTO
## 2    834        Lounais-Suomen AVIn alue           2 ALUEHALLINTOVIRASTO
## 3    835            Itä-Suomen AVIn alue           3 ALUEHALLINTOVIRASTO
## 4    836 Länsi- ja Sisä-Suomen AVIn alue           4 ALUEHALLINTOVIRASTO
## 5    837        Pohjois-Suomen AVIn alue           5 ALUEHALLINTOVIRASTO
## 6    838                 Lapin AVIn alue           6 ALUEHALLINTOVIRASTO
##                           region.uri
## 1 http://www.yso.fi/onto/kunnat/ahv1
## 2 http://www.yso.fi/onto/kunnat/ahv2
## 3 http://www.yso.fi/onto/kunnat/ahv3
## 4 http://www.yso.fi/onto/kunnat/ahv4
## 5 http://www.yso.fi/onto/kunnat/ahv5
## 6 http://www.yso.fi/onto/kunnat/ahv6
{% endhighlight %}



### Querying SOTKAnet indicators

Get the [indicator 10013](http://uusi.sotkanet.fi/portal/page/portal/etusivu/hakusivu/metadata?type=I&indicator=10013) from Finland (Suomi) for 1990-2012 (Eurostat employment statistics youth unemployment), and plot a graph:


{% highlight r %}
# Get indicator data
dat <- GetDataSotkanet(indicators = 10013, years = 1990:2012, genders = c("female", 
    "male", "total"), region.category = "EUROOPPA", region = "Suomi")

# Investigate the first lines in the data
head(dat)
{% endhighlight %}



{% highlight text %}
##            region region.title.fi region.code region.category indicator
## 10013.1139   1022           Suomi         246        EUROOPPA     10013
## 10013.1140   1022           Suomi         246        EUROOPPA     10013
## 10013.1141   1022           Suomi         246        EUROOPPA     10013
## 10013.1142   1022           Suomi         246        EUROOPPA     10013
## 10013.1143   1022           Suomi         246        EUROOPPA     10013
## 10013.1144   1022           Suomi         246        EUROOPPA     10013
##                    indicator.title.fi year gender primary.value
## 10013.1139 (EU) Nuorisotyöttömyysaste 1991  total          16.3
## 10013.1140 (EU) Nuorisotyöttömyysaste 2010   male          23.8
## 10013.1141 (EU) Nuorisotyöttömyysaste 1996   male          29.5
## 10013.1142 (EU) Nuorisotyöttömyysaste 2000  total          21.4
## 10013.1143 (EU) Nuorisotyöttömyysaste 1995  total          29.7
## 10013.1144 (EU) Nuorisotyöttömyysaste 1998   male          22.8
##            absolute.value                indicator.organization.title.fi
## 10013.1139             NA Euroopan yhteisöjen tilastotoimisto (Eurostat)
## 10013.1140             NA Euroopan yhteisöjen tilastotoimisto (Eurostat)
## 10013.1141             NA Euroopan yhteisöjen tilastotoimisto (Eurostat)
## 10013.1142             NA Euroopan yhteisöjen tilastotoimisto (Eurostat)
## 10013.1143             NA Euroopan yhteisöjen tilastotoimisto (Eurostat)
## 10013.1144             NA Euroopan yhteisöjen tilastotoimisto (Eurostat)
{% endhighlight %}



{% highlight r %}

# Pick indicator name
indicator.name <- as.character(unique(dat$indicator.title.fi))
indicator.source <- as.character(unique(dat$indicator.organization.title.fi))

# Visualize
library(ggplot2, quietly = TRUE)
theme_set(theme_bw(20))
p <- ggplot(dat, aes(x = year, y = primary.value, group = gender, color = gender))
p <- p + geom_line() + ggtitle(paste(indicator.name, indicator.source, sep = " / "))
p <- p + xlab("Year") + ylab("Value")
p <- p + theme(title = element_text(size = 10))
p <- p + theme(axis.title.x = element_text(size = 20))
p <- p + theme(axis.title.y = element_text(size = 20))
p <- p + theme(legend.title = element_text(size = 15))
print(p)
{% endhighlight %}

![plot of chunk sotkanetData](../../figs/sotkanet_tutorial/sotkanetData.png) 



### Effect of municipality size

Smaller municipalities have more random variation.


{% highlight r %}
selected.indicators <- c("Väestö 31.12.", "Kuntien välinen nettomuutto / 1 000 asukasta")
selected.inds <- sotkanet.indicators$indicator[match(selected.indicators, sotkanet.indicators$indicator.title.fi)]
dat <- GetDataSotkanet(indicators = selected.inds, years = 2011, genders = c("total"))
datf <- dat[, c("region.title.fi", "indicator.title.fi", "primary.value")]
dw <- reshape(datf, idvar = "region.title.fi", timevar = "indicator.title.fi", 
    direction = "wide")
names(dw) <- c("Municipality", "Population", "Migration")
p <- ggplot(dw, aes(x = log10(Population), y = Migration)) + geom_point(size = 3)
p <- p + ggtitle("Migration vs. population size")
p <- p + theme(title = element_text(size = 15))
p <- p + theme(axis.title.x = element_text(size = 20))
p <- p + theme(axis.title.y = element_text(size = 20))
p <- p + theme(legend.title = element_text(size = 15))
print(p)
{% endhighlight %}

![plot of chunk sotkanetVisu3](../../figs/sotkanet_tutorial/sotkanetVisu3.png) 




### Fetch all SOTKAnet indicators

This takes for a long time and is not recommended for regular
use. Save the data on your local dissk for further work.



{% highlight r %}
# These indicators have problems with R routines:
probematic.indicators <- c(1575, 1743, 1826, 1861, 1882, 1924, 1952, 2000, 2001, 
    2033, 2050, 3386, 3443)

# Get data for all indicators
datlist <- list()
for (ind in setdiff(sotkanet.indicators$indicator, probematic.indicators)) {
    datlist[[as.character(ind)]] <- GetDataSotkanet(indicators = ind, years = 1990:2013, 
        genders = c("female", "male", "total"))
}

# Combine tables (this may require considerable time and memory for the full
# data set)
dat <- do.call("rbind", datlist)
{% endhighlight %}


For further usage examples, see
[Louhos-blog](http://louhos.wordpress.com), and
[takomo](https://github.com/louhos/takomo/tree/master/Sotkanet).


# Licensing and Citations

### SOTKAnet data

Cite SOTKAnet and link to [http://www.sotkanet.fi](http://www.sotkanet.fi/). Also mention indicator provider. 

 * [Full license and terms of use](http://uusi.sotkanet.fi/portal/page/portal/etusivu/tietoa_palvelusta). 

Central points:

 * SOTKAnet REST API is meant for non-regular data queries. Avoid regular and repeated downloads.
 * SOTKAnet API can be used as the basis for other systems
 * Metadata for regions and indicators are under [CC-BY 3.0](http://creativecommons.org/licenses/by/3.0/) 
 * THL indicators are under [CC-BY 3.0](http://creativecommons.org/licenses/by/3.0/) 
 * Indicators provided by third parties can be used only by separate agreement!


### SOTKAnet R package

This work can be freely used, modified and distributed under the
[Two-clause FreeBSD
license](http://en.wikipedia.org/wiki/BSD\_licenses). Kindly cite the
R package as 'Leo Lahti, Einari Happonen, Juuso Parkkinen ja Joona
Lehtomäki (2013). sotkanet R package. URL:
http://ropengov.github.io/sotkanet'.


### Session info


This vignette was created with


{% highlight r %}
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.0.2 (2013-09-25)
## Platform: x86_64-unknown-linux-gnu (64-bit)
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
## [1] ggplot2_0.9.3.1 sotkanet_0.9.01 rjson_0.2.13    knitr_1.5      
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4   dichromat_2.0-0    digest_0.6.4      
##  [4] evaluate_0.5.1     formatR_0.10       grid_3.0.2        
##  [7] gtable_0.1.2       labeling_0.2       MASS_7.3-29       
## [10] munsell_0.4.2      plyr_1.8           proto_0.3-10      
## [13] RColorBrewer_1.0-5 reshape2_1.2.2     scales_0.2.3      
## [16] stringr_0.6.2      tools_3.0.2
{% endhighlight %}

