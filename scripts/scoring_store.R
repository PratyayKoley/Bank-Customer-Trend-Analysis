library(data.table); library(mongolite)

# load test/new data
test <- fread("data/processed_bank_data.csv") # or new dataset

# load models
rf_model <- readRDS("models/churn_rf_model.rds")
kmeans_model <- readRDS("models/customer_kmeans.rds")

# scoring
test$churn_prob <- predict(rf_model, test, type = "prob")[,2]  # randomForest needs probability type
# If your randomForest version doesn't support type="prob" on direct predict for factor, use predict(rf_model, test, type="prob")
test$segment <- predict_kmeans <- function(newdata, km){
  # naive assignment to closest center
  centers <- km$centers
  sapply(1:nrow(newdata), function(i) which.min(colSums((t(centers) - as.numeric(newdata[i,]))^2)))
}
test$segment <- predict_kmeans(as.matrix(test[, .(avg_balance, credit_utilization)]), kmeans_model)

# Save output CSV
fwrite(test, "output/scored_output.csv")

# Store to MongoDB
m <- mongo(collection = "bank_insights", db = "bank_analytics", url = "mongodb://localhost:27017")
# Optionally remove previous
# m$drop()
m$insert(data.frame(test))