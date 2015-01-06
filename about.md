---
layout: page
---

About rOpenGov
==============

[rOpenGov](http://ropengov.github.io) is a community-driven ecosystem of [R](http://cran.r-project.org/) packages for open government data and computational social sciences.

More specifically, rOpenGov community is a group of independent package developers working with and/or interested in open goverment data analytics. rOpenGov acts as a loose umbrella for independent [projects]({{ site.url }}/projects) dedicated to open data streams relevant for computational social sciences and providing R-bases tools to access and analyze these information sources. Project was officially launched in 2013 and is maintained by a core team. Currently we are finishing up project infrastructure and actively encourage for [new contributions]({{ site.url }}/contribute).

Rapidly emerging governmental and other open data streams provide new opportunities for social sciences, data journalism, and citizen participation across the globe. So far - however - computational tools dealing with these resources have mostly been lacking. We aim at building a scalable software ecosystem which has potential to revolutionize the field. We hope to build on lessons learned from similar initiatives in other fields such as [Bioconductor](http://www.bioconductor.org) and [rOpenSci](http://ropensci.org).

Why become a part of rOpenGov? Simply put, a project participating in rOpenGov will:
- Get additional visibility through this website 
- Benefit from automated development tools and guidelines
- Get an opportunity to attract contributors
- Gain a forum for the developer community

### Community

As for any open source project, the whole community is in key role in rOpenGov as well. The way we see it, rOpenGov community can have - and already has! - several different roles.

A number of independent **package authors** have [contributed projects]({{ site.url }}/projects) that ease programmatic access to data sources relevant to computational social sciences. These packages are actively maintained by their developers. If you are working on related projects, don't hesitate to [get in touch!]({{ site.url }}/contribute)

The **user community** includes academic researchers, students, data journalists, citizen scientists, and other interested parties.

The **core team** provides support for package authors and the user community by maintaining the infrastructure, reviewing new packages, and proposing recommended guidelines. All members of the current core team have background in computational science: [Leo Lahti](http://www.iki.fi/Leo.Lahti) (Univ. Helsinki, Finland and Wageningen Univ., Netherlands), [Juuso Parkkinen](http://ouzor.github.io/) (Aalto Univ., Finland) and [Joona Lehtomäki](https://github.com/jlehtoma) (University of Helsinki, Finland).

For general support regarding the development, maintenance, and usage of individual packages, [get in touch with the community]({{ site.url }}/contribute).

### Objectives

rOpenGov is an open source software project that provides tools for analysis and comprehension of data sets relevant for computational social sciences. It is inspired by [Bioconductor](http://bioconductor.org/about/), a related and successful R ecosystem project for life sciences. rOpenGov core core objectives in more detail are: 

**Statistical and graphical methods** We aim at providing computational tools dedicated to the analysis of data sources relevant to social sciences and related fields complementing the R ecosystem for computational sciences.

**Documentation** We strongly feel that high-quality documentation is not only good development strategy, but also a requirement for the uptake of the provided tools. Each rOpenGov package contains at least one vignette, which provide a task-oriented, transparent and reproducible description of package's functionality and capabilities. Main vignettes are automatically converted into online tutorials published at rOpenGov website.

**Scalability** To provide a shared software platform that enables the rapid development of extensible, scalable, and interoperable software. The open development model facilitates software improvements through bug fixing and software extension, and provides a workbench of tools that allow researchers to explore and expand the methods used to analyze data related to social sciences.

**Open source** rOpenGov is and always will 100% open source project. We use git and GitHub extensively for code version control and collaboration. All contributions are released under an open source license to provide full access to algorithms and their implementation and to ensure that the international scientific community is the owner of the software tools needed to carry out research.

**Reproducible research** We hope to make research more reproducible by providing tools and workflows that can be easily adapted to different research questions in deifferent countries. For example, providing a unified interface to parliamentary data, and economical and social indicators makes analytics more straight forward and understandable since data is not collated and cleaned up _ad hoc_ every time separatelly. Automatically generated online tutorials provide transparent documentation with many algorithmic details.  This sort of approach serves as an template for good scientific computing, and introduces advanced scientific methodology, practice and understanding to a wider audience.

**Open development** We encourage users to become developers, either by contributing rOpenGov compliant packages or documentation. Additionally, rOpenGov provides a forum for linking together different groups with common goals to foster collaboration on software, often through collaborative development. This can also help to train researchers on computational and statistical methods for the analysis of social science data. In addition, rOpenGov project provides utilities for package developers, including TravisCI scripts for automated build reports, automatically generated online tutorials for the packages, shared distribution platform at the rOpenGov website, and added visibility and recognition for individual packages.

### Language policy

rOpenGov is based on the R statistical programming language. Most rOpenGov components are distributed as R packages to access, preprocess, analyse, and report data and scientific findings. There may also be utility and metadata packages. In general, the package release versions are distributed through CRAN, and the development versions via [rOpenGov Github organization](https://github.com/ropengov). Why go so heavy on R? Reasons include:

- An active developer community
- Extensive experiences with similar community projects in other fields
- A well established system for packaging together software with automated document generation
- Access to on-line data sources
- Support for rich statistical simulation and modeling functions
- State-of-the-art visualization capabilities
- R is a high-level interpreted language in which it is easy to prototype new computational methods
- An object-oriented framework for addressing the diversity and complexity of problems in social sciences

We are crrently focused on R due to its strong ecosystem and user community, and due to the fact that it's the most familiar language to us. We are actively monitoring developments in other programming languages and their respective ecosystems, such as [Python](http://www.python.org/) and [Julia](http://julialang.org/). The language policy may be expanded in the future.
