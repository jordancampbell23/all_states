library(tidyverse)
library(readxl)
library(writexl)
library(stringr)
library(lubridate)
library(ggplot2)
library(openxlsx)


# Notes: 
#   - Questionable schools
#       - DR. JULIAN NAVA LEARNING ACADEMIES-SCHOOL OF ARTS AND CULTURE 
#         (The school of arts and culture combined into the larger school)
#
#       - SCHOOL OF HISTORY AND DRAMATIC ARTS AT SONIA SOTOMAYOR LEARNING ACADEMIES
#         (Seems like a traditional public school)
#
#       - DR. JULIAN NAVA LEARNING ACADEMIES-SCHOOL OF ENGINEERING
#        (Assume this one also combined into the larger school)
#
#       - STUDIO ???
#
#       - INDEPENDENT STUDY PROGRAM

#       - SCHOOL OF SOCIAL JUSTICE AT SONIA SOTOMAYOR LEARNING ACADEMIES

#       - MT. GEORGE INTERNATIONAL

#       - CAMPBELL DISTANCE LEARNING

#       - AUGUSTUS F. HAWKINS HIGH C RESPONSIBLE INDIGENOUS SOCIAL ENTREPRENEURSHIP

#       - AUGUSTUS F. HAWKINS HIGH B COMMUNITY HEALTH ADVOCATES
#       - PARKER

#       - RISE COMMUNITY ELEMENTARY
#         (Seems like a traditional public school)


# Read the data
data <- read_excel("data/pubschls-2.xlsx")
names(data) <- data[5, ]
data <- data[-1:-5, ]

# Convert ClosedDate and OpenDate to readable date format
data <- data |>
  mutate(ClosedDate = ifelse(ClosedDate == "No Data", NA, ClosedDate),
         OpenDate = ifelse(OpenDate == "No Data", NA, OpenDate)) |>
  mutate(ClosedDate = case_when(
    is.na(ClosedDate) ~ NA_Date_,
    str_detect(ClosedDate, "/") ~ mdy(ClosedDate),
    TRUE ~ as.Date(as.numeric(ClosedDate), origin = "1899-12-30")
  ),
  OpenDate = case_when(
    is.na(OpenDate) ~ NA_Date_,
    str_detect(OpenDate, "/") ~ mdy(OpenDate),
    TRUE ~ as.Date(as.numeric(OpenDate), origin = "1899-12-30")
  ))

# Filter out charters and specific terms from the school names
data <- data |>
  mutate(School = toupper(School)) |>
  filter(!str_detect(School, "CHARTER|ACADEMY|KIPP|VIRTUAL|ONLINE|EARLY CHILDHOOD DEVELOPMENT|DISTANCE")) |>
  filter(SOCType != "Preschool")


closed_schools <- data |>
  filter(StatusType == "Closed") |>
  filter(EdOpsName == "Traditional") |>
  filter(EILCode != "A") |>
  filter(Virtual != "F" | Virtual != "V")|>
  filter(Magnet != "Y") |>
  filter(Charter != "Y") |>
  mutate(ClosureYear = year(ClosedDate) + ifelse(month(ClosedDate) >= 7, 1, 0)) |>
  filter(ClosureYear >= 2018) |>
  select(ClosureYear, County, District, School, everything())


# Summarize closures by fiscal year
closure_summary <- closed_schools |>
  group_by(ClosureYear) |>
  summarize(
    closure_count = n()
  ) |>
  arrange(ClosureYear)


# Write the data to an Excel file
write_xlsx(closed_schools, "output/ca_closure_summary.xlsx")
