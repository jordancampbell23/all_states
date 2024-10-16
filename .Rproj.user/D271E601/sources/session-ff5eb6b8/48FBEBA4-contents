library(tidyverse)
library(readxl)
library(writexl)
library(stringr)


data21 <- read_excel("data/TNSD Closures.xlsx", sheet = "2021 Closures") |>
  mutate(fy = 2021)

data22 <- read_excel("data/TNSD Closures.xlsx", sheet = "2022 Closures") |>
  mutate(fy = 2022)

data23 <- read_excel("data/TNSD Closures.xlsx", sheet = "2023 Closures") |>
  mutate(fy = 2023)

data24 <- read_excel("data/TNSD Closures.xlsx", sheet = "2024  Closures") |>
  mutate(fy = 2024)

# merge all the data
data <- bind_rows(data21, data22, data23, data24)


school_closures <- data |>
  filter(`School Type` == "Public") |>
  select(fy, everything())


school_closures_by_year <- school_closures |>
  group_by(fy) |>
  summarize(
    count = n(),
    .groups = "drop"
  )


# Write the data to an Excel file
write_xlsx(school_closures, "output/tn_closure_summary.xlsx")

