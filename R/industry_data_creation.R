# Install if needed
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("writexl")) install.packages("writexl")

# Load packages
library(tidyverse)
library(writexl)

# Define state order (removing NA)
state_order <- c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA",
                 "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ",
                 "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT",
                 "VA", "WA", "WV", "WI", "WY", "DC")

# Create complete dataframe with all states
complete_states <- data.frame(state = state_order)

# Read and process data
data <- read_csv("data/postings_classified.csv") %>%
  filter(is.na(remote_allowed) & 
           industry != "Public administration" & 
           !is.na(state) & 
           state != "NA" &
           ownership == "Local Government" &
           industry %in% c("Trade, transportation, and utilities", "Information", "Financial activities", "Professional and business services", "Education and health services", "Leisure and hospitality", "Other services")) %>%
  group_by(state) %>%
  summarise(count = n()) %>%
  right_join(complete_states, by = "state") %>%  # Join with complete state list
  mutate(count = replace_na(count, 0)) %>%       # Replace NAs with 0
  mutate(state = factor(state, levels = state_order)) %>%
  arrange(state)

# Calculate total jobs
total_jobs <- sum(data$count)
print(paste("Total number of jobs (excluding NA):", total_jobs))

# Write to Excel
write_xlsx(data, "state_counts.xlsx")



# Read full dataset with progress bar
# data <- read_csv("data/postings_classified.csv",
#                  progress = TRUE)
# 
# # See ownership types for each industry
# ownership_by_industry <- data %>%
#   group_by(industry, ownership) %>%
#   summarise(count = n(), .groups = 'drop') %>%
#   arrange(industry, desc(count))
# 
# print("Ownership types by industry:")
# print(ownership_by_industry, n = Inf)