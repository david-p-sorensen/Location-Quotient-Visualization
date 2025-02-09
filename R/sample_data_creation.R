# Install required packages if needed
install.packages(c("dplyr", "writexl"))

# Load libraries
library(dplyr)
library(writexl)

# Create sample data frame matching your planned Excel structure
location_data <- expand.grid(
  State = state.abb,
  Industry = c("All Industries", "Goods-Producing", "Natural Resources and Mining", 
               "Construction", "Manufacturing", "Service-Providing", 
               "Trade, Transportation, and Utilities", "Information", 
               "Financial Activities", "Professional and Business Services", 
               "Education and Health Services", "Leisure and Hospitality", 
               "Other Services", "Unclassified"),
  Ownership = c("All Ownerships", "Private", "Federal Gov't", "State Gov't", 
                "Local Gov't", "Total Gov't")
) %>%
  as.data.frame()

# Add sample data columns
set.seed(123) # For reproducible random data
location_data <- location_data %>%
  mutate(
    State_Name = state.name[match(State, state.abb)],
    LQ = runif(n(), 0.5, 3),
    BLS_LQ = runif(n(), 0.5, 3),
    State_Jobs = sample(1000:100000, n(), replace = TRUE),
    State_Total_Jobs = sample(100000:1000000, n(), replace = TRUE),
    US_Jobs = sample(10000:1000000, n(), replace = TRUE),
    US_Remote_Jobs = sample(1000:10000, n(), replace = TRUE)
  )

# Remove invalid industry-ownership combinations
location_data <- location_data %>%
  filter(
    !(Industry == "Natural Resources and Mining" & Ownership != "Private"),
    !(Industry == "Unclassified" & Ownership != "Private"),
    !(Industry == "Construction" & !Ownership %in% c("Private", "Local Gov't"))
  )

# Write to Excel file
write_xlsx(location_data, "data/sample_Job_map.xlsx")

print("Sample data has been created and saved to sample_Job_map.xlsx")