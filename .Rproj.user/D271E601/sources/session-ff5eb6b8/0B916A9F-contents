library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


# Closed Schools

closed_schools <- read_excel("data/Closed schools since SY 18-19.xlsx")

# convert School Year from this type of format 	"SY 18-19" to 2019
closed_schools <- closed_schools |>
  mutate(
    `School Year` = str_remove(`School Year`, "SY ")
  ) |>
  mutate(
    `School Year` = str_replace(`School Year`, "-", "")
  ) |>
  # remove first two characters
  mutate(
    `School Year` = str_sub(`School Year`, 3, 4)
  ) |>
  mutate(
    `School Year` = as.numeric(`School Year`) + 2000
  ) |>
  rename(fy = `School Year`) |>
  mutate(fy_pull = fy - 1) |>
  filter(
    `Charter School (Y/N)` == "N",
    `School Type` == "Regular"
  )


closed_schools_by_year <- closed_schools |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )



# Write the data to an Excel file
write_xlsx(closed_schools, "output/nv_closure_summary")



