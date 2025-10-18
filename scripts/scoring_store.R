library(data.table)
library(mongolite)
library(randomForest)

# Load processed data
test <- fread("data/processed_bank_data.csv")

# Load models
rf_model <- readRDS("models/churn_rf_model.rds")

# Features
features <- c("campaign", "pdays", "previous", "duration_min",
              "emp_rate_scaled", "cons_price_scaled",
              "cons_conf_scaled", "euribor_scaled", "nr_employed_scaled")

# Scoring
test$churn_prob <- predict(rf_model, test[, ..features], type="prob")[,2]

# Optional: simple segmentation by campaign number (example)
test$segment <- cut(test$campaign, breaks=4, labels=1:4)

# Save output
fwrite(test, "output/scored_output.csv")

# Insert into MongoDB (Atlas or local)
m <- mongo(collection = "bank_insights", db = "bank_analytics",
           url = "mongodb+srv://pratyaykoley_db_user:9tlFBu9x9Ka77A1z@cluster0.gfnbg4k.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0") # change to Atlas URL if needed
m$insert(data.frame(test))
