library(data.table); library(caret); library(randomForest)

df <- fread("data/processed_bank_data.csv")

set.seed(42)
train_idx <- createDataPartition(df$churn_flag, p = 0.7, list = FALSE)
train <- df[train_idx, ]; test <- df[-train_idx, ]

# Logistic regression
log_model <- glm(churn_flag ~ tenure + avg_balance + credit_utilization, data = train, family = "binomial")

# Random Forest
rf_model <- randomForest(as.factor(churn_flag) ~ tenure + avg_balance + credit_utilization, data = train, ntree = 100)

# Segmentation (K-means)
set.seed(42)
k_features <- train[, .(avg_balance, credit_utilization)]
kmeans_model <- kmeans(scale(k_features), centers = 4)

# Save models
saveRDS(log_model, "models/churn_logreg_model.rds")
saveRDS(rf_model, "models/churn_rf_model.rds")
saveRDS(kmeans_model, "models/customer_kmeans.rds")