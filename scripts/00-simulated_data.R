#### Preamble ####
# Purpose: Simulate a dataset
# Author: Sinan Ma
# Email: sinan.ma@utoronto.ca
# Date: 6 February 2024
# Prerequisites: None

#### Workspace setup ####
install.packages("tidyverse")
install.packages("babynames")

library(tidyverse)
library(babynames)

### Simulate ###
# based on the knowledge from "telling stories with data"

set.seed(2024)

simulated_dataset <-
  tibble(
    prime_minister = babynames |>
      filter(prop > 0.01) |>
      distinct(name) |>
      unlist() |>
      sample(size = 10, replace = FALSE),
    birth_year = sample(1700:1990, size = 10, replace = TRUE),
    years_lived = sample(50:100, size = 10, replace = TRUE),
    death_year = birth_year + years_lived
  ) |>
  select(prime_minister, birth_year, death_year, years_lived) |>
  arrange(birth_year)

simulated_dataset
