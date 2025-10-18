library(data.table)
library(dplyr)

raw <- fread("data/raw_bank_data_saved.csv")

# Example preprocessing
df <- raw %>%
  mutate(
    tenure = as.numeric(tenure),
    avg_balance = as.numeric(avg_balance),
    credit_utilization = ifelse(credit_limit>0, credit_used/credit_limit, NA)
  ) %>%
  filter(!is.na(churn_flag)) %>%
  distinct() # dedupe

# Save
fwrite(df, "data/processed_bank_data.csv")