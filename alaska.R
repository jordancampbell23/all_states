library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/20240924 - Public School Closures + Enrollment + Districts Requests.xlsx", sheet = "School Closures")


# Getting a call/email back form Anchorage School District

school_closures <- data |>
  # convert school year from 2017-2018 to 2018
  filter(`Charter School` == F) |>
  mutate(fy = str_extract(`School Year`, "\\d{4}$")) |>
  filter(
    !str_detect(`School Name`, "Youth Facility|Distance|Correspondence|Home School")
  ) |>
  select(fy, everything())


school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )

# Write the data to an Excel file
write_xlsx(school_closures, "output/ak_closure_summary.xlsx")


