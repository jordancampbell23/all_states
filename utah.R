library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


# Notes: 
#   - Does not seem to include FY18 closures
#   - Innovations K-8 looked like an alternative school to me

data <- read_excel("data/School_data.xlsx") |>
  mutate(fy = year(date_closed) + ifelse(month(date_closed) >= 7, 1, 0)) |>
  filter(school_type == "Regular Education") |>
  filter(charter_flag == 0) |>
  filter(!str_detect(school_name, "Online")) |>
  select(fy, everything())

closures_by_year <- data %>%
  group_by(fy) %>%
  summarize(
    count = n(),
    .groups = "drop"
  )

# Write the data to an Excel file
write_xlsx(data, "output/ut_closure_summary.xlsx")
