

## Preface

This demo blog post uses a very developmental version of `fmi`. To run the demo
on your own computer, you will have to do the following:


{% highlight r %}
# fmi depends on rwfs
install_github("ropengov/rwfs")
install_github("ropengov/fmi")
{% endhighlight %}

## Accessing FMI weather station data using package fmi

As explained in the [previous post](https://ropengov.github.io/general/2014/09/30/fmi/), 
package [`fmi`](https://github.com/rOpenGov/fmi) brings various kinds of data
from the Finnish Meteorological Institute's (FMI) open API to R. The work on the
package is still very much in progress, but when I got asked if it's 
possible to get location (i.e. wheather station) specific precipitation and 
temperature data for a specific time period, I decided to take `fmi` for a spin.

FMI deserves compliments for the implemenetation of an open API, but the 
documentation of some of the API parameters has left room for improvement. 
For some lively discussion (in Finnish), see [here](https://www.facebook.com/groups/fi.okfn/permalink/10152804124115628/).
Fortunately, method [getDailyWeather()](https://github.com/rOpenGov/fmi/blob/master/vignettes/fmi_tutorial.md#automated-request) in `fmi` returns the necessary 
measurements (precipitation and temperature) as is, so no need to figure out the
specific parameter values for the request. A 
[little more digging](http://data.fmi.fi/fmi-apikey/cdc84a28-60b7-44c3-ad5d-442d34edc435/meta?observableProperty=observation&param=rrday,tday,snow,tmin,tmax&language=eng) 
does reveal however more information for example on the units used to record the
measurements. Hand picking the information from the XML reveals the following
table:

| Parameter | Label | Base phenomenon | Unit | Stat function | Agg time period |
|-----------|-------|-----------------|------|---------------|-----------------|
| rrday | Precipitation amount | Amount of precipitation | mm | acc | PT24H|
| snow | Snow depth | Snow cover | cm | instant | PT1M |
| tday | Air temperature | Temperature | degC | avg | P1D |
| tmax | Maximum temperature | Temperature | degC | max | PT24H |
| tmin | Minimum temperature | Temperature | degC | min | PT24H |

So far so good, `rrday` and `tday` should do the trick. However, we still need
to be able to query a specific weather station, for which we need some sort of
an identifier. The location we're interested is Kiutaköngäs in Kuusamo, a rather
spectacular section of rapids in the river Oulanka located right next to the 
[Oulanka national park](https://en.wikipedia.org/wiki/Oulanka_National_Park):

![Kiutaköngäs](http://static.panoramio.com/photos/large/1735117.jpg)

It turns out (not by coincidence) that FMI has an active observation station 
located at Kiutaköngäs. It may be possible to get a full list of weather 
stations throught the FMI API itself, but so far `fmi` does not know anything 
about it. In the meanwhile, I scraped 
[a table of observation stations](http://en.ilmatieteenlaitos.fi/observation-stations) 
from the FMI web site, and created a utility function `fmi_weather_stations()` 
in `fmi`. The function returns a dataframe of all active observation stations:


{% highlight text %}
##                               Nimi FMISID LPNN   WMO    Lat    Lon Korkeus    Ryhmät Alkaen
## 1                   Alajärvi Möksy 101533 3314  2787  63,09  24,26     170 Sääasemat   1996
## 2                   Antarktis Aboa 112275 9950 89014 -73,05 -13,38     497 Sääasemat   2003
## 3          Asikkala Pulkkilanharju 101185 1434  2727  61,27  25,52      80 Sääasemat   1991
## 4 Enontekiö Kilpisjärvi kyläkeskus 102016 9003  2801  69,05  20,79     480 Sääasemat   1983
## 5      Enontekiö Kilpisjärvi Saana 102017 9004  2701  69,04  20,85    1002 Sääasemat   1991
## 6             Enontekiö lentoasema 101976 8208  2802  68,36  23,43     306 Sääasemat   1999
{% endhighlight %}

Using column `FMISID` seems promising, and with a little skimming through the
table, we can locate the correct station:


{% highlight r %}
kiutakongas.station <- stations[99,]
kiutakongas.station
{% endhighlight %}



{% highlight text %}
##                   Nimi FMISID LPNN  WMO   Lat   Lon Korkeus    Ryhmät Alkaen
## 99 Kuusamo Kiutaköngäs 101887 6802 2811 66,37 29,31     165 Sääasemat   1966
{% endhighlight %}

The convience methods in `fmi` took a little adjusting, but afterwards it is
possible to use `FMISID` in the query paramaters. Following the `fmi` tutorial,
it is now possible to do the following. **NOTE!** You will need to provide
your own apiKey first:


{% highlight r %}
apiKey <- "ENTER YOUR API KEY HERE"
{% endhighlight %}





{% highlight r %}
# Set the correct FMISID
fmisid.kiuta <- kiutakongas.station$FMISID

request <- FMIWFSRequest$new(apiKey=apiKey)
  
request$setParameters(request="getFeature",
                      storedquery_id="fmi::observations::weather::daily::timevaluepair",
                      parameters="rrday,snow,tday,tmin,tmax")
  
client <- FMIWFSClient$new(request=request)
  
response <- client$getDailyWeather(startDateTime="2014-01-01T00:00:00Z",
                                   endDateTime="2014-01-01T00:00:00Z",
                                   fmisid=fmisid.kiuta)
{% endhighlight %}



{% highlight text %}
## OGR data source with driver: GML 
## Source: "/tmp/Rtmp1zJKO6/file1661241c0cf4", layer: "PointTimeSeriesObservation"
## with 5 features and 13 fields
## Feature type: wkbPoint with 2 dimensions
{% endhighlight %}

Obviously we are usually interested in time periods longer than one day. In
addition, massaging the data returned by `getDailyWeather()` still takes a
little manual work. Wrapping this manual work into an utility function:


{% highlight r %}
# dplyr FTW!
library(dplyr)

get_weather_data <- function(apiKey, startDateTime, endDateTime, fmisid) {

  request <- FMIWFSRequest$new(apiKey=apiKey)
  
  request$setParameters(request="getFeature",
                        storedquery_id="fmi::observations::weather::daily::timevaluepair",
                        parameters="rrday,snow,tday,tmin,tmax")
  
  client <- FMIWFSClient$new(request=request)
  response <- client$getDailyWeather(startDateTime=startDateTime,
                                     endDateTime=endDateTime,
                                     fmisid=fmisid)
  dat <- as.data.frame(response)
  
  # Get the variable names
  var.names <- dplyr::select(dat, variable) 
  
  # Manual splicing and dicing
  # Get just the times and values
  measurements <- dplyr::select(dat, -fid, -gml_id, -beginPosition, -endPosition,
                                -timePosition, -value, -identifier, -name1, 
                                -name2, -name3, -region, -coords.x2, 
                                -coords.x1)
  measurements$time <- as.Date(measurements$time)
  measurements$measurement <- as.numeric(measurements$measurement)
  
  return(measurements)
}
{% endhighlight %}

Using the above created function simplifies querying. For demonstration, let's
get data for the whole year 2012:


{% highlight r %}
startDateTime <- "2012-01-01"
endDateTime <- "2012-12-31"

kiuta.2012 <- get_weather_data(apiKey, startDateTime, endDateTime, fmisid.kiuta)
{% endhighlight %}



{% highlight text %}
## OGR data source with driver: GML 
## Source: "/tmp/Rtmp1zJKO6/file166133babf98", layer: "PointTimeSeriesObservation"
## with 5 features and 743 fields
## Feature type: wkbPoint with 2 dimensions
{% endhighlight %}

Let's take a look at the measurement data (first 2 days):

{% highlight r %}
head(kiuta.2012, 10)
{% endhighlight %}



{% highlight text %}
##          time variable measurement
## 1  2012-01-01    rrday        -1.0
## 2  2012-01-01     snow        50.0
## 3  2012-01-01     tday        -6.0
## 4  2012-01-01     tmin        -9.8
## 5  2012-01-01     tmax        -3.6
## 6  2012-01-02    rrday         0.5
## 7  2012-01-02     snow        47.0
## 8  2012-01-02     tday        -7.9
## 9  2012-01-02     tmin        -9.8
## 10 2012-01-02     tmax        -6.7
{% endhighlight %}

The measurements may contain NAs and values -1, which I suspect may also have
something to do with missing values but can't say for sure.

For comparisons sake, let's also get some data from Kaisaniemi (Helsinki)
observation station:


{% highlight r %}
fmisid.kaisa <- stations[24,]$FMISID

kaisa.2012 <- get_weather_data(apiKey, startDateTime, endDateTime, fmisid.kaisa)
{% endhighlight %}



{% highlight text %}
## OGR data source with driver: GML 
## Source: "/tmp/Rtmp1zJKO6/file16613a3af2a", layer: "PointTimeSeriesObservation"
## with 5 features and 743 fields
## Feature type: wkbPoint with 2 dimensions
{% endhighlight %}

### Plotting

Let's inspect the data by some plotting. First, however, some more data
processing:


{% highlight r %}
kiuta.2012$location <- "Kuusamo, Kiutaköngäs"

kaisa.2012$location <- "Helsinki, Kaisaniemi"

dat <- rbind(kiuta.2012, kaisa.2012)
{% endhighlight %}

First, lets plot the minimum (`tmin`), average (`tday`) and maximum (`tmax`) 
temperature per day over year 2012. Plotting below uses 
[a custom theme](theme.R) for `ggplot2`.


{% highlight r %}
library(ggplot2)

p <- ggplot(dplyr::filter(dat, variable %in% c("tday", "tmax", "tmin")), aes(x=time, y=measurement, color=variable))
p + geom_line() + facet_wrap(~ location, ncol=1) + ylab("Temperature (C)\n") +
  xlab("\nDate") + custom.theme
{% endhighlight %}

![plot of chunk plot-temperature](figure/plot-temperature-1.png) 

While we're at it, let's also plot the snowdepth:


{% highlight r %}
p <- ggplot(dplyr::filter(dat, variable == "snow"), aes(x=time, y=measurement, color=location))
p + geom_line(size=1) + xlab("\nDate") + ylab("Snowdepth (cm)\n") + custom.theme
{% endhighlight %}

![plot of chunk plot-snowdepth](figure/plot-snowdepth-1.png) 

Finally, let's take look at precipitation measurement values and their means:


{% highlight r %}
p <- ggplot(dplyr::filter(dat, variable == "rrday"), aes(x=time, y=measurement, color=location))
p + geom_point(alpha=1/3) + stat_smooth(method="loess", size=1) + xlab("\nDate") + 
  ylab("Precipitation (mm)\n") + custom.theme
{% endhighlight %}

![plot of chunk plot-precipitation](figure/plot-precipitation-1.png) 

That's it, a small demo on how to use `fmi` package for fetching observation
station specific data.


{% highlight r %}
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.1.1 (2014-07-10)
## Platform: x86_64-suse-linux-gnu (64-bit)
## 
## locale:
##  [1] LC_CTYPE=en_US.UTF-8      LC_NUMERIC=C              LC_TIME=en_US.utf8        LC_COLLATE=en_US.utf8    
##  [5] LC_MONETARY=en_US.utf8    LC_MESSAGES=en_US.utf8    LC_PAPER=en_US.utf8       LC_NAME=C                
##  [9] LC_ADDRESS=C              LC_TELEPHONE=C            LC_MEASUREMENT=en_US.utf8 LC_IDENTIFICATION=C      
## 
## attached base packages:
## [1] grid      stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] reshape2_1.4.1 ggplot2_1.0.0  dplyr_0.3.0.2  fmi_0.1.12     R6_2.0.1       knitr_1.8      devtools_1.6.1
## 
## loaded via a namespace (and not attached):
##  [1] assertthat_0.1   colorspace_1.2-4 DBI_0.3.1        digest_0.6.7     evaluate_0.5.5   formatR_1.0     
##  [7] gtable_0.1.2     htmltools_0.2.6  labeling_0.3     lattice_0.20-29  lazyeval_0.1.9   magrittr_1.5    
## [13] MASS_7.3-33      munsell_0.4.2    parallel_3.1.1   plyr_1.8.1       proto_0.3-10     raster_2.3-12   
## [19] Rcpp_0.11.3      rgdal_0.9-1      rmarkdown_0.4.2  rwfs_0.1.12      scales_0.2.4     sp_1.0-16       
## [25] stringr_0.6.2    tools_3.1.1
{% endhighlight %}
