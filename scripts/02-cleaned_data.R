#### Preamble ####
# Purpose: Cleans and filters the prime ministers of 
# Australia data 
# Author: Sinan Ma
# Email: sinan.ma@utoronto.ca
# Date: 23 January 2024
# Pre-requisites: None

#### Workspace setup ####
install.packages("janitor")
install.packages("rvest")
install.packages("knitr")
install.packages("dplyr")
library(tidyverse)
library(rvest)
library(janitor)
library(knitr)
library(dplyr)
library(tidyr)

raw_data <- read_html("inputs/data/pms.html")

parse_data_selector_gadget <-
  raw_data |>
  html_element(".wikitable") |>
  html_table()

head(parse_data_selector_gadget)

parsed_data <-
  parse_data_selector_gadget |> 
  clean_names() |> 
  rename(raw_text = 3) |>
  select(raw_text) |>
  filter(raw_text != "Name(Birth–Death)Constituency") |> 
  distinct() 

head(parsed_data)


initial_clean <- 
  parsed_data |>
  separate(
    raw_text, into = c("name", "not_name"), 
           sep = "\\(", extra = "merge") |>
  mutate(date = str_extract(not_name, "[[:digit:]]{4}–[[:digit:]]{4}"),
         born = str_extract(not_name, "b.[[:space:]][[:digit:]]{4}")
  ) |>
  select(name, date, born)

head(initial_clean)


cleaned_data <-
  initial_clean |>
  separate(date, into = c("birth", "died"), 
           sep = "–") |>
  mutate(
    born = str_remove_all(born, "b.[[:space:]]"),
    birth = if_else(!is.na(born), born, birth)
  ) |> # Alive PMs have slightly different format
  select(-born) |>
  rename(born = birth) |> 
  mutate(across(c(born, died), as.integer)) |> 
  mutate(Age_at_Death = died - born) |> 
  distinct() # Some of the PMs had two goes at it.

head(cleaned_data)

write_csv(cleaned_data,
          "outputs/data/cleaned_data.csv")

