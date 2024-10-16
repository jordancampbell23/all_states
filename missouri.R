library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/DR 6065 Reason Foundation.xlsx", sheet = "2017-2023 School Closures")

school_closures <- data |>
  filter(charter_school == "N") |>
  filter(!str_detect(SCHLNAME, "ALTERNATIVE|CHARTER|JAIL|VIRTUAL|ACADEMY|HOMEBOUND|PK|TREATMENT|EARLY CHILD")) |>
  mutate(fy = Year) |>
  select(fy, everything())


school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )

# Write the data to an Excel file
write_xlsx(school_closures, "output/mo_closure_summary.xlsx")