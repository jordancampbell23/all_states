library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/Closed School Buildings (2018-2025).xlsx")

school_closures <- data |>
  filter(!str_detect(`SchoolName`, "Academy|Online|Alternative|Futures|Education Options|Preschool|Orchard")) |>
  filter(is.na(Notes) | !str_detect(Notes, "Re-org|Alt|Reorganizing|Incorporated|Not closed")) |>
  mutate(fy = str_extract(`School Year (Building Closed Prior to this School Year)`, "\\d{4}$")) |>
  mutate(fy = as.numeric(fy) + 1) |>
  select(fy, everything())
  

# Education Options was a program
# Orchard Place appears to be a treatment center/program

  
school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/ia_closure_summary.xlsx")