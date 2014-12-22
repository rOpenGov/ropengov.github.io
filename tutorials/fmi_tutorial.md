---
title: fmi vignette
layout: tutorial_page
package_name: fmi
package_name_show: fmi
author: Jussi Jousimo
meta_description: Finnish Meteorological Institute open data API R client
github_user: ropengov
package_version: 0.1.11
header_descripton: Finnish Meteorological Institute open data API R client
---



Finnish Meteorological Institute (FMI) open data API client for R
===========

This R package (fmi) provides a client to access the [Finnish Meteorological Institute](http://en.ilmatieteenlaitos.fi/)
 (Ilmatieteenlaitos) [open data](http://en.ilmatieteenlaitos.fi/open-data).
This R package is a part of the [rOpenGov](http://ropengov.github.io) project.

## Installation

### Libraries

The fmi package depends on the [GDAL](http://www.gdal.org/) library and its [command line tools](http://www.gdal.org/ogr2ogr.html).
Please, see the installation instructions in the [gisfin package tutorial](https://github.com/rOpenGov/gisfin/blob/master/vignettes/gisfin_tutorial.md)
to install GDAL. If you have GDAL already installed, you might need to update it to newer version.
Also, add the command line tools to the search path of your system as follows:

#### Linux

In Linux, the tools should be found from the path by default after installation.
If not, use the `export` command from terminal, for example:
```
export PATH=$PATH:/usr/local/gdal/bin
```

#### OS X

From terminal, type:
```
export PATH=$PATH:/Library/Frameworks/GDAL.framework/Programs
```

#### Windows

Open System from Control Panel and select "Advanced System Settings".
Click "Environment Variables" and select "Path" Variable from the list.
Append `;C:\Program Files (x86)\GDAL` to the value field (note the semicolon).

#### ogr2ogr

Note that the actual location of GDAL may vary depending on your system. To test that the tools are found from the path,
type the command in terminal (Command Prompt in Windows):
```
ogr2ogr
```
To test that you also have a recent version of GDAL:
```
ogr2ogr --help
```
You should see the options `-splitlistfields` and `-explodecollections` in the printed help.
If not, you need to update GDAL.

### Packages

Start R and follow these steps to install the required packages:

{% highlight r %}
install.packages(c("devtools", "sp", "rgdal", "raster"))
library(devtools)
install_github("rOpenGov/rwfs")
{% endhighlight %}
Note that rgdal version 0.9-1 or newer is needed.
Then install the fmi package itself:

{% highlight r %}
install_github("rOpenGov/fmi")
{% endhighlight %}

## API key

In order to use the FMI API, you need to obtain a personal API key first.
To get the key, follow the instructions at <https://ilmatieteenlaitos.fi/rekisteroityminen-avoimen-datan-kayttajaksi>
(appears to be available only in Finnish).
Enter the API key from command line:

{% highlight r %}
apiKey <- "ENTER YOUR API KEY HERE"
{% endhighlight %}



{% highlight text %}
## Error in file(con, "r"): cannot open the connection
{% endhighlight %}

## Available data sets and filtering

FMI provides a brief introduction to the data sets at <http://en.ilmatieteenlaitos.fi/open-data-sets-available>.
A complete list of the available data sets and filtering parameters are described in
<http://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services>.
Each data set is referenced with a stored query id, for example the id for the daily weather time series
is `fmi::observations::weather::daily::timevaluepair`. This data set contains variables for
daily precipitation rate, mean temperature, snow depth, and minimum and maximum temperature,
see the description of [`fmi::observations::weather::daily::multipointcoverage`](http://en.ilmatieteenlaitos.fi/open-data-manual-fmi-wfs-services).
The data can be filtered with a number of parameters specific to each data set.
For example, the starting and the ending dates are provided by the `starttime` and `endtime`
parameters for the weather observations.

## Usage

### Request object

Queries to the FMI API are specified using an object of the class `FMIWFSRequest`. To initialize the object, type:

{% highlight r %}
library(fmi)
request <- FMIWFSRequest$new(apiKey=apiKey)
{% endhighlight %}

The fmi package provides two types of queries: a manual one for direct access to the FMI API and
an automated one for a convenient access obtaining the data sets.

In the manual case, stored query id and filter parameters are given with the `setParameters` method:

{% highlight r %}
request$setParameters(request="getFeature",
                      storedquery_id="fmi::observations::weather::daily::timevaluepair",
                      starttime="2014-01-01T00:00:00Z",
                      endtime="2014-01-01T00:00:00Z",
                      bbox="19.09,59.3,31.59,70.13",
                      parameters="rrday,snow,tday,tmin,tmax")
{% endhighlight %}
The parameter `request="getFeature"` must be specified always.

For the automated case, see below.

### Client object

Queries to the FMI API are made by using the `FMIWFSClient` class object. For example, a manual request is dispatched with
(continued from the previous example):

{% highlight r %}
client <- FMIWFSClient$new(request=request)
layers <- client$listLayers()
response <- client$getLayer(layer=layers[1], parameters=list(splitListFields=TRUE))
{% endhighlight %}
This example retrieves a list of data layers and the first layer is used to obtain the actual data. In fact, there is
only single layer.

For the same stored query, an automated request method, `getDailyWeather`, exists as well, which is a more
convenient way to retrieve the data. For example, to get all weather observations for the 1st of January in 2014:

{% highlight r %}
request <- FMIWFSRequest$new(apiKey=apiKey)
client <- FMIWFSClient$new(request=request)
response <- client$getDailyWeather(startDateTime="2014-01-01", endDateTime="2014-01-01", bbox=getFinlandBBox())
{% endhighlight %}
Here the function `getFinlandBBox` returns the bounding box surrounding the whole Finland.
See the package documentation in R for all available automated queries. Currently, the package supports only
a few data sets, which can be obtained using an automated query method. The rest of the stored queries are
available with the generic method `getLayer`.

As rgdal does not currently support direct queries to the FMI API, the client saves the response
to an intermedidate file first and then lets GDAL and rgdal to parse it. The `FMIWFSClient` class provides
a caching mechanism, so that the response is needed to be downloaded only once for the same subsequent queries.
The response file can be saved to a permanent location with the method `saveGMLFile` and loaded up into a
`FMIWFSClient` object again by referencing the file via a `GMLFile` object. GML files saved from the FMI API
directly can be loaded as well.

### Supported data and metadata

The fmi package supports time-value-pair and GRIB data formats. Multipoint-coverage format is not currently supported.
However, most of the multipoint-coverage data sets are availables in the time-value-pair format as well.

The automated queries attempt to associate appropriate metadata with the obtained data. The generic method `getLayer`
ignores the metadata and therefore it is left to the user to handle the metadata.
In case there is no documentation available, the metadata - or some of it - can be found from the actual XML
response retrieved from the FMI API. The XML response can be browsed by entering the query URL to a browser
or saving the response to a file first and then viewing it. A query URL can be printed from the request object
directly:

{% highlight r %}
request
{% endhighlight %}

For manual requests, coordinate reference system (if needed) must be specified manually by providing the `crs` argument
as a character string for the `getLayer` method. The default CRS appears to be WGS84. Furthermore, longitude and latitude
coordinates may need to be swapped, which can be done with the argument `swapAxisOrder=TRUE`. For example:

{% highlight r %}
response <- client$getLayer(layer="PointTimeSeriesObservation", crs="+proj=longlat +datum=WGS84", swapAxisOrder=TRUE, parameters=list(splitListFields=TRUE))
{% endhighlight %}
The last parameter `splitListFields=TRUE` asks the `ogr2ogr` tool bundled with the GDAL library
to convert the list fields to separate fields, so that rgdal can read the data properly.

### Redundant features

Some of the responses contain a redundant multipoint feature, which rgdal does not handle.
A workaround is to remove the feature using `ogr2ogr`.
In such case, `explodeCollections=TRUE` needs to be specified for the `getLayer` method, for example:

{% highlight r %}
response <- client$getLayer(layer="PointTimeSeriesObservation", parameters=list(explodeCollections=TRUE))
{% endhighlight %}

### Saving data and reading from file

Unprocessed data can be saved to a file with the `saveGMLFile` method and later processed by referencing
the file using a `GMLFile` object:

{% highlight r %}
request <- FMIWFSRequest$new(apiKey=apiKey)
client <- FMIWFSClient$new(request=request)
response <- client$getDailyWeather(startDateTime="2014-01-01", endDateTime="2014-01-02", bbox=getFinlandBBox())
tempFile <- tempfile()
client$saveGMLFile(destFile=tempFile)

request <- rwfs::GMLFile$new(tempFile)
client <- FMIWFSClient$new(request=request)
response <- client$getDailyWeather()
{% endhighlight %}

### Error handling

TODO

## Examples

### Manual request

Load the library:

{% highlight r %}
library(fmi)
{% endhighlight %}

Enter your API key for the examples:

{% highlight r %}
apiKey <- "ENTER YOUR API KEY HERE"
{% endhighlight %}

Construct a request object for the manual query:

{% highlight r %}
request <- FMIWFSRequest$new(apiKey=apiKey)
{% endhighlight %}



{% highlight text %}
## Error in public_bind_env$initialize(...): object 'apiKey' not found
{% endhighlight %}



{% highlight r %}
request$setParameters(request="getFeature",
                      storedquery_id="fmi::observations::weather::daily::timevaluepair",
                      starttime="2014-01-01",
                      endtime="2014-01-02",
                      bbox="19.09,59.3,31.59,70.13",
                      parameters="rrday,snow,tday,tmin,tmax")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'request' not found
{% endhighlight %}
The time parameters can be provided as objects that can be converted to the `POSIXlt` objects and
bbox as an `extent` object from the [`raster`](http://cran.r-project.org/web/packages/raster/index.html)
package as well.

Set up a client object and list the layers in the response:

{% highlight r %}
client <- FMIWFSClient$new(request=request)
{% endhighlight %}



{% highlight text %}
## Error in inherits(request, "WFSRequest"): object 'request' not found
{% endhighlight %}



{% highlight r %}
layers <- client$listLayers()
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'client' not found
{% endhighlight %}

{% highlight r %}
layers
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'layers' not found
{% endhighlight %}

Parse the data from the response, which has been cached:

{% highlight r %}
response <- client$getLayer(layer=layers[1], crs="+proj=longlat +datum=WGS84", swapAxisOrder=TRUE, parameters=list(splitListFields=TRUE))
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'client' not found
{% endhighlight %}

{% highlight r %}
library(sp)
head(cbind(coordinates(response), response@data[,c("name1","time1","result_MeasurementTimeseries_point_MeasurementTVP_value1","time2","result_MeasurementTimeseries_point_MeasurementTVP_value2")]))
{% endhighlight %}



{% highlight text %}
## Error in coordinates(response): error in evaluating the argument 'obj' in selecting a method for function 'coordinates': Error: object 'response' not found
{% endhighlight %}
The data is returned as a `SpatialPointsDataFrame` object in "wide" format so that there is a row for each
variable and observation location, but for each day (two days here) there are columns for time and observation
indexed with a sequential number. The columns starting with `time` contains the time and the columns
`result_MeasurementTimeseries_point_MeasurementTVP_value` the measurements, which are organized so that
the variables `rrday, snow, tday, tmin, tmax` are repeated in the same order as specified in the request. 

### Automated request

The method `getDailyWeather` provides an automated query for the daily weather time series:

{% highlight r %}
request <- FMIWFSRequest$new(apiKey=apiKey)
{% endhighlight %}



{% highlight text %}
## Error in public_bind_env$initialize(...): object 'apiKey' not found
{% endhighlight %}



{% highlight r %}
client <- FMIWFSClient$new(request=request)
{% endhighlight %}



{% highlight text %}
## Error in inherits(request, "WFSRequest"): object 'request' not found
{% endhighlight %}



{% highlight r %}
response <- client$getDailyWeather(startDateTime="2014-01-01", endDateTime="2014-01-02", bbox=getFinlandBBox())
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'client' not found
{% endhighlight %}

{% highlight r %}
head(cbind(coordinates(response), response@data[,c("name1","time","variable","measurement")]))
{% endhighlight %}



{% highlight text %}
## Error in coordinates(response): error in evaluating the argument 'obj' in selecting a method for function 'coordinates': Error: object 'response' not found
{% endhighlight %}
The automated method sets the known parameters automatically and returns cleaner result
by combining the data with metadata data and converting the "wide" format to long format.

### Raster

To request continuous space data manually, use the `getRaster` method, for instance:

{% highlight r %}
library(raster)
request <- FMIWFSRequest$new(apiKey=apiKey)
{% endhighlight %}



{% highlight text %}
## Error in public_bind_env$initialize(...): object 'apiKey' not found
{% endhighlight %}



{% highlight r %}
request$setParameters(request="getFeature",
                      storedquery_id="fmi::observations::weather::monthly::grid",
                      starttime="2012-01-01",
                      endtime="2012-01-01")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'request' not found
{% endhighlight %}



{% highlight r %}
client <- FMIWFSClient$new(request=request)
{% endhighlight %}



{% highlight text %}
## Error in inherits(request, "WFSRequest"): object 'request' not found
{% endhighlight %}



{% highlight r %}
response <- client$getRaster(parameters=list(splitListFields=TRUE))
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'client' not found
{% endhighlight %}
The response is returned as a `RasterBrick` object of the `raster` package:

{% highlight r %}
response
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'response' not found
{% endhighlight %}
Set the NA value and plot the interpolated monthly mean temperature in January 2012:

{% highlight r %}
NAvalue(response) <- 9999
{% endhighlight %}



{% highlight text %}
## Error in NAvalue(response) <- 9999: object 'response' not found
{% endhighlight %}



{% highlight r %}
plot(response[[1]])
{% endhighlight %}



{% highlight text %}
## Error in plot(response[[1]]): error in evaluating the argument 'x' in selecting a method for function 'plot': Error: object 'response' not found
{% endhighlight %}

There is also the automated request method `getMonthlyWeatherRaster` for obtaining monthly weather data:

{% highlight r %}
request <- FMIWFSRequest$new(apiKey=apiKey)
{% endhighlight %}



{% highlight text %}
## Error in public_bind_env$initialize(...): object 'apiKey' not found
{% endhighlight %}



{% highlight r %}
client <- FMIWFSClient$new(request=request)
{% endhighlight %}



{% highlight text %}
## Error in inherits(request, "WFSRequest"): object 'request' not found
{% endhighlight %}



{% highlight r %}
response <- client$getMonthlyWeatherRaster(startDateTime="2012-01-01", endDateTime="2012-02-01")
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'client' not found
{% endhighlight %}

The method sets the raster band names to match the variable name and the dates:

{% highlight r %}
names(response)
{% endhighlight %}



{% highlight text %}
## Error in eval(expr, envir, enclos): object 'response' not found
{% endhighlight %}

## Licensing and further information

For the open data license, see <http://en.ilmatieteenlaitos.fi/open-data-licence>. Further information about
the open data and the API is provided by the FMI at <http://en.ilmatieteenlaitos.fi/open-data>.

## Citing the R package

This work can be freely used, modified and distributed under the
[Two-clause FreeBSD license](http://en.wikipedia.org/wiki/BSD\_licenses). Kindly cite the
R package as 'Jussi Jousimo et al. (C) 2014. fmi R package. URL: http://www.github.com/rOpenGov/fmi'.

## Session info

This tutorial was created with


{% highlight text %}
## R version 3.1.2 (2014-10-31)
## Platform: x86_64-apple-darwin13.4.0 (64-bit)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] methods   stats     graphics  grDevices utils     datasets  base     
## 
## other attached packages:
## [1] raster_2.3-12 sp_1.0-15     fmi_0.1.11    R6_2.0        knitr_1.8    
## 
## loaded via a namespace (and not attached):
## [1] digest_0.6.4    evaluate_0.5.5  formatR_1.0     grid_3.1.2     
## [5] lattice_0.20-29 rgdal_0.8-16    rwfs_0.1.11     stringr_0.6.2  
## [9] tools_3.1.2
{% endhighlight %}
