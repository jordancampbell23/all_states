library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/OpenClosedSchools_AaronSmith_20241001.xlsx", sheet = "Closures")


school_closures <- data |>
  filter(CharterStatus == "Not Charter") |>
  filter(`SchoolType` == "Traditional/General Education") |>
  mutate(fy = as.numeric(`FallOfYear`) + 1) |>
  select(fy, everything())


school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/ct_closure_summary.xlsx")
