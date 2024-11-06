library(tidyverse)
library(readxl)
library(writexl)
library(stringr)

# Read the data
data <- read_excel("data/MSID_all_schools.xlsx")

closed_schools <- data |>
  # filter(ACTIVITY_CODE == "C") |>
  mutate(ClosedYear = year(DATE_CLOSED) + ifelse(month(DATE_CLOSED) >= 7, 1, 0)) |>
  select(DATE_CLOSED, ClosedYear, everything()) |>
  filter(ClosedYear > 2017) |>
  filter(CHARTER_SCHL_STAT == "Z") |>
  filter(MAGNET_STATUS == "Z") |>
  filter(NEG_DEL_IND == "Z") |>
  filter(CS_SCHOOL_CHOICE == "N") |>
  filter(SCHL_FUNC_SETTING != "B") |>
  filter(SCHL_FUNC_SETTING != "D") |>
  filter(SCHL_FUNC_SETTING != "J") |>
  filter(SCHL_FUNC_SETTING != "L") |>
  filter(SCHL_FUNC_SETTING != "M") |>
  filter(SCHL_FUNC_SETTING != "N") |>
  filter(SCHL_FUNC_SETTING != "P") |>
  filter(SCHL_FUNC_SETTING != "T") |>
  filter(SCHL_FUNC_SETTING != "V") |>
  filter(PRIMARY_SERV_TYPE == "R") |>
  filter(GRADE_CODE != 1) |>
  filter(
    !str_detect(SCHOOL_NAME_LONG, regex("SUMMER|COLLEGE AND CAREERS", ignore_case = TRUE))
  )


# Summarize closures by fiscal year
closure_summary <- closed_schools |>
  group_by(ClosedYear) |>
  summarize(
    closure_count = n()
  ) |>
  arrange(ClosedYear)


# Write the data to an Excel file
write_xlsx(closure_summary, "output/fl_closure_summary.xlsx")
