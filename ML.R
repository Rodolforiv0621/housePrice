
data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/ProjectCrawler/LACountyHomesDB.csv")

# Setting seed for reproducibility
set.seed(111)

# Generating random numbers 1-size of Data
randomIndices <- sample(1:nrow(data), size = .7 * nrow(data))

# Splitting randomized data into train and test sets
train_data <- data[randomIndices, ]
test_data <- data[-randomIndices, ]

# Creating linear regression model with multiple parameters
model <- lm(price ~ zip_code + num_bed + num_bath + home_area, data = train_data)

summary(model)

par(mfrow=c(2,2))
plot(model)

predictions <- predict(model, newdata = test_data)
diff <- mean((predictions - test_data$price)^2)
print(diff)
plot(test_data$price, predictions, xlab = "Actual Prices", ylab = "Predicted Prices")
abline(0, 1)  # Adds a 45-degree line for reference

# Plotting predicted prices vs actual to see outliers
plot(test_data$price, predictions, main = "Predicted vs Actual Prices",
     xlab = "Actual Prices", ylab = "Predicted Prices")
text(test_data$price, predictions, labels = test_data$address, cex = 0.6, pos = 4)

