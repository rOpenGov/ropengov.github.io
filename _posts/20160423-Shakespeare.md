---
title: "Shakespeare! Cervantes! 400! A statistical analysis of the early modern printing of the Bard and Don Quixote"
author: "Leo Lahti and Mikko Tolonen"
date: "2016-04-23 12:00:00"
excerpt: Shakespeare 400 years !
layout: post
draft: false
categories: R
---

 


We are a team of an early modern intellectual historian ([Mikko
Tolonen](https://twitter.com/mikko_tolonen)) and a computational
scientist and bioinformatician ([Leo
Lahti](http://www.iki.fi/Leo.Lahti)). Often on Friday nights we skype
to discuss digital humanities, a field that nicely combines our mutual
interests in science and philosophy. Today’s task was to do something
to celebrate the 400th anniversary of Shakespeare & Cervantes.

We decided to build on our peculiar interest in [library
catalogues](https://www.liberquarterly.eu/article/10.18352/lq.10112/)
by focusing on [CERL Heritage of the Printed Book Catalogue
(HPB)](https://www.cerl.org/resources/hpb/main) and [British Library’s
English Short-Title Catalogue
(ESTC)](http://estc.bl.uk/F/?func=file&file_name=login-bl-estc). We
then carried out a brief but revealing analysis concerning the early
modern publishing (1593-1800) of Shakespeare and Cervantes. Check
below for some graphs that we wanted to share as you might also find
them interesting.

In the ESTC and CERL catalogues, we have metadata on roughly 0.5 and 5
million documents, respectively, between 1470-1800. With a combination
of [automated](https://github.com/rOpenGov/estc) and manual data
processing, we identified 1271 documents for
Shakespeare (ESTC 1042;
CERL 229), and 488
documents for Cervantes (ESTC
94; CERL 394). All
illustrations are based on the combined data from these two catalogues
unless otherwise mentioned.


### Relative publishing activity: Shakespeare

One thing that we have learned about author lives when analysing publishing activity is that printing usually ends (more rapidly than you think) when the author kicks the bucket. That is, death is the end of popularity. Well, obviously this is not the case for Shakespeare. But do note that the new rise in publishing Shakespeare (based on ESTC data) begins in the 1730s with the input of the famous Tonson publishing house (see also Shakespeare publisher timeline below). The first graph illustrates the fraction of titles from Shakespeare relative to all other publishing activity in the ESTC catalogue.

<img src="/figs/20160423-Shakespeare/shakespeare-versusother-1.png" title="center" alt="center" width="700px" />


### Shakespeare play categories
 
We classified Shakespeare’s plays into tragedies, comedies and
histories. Besides the 1730s peak, histories seem to be less popular
than comedies and tragedies when published as single plays. Another
observation: early 18th-century seems to be a more “tragedy-driven”
era compared to few decades later in the high-Enlightenment when we
witness the new rise of comedies. 


<img src="/figs/20160423-Shakespeare/shakespeare-tragedyvscomedy-1.png" title="center" alt="center" width="700px" />


### Shakespeare title popularity
 
No real surprises here. Collected works and plays are of course an important source to access Shakespeare. But in the Top-5 list of single plays Hamlet, Romeo and Juliet, Macbeth and Othello are where you might expect to find them. Perhaps slightly surprising is that Julius Caesar beats Merchant of Venice and Merry Wives of Windsor. 


<img src="/figs/20160423-Shakespeare/shakespeare-titles-1.png" title="center" alt="center" width="400px" /><img src="/figs/20160423-Shakespeare/shakespeare-titles-2.png" title="center" alt="center" width="400px" />


### Cervantes popularity
 
What is telling when comparing Cervantes on the continent and his popularity in the English-speaking world is that Galatea (Cervantes’s first published work) does very well on the continent, but is not published in English during the early modern period. At the same time it is very clear that Don Quixote is THE single work by any author in early modern Europe (including the English-speaking world).
 

<img src="/figs/20160423-Shakespeare/shakespeare-cervantes-1.png" title="center" alt="center" width="800px" />


### Comparison of popular titles
 
On this timeline we see a very interesting contest. Don Quixote’s train-like rise throughout the early modern era is impressive indeed. Hamlet sees an interesting peak in English-speaking world in 1750s to be followed by the rise of the comedies and rapid sinking of the publishing of the Danish prince. Same thing happens to Romeo and Juliet shortly after. Macbeth on the other hand seems to follow a different, upward path towards the late eighteenth century. 


<img src="/figs/20160423-Shakespeare/shakespeare-titles2-1.png" title="center" alt="center" width="700px" />


### Shakespeare publisher timeline
 
There exists great scholarship on Shakespeare’s copyrights in the eighteenth century by Terry Belanger. While we are well aware of the division of Shakespeare copyrights between different publishers and the use of printing congers, what we want to highlight here is the relevance of Tonson publishing house and the role played by John Bell towards the later eighteenth century in promoting Shakespeare in Britain (for Bell as ['bibliographic nightmare'](http://collation.folger.edu/2012/06/john-bell-bibliographic-nightmare/). The illustration is based on the ESTC catalogue, where we have manually cleaned up the publisher information, combining synonymous variants of the publisher names.


<img src="/figs/20160423-Shakespeare/shakespeare-publisher-1.png" title="center" alt="center" width="700px" />



**NB! Notes on methodology**

The trick to get this approach working is to harmonize the catalogued
fields so we may trust the statistics that library catalogue data can
provide us. For example, for this analysis most of our time was spent
matching different entries of works in the ESTC and the HPB and
removing hundreds of duplicate entries in the HPB data. We also took
full advantage of our custom algorithms, implemented in the
[bibliographica R
package](https://github.com/rOpenGov/bibliographica/), to automatize
this cleaning process for any library catalogue as far as
possible. The idea is not that this “big data approach” relying on
library catalogue data would be perfect in terms of including every
single translation of Shakespeare and Don Quixote on the continent or
early modern Britain. But when the harmonizing of the catalogued
fields is done properly, the approach gives us trustworthy results
about the publishing trends that we are interested in. Whereas the raw
data is not (yet) openly available, the full preprocessing workflows
for [ESTC](https://github.com/rOpenGov/estc/) and
[CERL](https://github.com/rOpenGov/estc/) are available via Github, as
well as the full source code of [this blog
post](https://github.com/rOpenGov/ropengov.github.io/tree/site-development/_Rmdposts).

