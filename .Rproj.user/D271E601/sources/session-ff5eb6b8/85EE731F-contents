library(tidyverse)
library(readxl)
library(writexl)
library(stringr)

# Read the data
reported_closures <- read_excel("data/DS#128793_NYState_Public_Schools_Districts_Enrollment_7Years.xlsx", sheet = "School_Closures")


# Calculate closures per year with enrollment based on reported closures
closures_per_year_reported <- reported_closures %>%
  mutate(
    LAST_SCHOOL_YEAR = as.numeric(str_extract(LAST_SCHOOL_YEAR, "(?<=-)\\d{2}$")) + 2000
  ) %>%
  filter(
    INST_SUB_TYPE %in% c("PUBLIC SCHOOL CENTRAL", "PUBLIC SCHOOL CITY",
                         "PUBLIC SCHOOL INDEPENDENT CENTRAL", 
                         "PUBLIC SCHOOL SPECIAL ACT", "PUBLIC SCHOOL 100% CONTRACT",
                         "PUBLIC SCHOOL INDEPENDENT UNION FREE", "PUBLIC SCHOOL UNION FREE", 
                         "PUBLIC SCHOOL COMMON",  "PUBLIC SCHOOL CENTRAL HIGH SCHOOL") &
      !str_detect(POPULAR_NAME, regex("ACADEMY|CHARTER|GED|ALTERNATIVE", ignore_case = TRUE))
  ) %>%
  group_by(LAST_SCHOOL_YEAR) %>%
  summarize(
    closures = n(),
    total_enrollment = sum(PK12_ENR, na.rm = TRUE)
  )

# Ensure NCES numbers are characters and clean up any potential issues
reported <- reported_closures %>%
  rename(
    School_NCES = NCES_SCHOOL_ID,
    District_NCES = DIST_NCES_ID
  ) %>%
  mutate(
    School_NCES = as.character(str_trim(School_NCES)),
    District_NCES = as.character(str_trim(District_NCES))
  ) %>%
  filter(
    INST_SUB_TYPE %in% c("PUBLIC SCHOOL CENTRAL", "PUBLIC SCHOOL CITY", "PUBLIC SCHOOL INDEPENDENT CENTRAL", "PUBLIC SCHOOL SPECIAL ACT", "PUBLIC SCHOOL 100% CONTRACT", "PUBLIC SCHOOL INDEPENDENT UNION FREE", "PUBLIC SCHOOL UNION FREE", "PUBLIC SCHOOL COMMON",  "PUBLIC SCHOOL CENTRAL HIGH SCHOOL") &
      !str_detect(POPULAR_NAME, regex("ACADEMY|CHARTER|GED|ALTERNATIVE", ignore_case = TRUE))
  )


# Write the data to an Excel file
write_xlsx(reported, "output/ny_closure_summary.xlsx")


