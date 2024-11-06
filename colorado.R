library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data <- read_excel("data/2017-2024_CDE_public-non-public_school_closures_09132024.xlsx", sheet = "2017-25 closed public schools")

school_closures <- data |>
  filter(`CHARTER Y/N` == "N") |>
  filter(`SCHOOL TYPE` == "public") |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "Academy|Online|Bright Horizons Pre-Kindergarten School|ONLINE"
                )
    ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "Steamboat Springs Early Childhood Center|PSAS Homeschool Program"
    )
  ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "Preschool|Virtual|Early Learning Center|Special Education"
    )
  ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "P-Tech Early College at Northglenn High School|St. Vrain Valley P-TECH School"
    )
  ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "Boulder Explore|McLain Community High School|Rock Canyon HS Pre-K"
    )
  ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "Highlands Ranch HS Pre-K|Gilpin Montessori Public School|George Saiter School of Excellence"
    )
  ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "Noel Community Arts School|Warren Tech North|Warren Tech South"
    )
  ) |>
  filter(
    !str_detect(`SCHOOL NAME`,
                "District 6 Career and Technical Education Center|Battle Mountain Early College High School"
    )
  ) |>
  mutate(fy = str_extract(`CLOSED FOR SCHOOL YEAR`, "\\d{4}$")) |>
  select(fy, everything())


# Removed schools w/ notes
#   - Boulder Explore (Online, no campus closed)
#   - McLain Community High School (alternative, still open)
#   - Rock Canyon HS Pre-K (appears to be open)
#   - Highlands Ranch HS Pre-K (appears to be open)
#   - Gilpin Montessori Public School (Gilpin County School District RE-1, noted that this was a charter school)
#   - George Saiter School of Excellence (appears to be a school for "Troubled Youth", https://www.amazon.com/first-thirteen-Years-George-Excellence/dp/0984437762)
#   - Noel Community Arts School (arts school)
#   - Warren Tech North (open, serve 11th, 12th grades work with local community college)
#   - Warren Tech South (open, serve 11th, 12th grades work with local community college)
#   - District 6 Career and Technical Education Center
#   - Battle Mountain Early College High School


#  - Alamosa Ombudsman School of Excellence (alternative school, really closed)
#  - De Beque Elementary School (new school)



# Flagged schools
#   - LEAP School (may be homeschool enrichment progarm)
#   - Estes Park Options School (unable to reach)
#   - Crowley County Primary (name change)
#   - Calhan Middle School (only had one building to begin with, name change)



school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/co_closure_summary.xlsx")
