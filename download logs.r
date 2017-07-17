
#### Advanced R Programming - Roger D. Peng, PhD
#@ download logs published by RStudio from their mirror of the Comprehensive R Archive Network (CRAN)

library(dplyr)
library(readr)

## pkgname: package name (character)
## date: YYYY-MM-DD format (character)
num_download <- function(pkgname, date) {
        ## Construct web URL
        year <- substr(date, 1, 4)
        src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                       year, date)

        ## Construct path for storing local file
        dest <- file.path("data", basename(src))

        ## Don't download if the file is already there!
        if(!file.exists(dest))
                download.file(src, dest, quiet = TRUE)

        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package == pkgname) %>% nrow
}



#@ Re-factoring code
check_for_logfile <- function(date) {
        year <- substr(date, 1, 4)
        src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                       year, date)
        dest <- file.path("data", basename(src))
        if(!file.exists(dest)) {
                val <- download.file(src, dest, quiet = TRUE)
                if(!val)
                        stop("unable to download file ", src)
        }
        dest
}

#@ Dependency Checking
check_pkg_deps <- function() {
        if(!require(readr)) {
                message("installing the 'readr' package")
                install.packages("readr")
        }
        if(!require(dplyr))
                stop("the 'dplyr' package needs to be installed first")
}

num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()
        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package == pkgname) %>% nrow
}

# > num_download("Rcpp", "2016-07-19")
# [1] 13572


#@ Vectorization
## 'pkgname' can now be a character vector of names
num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()
        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", progress = FALSE)
        cran %>% filter(package %in% pkgname) %>% 
                group_by(package) %>%
                summarize(n = n())
}    

num_download(c("filehash", "weathermetrics"))
# A tibble: 2 × 2
         package     n
           <chr> <int>
1       filehash   179
2 weathermetrics     7


#@ Argument Checking
num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()

        ## Check arguments
        if(!is.character(pkgname))
                stop("'pkgname' should be character")
        if(!is.character(date))
                stop("'date' should be character")
        if(length(date) != 1)
                stop("'date' should be length 1")

        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", 
                         progress = FALSE)
        cran %>% filter(package %in% pkgname) %>% 
                group_by(package) %>%
                summarize(n = n())
}    
num_download("filehash", c("2016-07-20", "2016-0-21"))
Error in num_download("filehash", c("2016-07-20", "2016-0-21")): 'date' should be length 1

