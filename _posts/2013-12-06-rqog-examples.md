---
layout: post
title:  "rQog in action"
date:   2013-12-06 18:53:45

excerpt: "This post will demostrate the use of rQog-package"

author:
  name: Markus Kainu
  image: markus.jpg
---

## Introduction


Introduction here..


### Basic Data

Basic data has a limited selection of most common indicators incluidng totally 143 variables. Below is an example on how to extract data on human development index and Democracy (Freedom House/Polity) index from BRIC-countries and plot it.


{% highlight r %}
library(rQog)
{% endhighlight %}



{% highlight text %}
## Error: there is no package called 'rQog'
{% endhighlight %}



{% highlight r %}
dat <- getQogBasic(country = c("Russia","China","India","Brazil"), # country,countries
              indicator=c("undp_hdi","fh_polity2")) # indicator(s)
{% endhighlight %}



{% highlight text %}
## Error: could not find function "getQogBasic"
{% endhighlight %}



{% highlight r %}
library(ggplot2)
ggplot(dat, aes(x=year,y=value,color=cname)) + 
  geom_point() + geom_line() +
  geom_text(data=merge(dat,aggregate(year ~ cname, dat, max),
                     by=c("year","cname")),
          aes(x=year,y=value,label=cname),
          hjust=1,vjust=-1,size=3,alpha=.8) +
  facet_wrap(~indicator, scales="free") +
  theme(legend.position="none")
{% endhighlight %}



{% highlight text %}
## Error: object 'year' not found
{% endhighlight %}








[jekyll-gh]: https://github.com/mojombo/jekyll
[jekyll]:    http://jekyllrb.com
