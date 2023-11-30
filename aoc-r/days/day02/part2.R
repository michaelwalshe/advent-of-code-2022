here::i_am("days/day02/part1.R")
library(here)

source(here("R", "utils.R"))

library(stringr)

compute <- function(s = "") {
  scores <- c("R" = 1, "P" = 2, "S" = 3)  # Base score for each choice
  rps_opponent <- c("A" = "R", "B" = "P", "C" = "S")  # Opponents choice mapped to standard RPS
  rps_beats <- c("R" = "P", "P" = "S", "S" = "R")  # Mapping of RPS to the choice that beats it
  rps_loses <- names(rps_beats)
  names(rps_loses) <- rps_beats

  # Split input into character matrix
  games <- str_split_1(s, "\n") |> str_split_fixed(" ", 2)
  # Convert the two cols to valid RPS
  elf_moves <- rps_opponent[games[, 1]]
  my_moves <- dplyr::case_match(
    games[, 2],
    "X" ~ rps_loses[elf_moves],
    "Y" ~ elf_moves,
    "Z" ~ rps_beats[elf_moves]
  )

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
expected_small <- 12

testthat::expect_equal(compute(input_small), expected_small)

input_large <- read_input(here("days/day02"))
print(compute(input_large))
