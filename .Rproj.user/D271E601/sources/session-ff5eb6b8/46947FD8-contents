library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/2017-2024_CDE_public-non-public_school_closures_09132024.xlsx", sheet = "2017-25 closed public schools")

school_closures <- data |>
  filter(`CHARTER Y/N` == "N") |>
  filter(`SCHOOL TYPE` == "public") |>
  filter(!str_detect(`SCHOOL NAME`, "Academy|Online")) |>
  mutate(fy = str_extract(`CLOSED FOR SCHOOL YEAR`, "\\d{4}$")) |>
  select(fy, everything())


school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/co_closure_summary.xlsx")
