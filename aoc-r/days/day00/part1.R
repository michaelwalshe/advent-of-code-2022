here::i_am("days/day00/part1.R")
library(here)

source(here("R", "utils.R"))


compute <- function(s = "") {
  ""
}


input_small <- ""
expected_small <- ""

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day00"))
print(compute(input_large))

