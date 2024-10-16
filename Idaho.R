library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


reported_closures <- read_excel("data/PRR62824ClosedSchools.xlsx", sheet = 1)
colnames(reported_closures) <- reported_closures[1, ]
reported_closures <- reported_closures[-1, ]

reported_closures <- reported_closures |>
  mutate(
    fiscal_year = as.numeric(str_extract(`School Year`, "\\d{2}$")) + 2000
  )  |>
  filter(`Charter Status Y/N` != "Y") |>
  filter(is.na(`School Type`)) |>
  filter(!str_detect(`School Name`, "EARLY|ADULT|ALTERNATIVE|HOME|PRESCHOOL|TREATMENT|DEVELOPMENT|TECHNICAL"))

# Aggregate by year to count closures
reported_closures_count <- reported_closures |>
  group_by(fiscal_year) |>
  summarise(
    closures = n()
  )

# Write the data to an Excel file
write_xlsx(reported_closures_count, "output/id_closure_summary.xlsx")
