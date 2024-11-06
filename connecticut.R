library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/OpenClosedSchools_AaronSmith_20241001.xlsx", sheet = "Closures")


school_closures <- data |>
  filter(CharterStatus == "Not Charter") |>
  filter(`SchoolType` == "Traditional/General Education") |>
  filter(
    !str_detect(`SchoolName`, regex("Cortland|HPHS|Journalism|Academy|Magnet|Early Education|Consolidated|Early Learning|High School, Inc", ignore_case = TRUE))
  ) |>
  mutate(fy = as.numeric(`FallOfYear`) + 1) |>
  select(fy, everything())

d
school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/ct_closure_summary.xlsx")
