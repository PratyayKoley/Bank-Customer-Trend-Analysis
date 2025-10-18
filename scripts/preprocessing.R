library(data.table)
library(dplyr)

# Load raw data
raw <- fread("data/raw_bank_data_saved.csv")

# Preprocess / feature engineering
df <- raw %>%
  mutate(
    campaign = as.numeric(campaign),
    pdays = as.numeric(pdays),
    previous = as.numeric(previous),
    duration_min = duration / 60,       # example derived feature
    emp_rate_scaled = emp.var.rate / 10,
    cons_price_scaled = cons.price.idx / 100,
    cons_conf_scaled = cons.conf.idx / 100,
    euribor_scaled = euribor3m / 10,
    nr_employed_scaled = nr.employed / 10000,
    y_flag = ifelse(y == "yes", 1, 0)  # target variable as numeric
  ) %>%
  filter(!is.na(y_flag)) %>%
  distinct()

# Save processed data
fwrite(df, "data/processed_bank_data.csv")
