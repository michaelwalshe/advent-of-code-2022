here::i_am("days/day01/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)
library(purrr)

compute <- function(s = "") {
  s |>
    str_split_1("\n\n") |>
    str_split("\n") |>
    map(as.numeric) |>
    map_dbl(sum) |>
    max()
}


input_small <- "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"

expected_small <- 24000

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day01"))
print(compute(input_large))
