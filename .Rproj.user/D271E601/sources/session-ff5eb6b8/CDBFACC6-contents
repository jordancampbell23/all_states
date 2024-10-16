library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


# School Closures
school_closures <- read_excel("data/20066_ASmith.xlsx", sheet = "School Closings")

school_closures <- school_closures |>
  filter(`School Type` == "Public") |>
  rename(fy = `School Year`) # |>
  # mutate(fy_less1 = fy - 1) |>
  # left_join(
  #   enrollment, by = c("School ID" = "SchoolIdentifier", "fy_less1" = "fy")
  # ) |>
  # filter(
  #   !is.na(total)
  # )

school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    # enrollment = sum(total),
    .groups = "drop"
  ) 


# Write the data to an Excel file
write_xlsx(school_closures, "output/vt_closure_summary.xlsx")
