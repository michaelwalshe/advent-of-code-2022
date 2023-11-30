here::i_am("R/utils.R")

YEAR <- 2022

create_day <- function(day, root = here::here()) {
  day_name <- paste0("day", sprintf("%02d", day))
  new_day <- file.path(root, "days", day_name)

  if (fs::dir_exists(new_day)) {
    stop(paste0("Day ", day_name, " already exists"))
  }

  fs::dir_copy(
    file.path(root, "days", "day00"),
    new_day
  )

  part1 <- readLines(file.path(new_day, "part1.R"))
  write(
    gsub("day00", day_name, part1),
    file.path(new_day, "part1.R")
  )

  brio::write_file(
    get_input(day),
    file.path(new_day, "input.txt")
  )
}

read_input <- function(fpath) {
  file.path(fpath, "input.txt") |>
    brio::read_file() |>
    trimws(which = "right")
}

get_input <- function(day) {
  glue::glue("https://adventofcode.com/{YEAR}/day/{day}/input") |>
    httr2::request() |>
    httr2::req_headers(Cookie = get_cookie_header()) |>
    httr2::req_perform() |>
    httr2::resp_body_string()
}

get_cookie_header <- function() {
  readLines(here::here(".env"))
}
