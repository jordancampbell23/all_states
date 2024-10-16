library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/ASmith School and Enrollment Info.xlsx", sheet = "Closed Schools")


school_closures <- data |>
  filter(`School Type` == "Public") |>
  rename(fy = `Last School Year`)


school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/me_closure_summary.xlsx")