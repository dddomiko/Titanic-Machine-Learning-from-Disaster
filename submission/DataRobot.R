df <- read.csv(file = "2015-12-16_original-data-100.csv")

colnames(df) <- c("PassengerID","Survived")

df$PassengerID <- 892:1309
df$Survived <- as.numeric(df$Survived > 0.2826)


write.csv(df, file = "2015-12-16_original-data-100_prepared.csv", row.names = FALSE, quote = FALSE)
