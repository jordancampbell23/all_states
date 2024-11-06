library(tidyverse)
library(readxl)
library(writexl)
library(stringr)

data <- read_excel("data/SchoolList_Enrollment.xlsx", sheet = "MasterList")

closed_schools_filter <- data |>
  filter(CLOSED == "x")

# Using "DISTRICTID", "SCHOOLID", and "SCHOOL" to filter the data,
# so that we get all instances of a school that has been closed
closed_schools_filter <- closed_schools_filter |>
  select(DISTRICTID, SCHOOLID, SCHOOL) |>
  distinct()

# Use that to filter the original data
closed_schools <- data |>
  filter((DISTRICTID %in% closed_schools_filter$DISTRICTID & SCHOOLID %in% closed_schools_filter$SCHOOLID))

# enrollment <- enrollment |>
#   mutate(fy = as.numeric(fy))

# Summerland previously three districts, now just Summerland - Built a new facility
# CEDAR BLUFFS MIDDLE SCHOOL, claims they've always been one building
# Lincon Public Schools callled back, no PACT... https://home.lps.org/federal/family-literacy/
# Oakland Craig Public Schools say they didn't close the Jr High
# St Paul has always been within one building, 
# Weping Water Middle School, says they didn't close



closed_schools <- closed_schools |>
  mutate(
    # extract last 4 digits
    fy = str_extract(DATAYEARS, "\\d{4}$")
  ) |>
  mutate(fy = as.numeric(fy)) |>
  filter(!str_detect(SCHOOL, "PRESCHOOL|INFANT|ED CENTER|PRE-SCHOOL|HEAD START|EARLY EDUCATION CENTER|CENTRAL VALLEY PK - WOLBACH|PACT|ST PAUL")) |>
  filter(DISTRICT != "SOUTH CENTRAL NEBRASKA UNIFIED 5") |>
  filter(DISTRICT != "SUMMERLAND PUBLIC SCHOOLS") |>
  # left_join(enrollment, by = c("SCHOOLID" = "CO_DIST_SCH", "fy" = "fy")) |>
  filter(CLOSED == "x") # |>
  # filter(!is.na(total))

closed_schools_by_year <- closed_schools |>
  group_by(fy) |>
  summarize(
    count = n(),
    # enrollment = sum(total, na.rm = TRUE),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(closed_schools, "output/ne_closure_summary.xlsx")



