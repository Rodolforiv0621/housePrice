library(ggplot2)
library(dplyr)

# Read the data
data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/DB.csv")

# Histogram of Prices
ggplot(data, aes(x = price)) + geom_histogram(binwidth = 15000, fill = "blue", color = "black") +labs(title = "Distribution of Property Prices Histogram", x = "Price", y = "Count") + xlim(0,4500000)

# Scatter Plot of Home Area vs. Price
ggplot(data, aes(x = home_area, y = price)) + 
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Home Area vs. Price Scatter Plot", x = "Home Area (sq ft)", y = "Price ($)") + xlim(0,7500) + ylim(0,5000000)

# Boxplot of Prices by Number of Bedrooms
ggplot(data, aes(x = factor(num_bed), y = price)) + 
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Property Prices by Number of Bedrooms Box plot", x = "Number of Bedrooms", y = "Price ($)") + ylim(0, 10000000)
