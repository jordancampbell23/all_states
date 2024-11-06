library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/Reason Foundation Data Request 10 09 24.xlsx")

school_closures <- data |>
  filter(`Charter Status` == "N") |>
  filter(`School Type` == "Regular School") |>
  filter(!str_detect(`School Name`, "Virtual|Online|Technology|Distance Learning|Academy|Middle School Immersion Center - 53|Lakota Language Immersion - 23|Cyber|Preschool|Garfield Education Center - 14")) |>
  mutate(fy = str_extract(`SCHOOL YEAR`, "\\d{4}$")) |>
  select(fy, everything())

school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
 )


# Write the data to an Excel file
write_xlsx(school_closures, "output/sd_closure_summary.xlsx")


