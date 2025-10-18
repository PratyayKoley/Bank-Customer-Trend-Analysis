library(data.table)
# If using local CSV:
raw <- fread("data/bank-additional-full.csv")

# If reading from HDFS (development: skip unless rhdfs configured)
# library(rhdfs); hdfs.init(); txt <- hdfs.read.text("/data/processed/bank_data.csv")

# Quick inspect
str(raw)
summary(raw)

# Save a cleaned copy to project folder to keep reproducible
fwrite(raw, "data/raw_bank_data_saved.csv")