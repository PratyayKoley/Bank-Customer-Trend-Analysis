library(data.table)
library(caret)
library(randomForest)

# Load processed data
df <- fread("data/processed_bank_data.csv")

# Split into train/test
set.seed(42)
train_idx <- createDataPartition(df$y_flag, p = 0.7, list = FALSE)
train <- df[train_idx, ]; test <- df[-train_idx, ]

# Features to use (pick numeric ones)
features <- c("campaign", "pdays", "previous", "duration_min",
              "emp_rate_scaled", "cons_price_scaled",
              "cons_conf_scaled", "euribor_scaled", "nr_employed_scaled")

# Logistic regression
log_model <- glm(y_flag ~ ., data = train[, ..features, with=FALSE] %>% mutate(y_flag=train$y_flag),
                 family = "binomial")

# Random Forest
rf_model <- randomForest(as.factor(y_flag) ~ ., data = train[, ..features] %>% mutate(y_flag=as.factor(train$y_flag)),
                         ntree = 100)

# Save models
saveRDS(log_model, "models/churn_logreg_model.rds")
saveRDS(rf_model, "models/churn_rf_model.rds")
