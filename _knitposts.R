#!/usr/bin/Rscript --vanilla

# compiles all .Rmd files in _R directory into .md files in Pages directory,
# if the input file is older than the output file.

# run ./knitpages.R to update all knitr files that need to be updated.

KnitPost <- function(input, outfile, base.url="/") {
    # this function is a modified version of an example here:
    # http://jfisher-usgs.github.com/r/2012/07/03/knitr-jekyll/
    require(knitr);
    opts_knit$set(base.url = base.url)
    fig.path <- paste0("figs/", sub(".Rmd$", "", basename(input)), "/")
    opts_chunk$set(fig.path = fig.path)
    opts_chunk$set(fig.cap = "center")
    render_jekyll()
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

for (infile in list.files("_Rmdposts", pattern="*.Rmd", full.names=TRUE)) {
    outfile = paste0("_posts/", sub(".Rmd$", ".md", basename(infile)))

    # knit only if the input file is the last one modified or if forced
    if ((!file.exists(outfile) |
        file.info(infile)$mtime > file.info(outfile)$mtime) | force) {
        KnitPost(infile, outfile)
    } else {
        message("Source file ", infile, " has not changed since ", outfile, " was created.")
        message("To force update, use '-f/--force'")
    }
}
