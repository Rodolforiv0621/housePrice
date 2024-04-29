
data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/ProjectCrawler/LACountyHomesDB.csv")
data <- cleanedData
# Setting seed for reproducibility
set.seed(111)

# Generating random numbers 1-size of Data
randomIndices <- sample(1:nrow(data), size = .8 * nrow(data))

# Splitting randomized data into train and test sets
train_data <- data[randomIndices, ]
test_data <- data[-randomIndices, ]

# Creating linear regression model with multiple parameters
model <- lm(price ~ zip_code + home_area + num_bed + num_bath, data = train_data)

summary(model)

#par(mfrow=c(2,2))
#plot(model)

predictions <- predict(model, newdata = test_data)

# Assuming 'predictions' already contains the predicted prices
# and 'test_data' is your dataframe with actual prices

# Create a new dataframe to compare actual and predicted prices
results <- data.frame(Actual = test_data$price, Predicted = predictions)

#Calculate the average price difference between actual and predicted prices
results$PercDiff <- ((results$Actual - results$Predicted) / results$Actual) * 100
average_perc_diff <- mean(results$PercDiff)
print(average_perc_diff)

# Optionally, you can add additional relevant columns from the test data for context
#results$ZipCode = test_data$zip_code  # assuming 'zip_code' is a column in your dataset
#results$NumBed = test_data$num_bed
#results$NumBath = test_data$num_bath
#results$HomeArea = test_data$home_area


diff <- mean((predictions - test_data$price)^2)
print(diff)
plot(test_data$price, predictions, xlab = "Actual Prices", ylab = "Predicted Prices")
abline(0, 1)  # Adds a 45-degree line for reference

# Plotting predicted prices vs actual to see outliers
plot(test_data$price, predictions, main = "Predicted vs Actual Prices",
     xlab = "Actual Prices", ylab = "Predicted Prices")
text(test_data$price, predictions, labels = test_data$address, cex = 0.6, pos = 4)

