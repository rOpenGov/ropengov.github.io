---
title: "R made personal (at least for swedes)!"
excerpt: "About the package 'sweidnumbr'"
author:
  name: Mans Magnusson and Erik Bulow
date: "2015-08-20 11:00:00"
output: html_document
layout: post
draft: false
categories: R
---


### Background

 -- Who are you? asked Mr Doe.
 
 -- I'm a Hindu! Namrata from India replied.
 
 -- I'm a statistician! said Günther from Germany.
 
People of different nationalities tend to identify themselves using different characteristics. In India, your identity might rely on your religion, while in other countries your profession might take its place. In Sweden, you might identify yourself with your almost-world-known (!?) personal identification number ("pin"). This 10 digit number is given to you almost immediately after birth and it often stays with you until your very last breath. The number is similar to a "social security number" but it has a much broader use and it is considered public. It is used in public registers (for education, work, tax payment, healthcare, car ownership etc) and it often serves as a membership number or customer id within companies and member unions. It is also essential for example in the public health and quality registers maintained in Sweden (and other Scandinavian countries) and used for reaserch.




### Motivation 

Naturally, the "pin" is used extensively to distinguish individuals in data sets analysed by R. The number also helps to match data from different sources and it can bring some demographic background data into the bargain, such as birth date (age), sex and geographic origin (depending on your birth year). 

Up until now however, with the lack of a consistent R convention to handle "pins", the number might be treated as either a 10 or 12 digit numeric (with or without century prefix), a character (with hyphen or a '+'-sign to distinguish birth date from suffix numbers) or as a factor variable. But the pin is not a number (to add, subtract or logarithm pins is just nonsense) and it contains more information than captured by the individual characters in a string. Luckily, the new R package `sweidnumbr` (released on CRAN) is here for rescue!





### Example

Let's look at some data (all pins are fake; they have a valid syntax but do not identify any real individuals):


{% highlight r %}
library(sweidnumbr)
{% endhighlight %}



{% highlight text %}
## sweidnumbr: R tools to handle swedish identity numbers.
## Copyright (C) 2014 Mans Magnusson, Erik Bulow
## https://github.com/rOpenGov/sweidnumbr
{% endhighlight %}



{% highlight r %}
knitr::kable(tail(fake_pins,10))
{% endhighlight %}



|   |pin           |name                  |
|:--|:-------------|:---------------------|
|53 |19471130-3022 |TWIST, LIS            |
|54 |19440311-1131 |NOBLESSE, RAGNAR JOHN |
|55 |20000805-0523 |NILSSON, CHOK         |
|56 |19240622-2286 |CADBURY, LOVISA       |
|57 |19020517-1798 |PLOPP, AUGUST         |
|58 |20050111-1123 |MINT, MARIA ADA       |
|59 |19370215-1590 |NILSSON, BARRY        |
|60 |19970430-3023 |BERG, ANTO            |
|61 |20031010-1023 |CENTER, PALL          |
|62 |20010218-1823 |CACAO, EDA            |

So far, pin is just a standard character vector but let's change that to benefit from all of `sweidnumbr`'s features:

{% highlight r %}
pin <- as.pin(fake_pins$pin)
{% endhighlight %}



{% highlight text %}
## Assumption: 
## pin of format YYMMDDNNNC is assumed to be less than 100 years old.
{% endhighlight %}



{% highlight r %}
str(pin)
{% endhighlight %}



{% highlight text %}
## Classes 'pin', 'character'  chr [1:62] "191212121212" "201212121212" "191212121212" "201212121212" ...
{% endhighlight %}


We can now also investigate some demographic characteristics almost on the fly (note that pins contained geographical information only up to 1989):

{% highlight r %}
par(mfrow = c(1,2))
hist(pin_age(pin), 20, col = "lightgreen", main = "Age distribution")
{% endhighlight %}



{% highlight text %}
## The age has been calculated at 2015-08-20.
{% endhighlight %}



{% highlight r %}
pie(table(pin_sex(pin)), main = "Sex distribution")
{% endhighlight %}

![center](/figs/2015-08-20-sweidnumber/unnamed-chunk-3-1.png) 

{% highlight r %}
pin_birthplace(pin[1:8])
{% endhighlight %}



{% highlight text %}
## [1] Stockholms län              Born after 31 december 1989
## [3] Stockholms län              Born after 31 december 1989
## [5] Born after 31 december 1989 Stockholm stad             
## [7] Stockholms län              Born after 31 december 1989
## 28 Levels: Stockholm stad Stockholms län Uppsala län ... Born after 31 december 1989
{% endhighlight %}
 
 
 
### Formats
 `as.pin` can recognize pins in several different formats such as:
 
 

{% highlight r %}
 as.pin(c("191212121212", "1212121212", "121212-1212", "121212+1212"))
{% endhighlight %}



{% highlight text %}
## Assumption: 
## pin of format YYMMDDNNNC is assumed to be less than 100 years old.
{% endhighlight %}



{% highlight text %}
## [1] "191212121212" "201212121212" "201212121212" "191212121212"
## Personal identity number(s)
{% endhighlight %}

It also checks that the numbers follow the correct pin syntax:

{% highlight r %}
as.pin("181212121212") # Pins were introduced in 1946 and only for people not deceased before that
{% endhighlight %}



{% highlight text %}
## Warning in as.pin.character("181212121212"): Erroneous pin(s) (set to NA).
{% endhighlight %}



{% highlight text %}
## [1] NA
## Personal identity number(s)
{% endhighlight %}



{% highlight r %}
pin_ctrl("191212121211") # The last digit is a control number that is checked against preceeding digits
{% endhighlight %}



{% highlight text %}
## [1] FALSE
{% endhighlight %}



{% highlight r %}
luhn_algo("191212121211") # The correct control number can be calculated by the Luhn algorithm
{% endhighlight %}



{% highlight text %}
## 'multiplier' set to: c(0, 0, 2, 1, 2, 1, 2, 1, 2, 1, 2, 0)
{% endhighlight %}



{% highlight text %}
## [1] 2
{% endhighlight %}



### Organisational numbers

Not only individual has their personal identification number, so do companies and NGO:s. These features are covered by the _oin_ group of 
functions in the package. Feel free to try them out ...

### Other countries

An analogous conversion function is availale for the Finnish social security numbers in the [sorvi](https://github.com/rOpenGov/sorvi/blob/master/vignettes/sorvi_tutorial.md) package.


### Keep in touch!
... and feel free to suggest enhancements and report bugs to https://github.com/rOpenGov/sweidnumbr/issues 
