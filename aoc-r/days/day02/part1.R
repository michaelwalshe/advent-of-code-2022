here::i_am("days/day02/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)

compute <- function(s = "") {
  scores <- c("R" = 1, "P" = 2, "S" = 3)  # Base score for each choice
  rps_opponent <- c("A" = "R", "B" = "P", "C" = "S")  # Opponents choice mapped to standard RPS
  rps_me <- c("X" = "R", "Y" = "P", "Z" = "S")  # Same for my choice
  rps_beats <- c("R" = "P", "P" = "S", "S" = "R")  # Mapping of RPS to the choice that beats it

  # Split input into character matrix
  games <- str_split_1(s, "\n") |> str_split_fixed(" ", 2)
  # COnvert the two cols to valid RPS
  elf_moves <- rps_opponent[games[, 1]]
  my_moves <- rps_me[games[, 2]]

  # Get the result, base score plus draw/win/loss score
  res <- scores[my_moves] + dplyr::case_when(
    elf_moves == my_moves ~ 3,
    rps_beats[elf_moves] == my_moves ~ 6,
    .default = 0
  )

  sum(res)
}

input_small <- "A Y
B X
C Z"
expected_small <- 15

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day02"))
print(compute(input_large))
