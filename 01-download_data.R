#### Preamble ####
# Purpose: Downloads and saves the data of prime ministers
# of Canada
# Author: Sinan Ma
# Email: sinan.ma@utoronto.ca
# Date: 6 February 2024
# Pre-requisites: None

#### Workspace setup ####
install.packages("rvest")
install.packages("xml2")
library(rvest)
library(xml2)

raw_data <-
  read_html(
    "https://en.wikipedia.org/wiki/List_of_prime_ministers_of_Canada"
  )
write_html(raw_data, "inputs/data/pms.html")
