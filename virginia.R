library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/Virginia Data Request.xlsx", sheet = "School Closure")


school_closures <- data %>%
  mutate(fy = year(`Close Date`) + ifelse(month(`Close Date`) >= 7, 1, 0)) |>
  # filter Sch Name by strings that are not "Alternative" or "Charter"
  filter(!str_detect(`Sch Name`, "Alternative|Charter|Jail|Virtual|Academy|Homebound|PK|Family Education|Technology|Secondary Head Start Centers|Early Learning|Learning Center|Homebased|Preschool|Home Educational Services|Special Situation Schools|Annex|Voc. Center"))


closures_by_year <- data %>%
  group_by(fy) %>%
  summarize(
    count = n(),
    .groups = "drop"
  )

# Write the data to an Excel file
write_xlsx(data, "output/va_closure_summary.xlsx")
