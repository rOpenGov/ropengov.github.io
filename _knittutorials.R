#!/usr/bin/Rscript --vanilla

# compiles all .Rmd files in _R directory into .md files in Pages directory,
# if the input file is older than the output file.

# run ./knittutorials.R to update all knitr files that need to be updated.

KnitPost <- function(input, outfile) {
    # this function is a modified version of an example here:
    # http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/
    require(knitr);
    opts_chunk$set(fig.path=fig.path <- paste0("figs/", sub(".Rmd$", "", basename(input)), "/"))
    knit_hooks$set(render_jekyll(highlight = "pygments"))
    knit(input, outfile, envir = parent.frame())
}

args <- commandArgs(trailingOnly = TRUE)

# Control variables
# Force update 
force <- FALSE

# Stupid way of dealing with command line args
if (length(args) == 1) {
    if (args[1] %in% c('-f', '--force')) {
        force <- TRUE
    } else {
        warning("Unknown argument '", args[1], "', ignoring")
    }
} else if (length(args) > 1) {
    stop("Too many command line arguments provided")
}

for (infile in list.files("tutorials", pattern="*.Rmd", full.names=TRUE)) {
    outfile = paste0("tutorials/", sub(".Rmd$", ".md", basename(infile)))

    # knit only if the input file is the last one modified or if forced
    if ((!file.exists(outfile) |
        file.info(infile)$mtime > file.info(outfile)$mtime) | force) {
        KnitPost(infile, outfile)
    }
}

