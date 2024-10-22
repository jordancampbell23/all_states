library(tidyverse)
library(readxl)
library(writexl)
library(stringr)

# Read reported closed schools
closed_schools <- read_excel("data/PIR-69880-SchoolandDistrictData.xlsx", sheet = "Closed Schools")

# Ensure NCES numbers are characters and clean up any potential issues
reported <- closed_schools |>
  rename(
    School_NCES = `School NCES`,
    District_NCES = `District NCES`
  ) |>
  mutate(
    Charter = ifelse(is.na(`Charter Status`), "Not a charter", "Charter"),
    School_NCES = as.character(str_trim(School_NCES)),
    District_NCES = as.character(str_trim(District_NCES))
  ) |>
  filter(
    `School Type` == "REGULAR INSTRUCTIONAL",
    Charter == "Not a charter"
  ) |>
  filter(!str_detect(`School Name`, regex("Academy|Shelter", ignore_case = TRUE))) |>
  mutate(YEAR = as.numeric(str_extract(`Removal Date`, "\\d{4}")))


reported_closure_summary <- reported |>
  group_by(YEAR) |>
  summarize(
    closures = n(),
  )


# Write the data to an Excel file
write_xlsx(reported, "output/tx_closure_summary.xlsx")
