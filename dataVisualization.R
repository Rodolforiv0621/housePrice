library(ggplot2)
library(dplyr)
options(scipen = 999)
# Read the data
data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/ProjectCrawler/LACountyHomesDB.csv")

# Histogram of Prices
ggplot(data, aes(x = price)) + geom_histogram(binwidth = 15000, fill = "blue", color = "black") +labs(title = "Distribution of Property Prices Histogram", x = "Price", y = "Count") + xlim(0,3500000)

# Scatter Plot of Home Area vs. Price
ggplot(data, aes(x = home_area, y = price)) + 
  geom_point(alpha = 0.2) +
  theme_minimal() +
  labs(title = "Home Area vs. Price Scatter Plot", x = "Home Area (sq ft)", y = "Price ($)") + xlim(0,8000) + ylim(0,9000000)

# Boxplot of Prices by Number of Bedrooms
ggplot(data, aes(x = factor(num_bed), y = price)) + 
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Property Prices by Number of Bedrooms Box plot", x = "Number of Bedrooms", y = "Price ($)") + ylim(0, 20000000)

#scatter.smooth(data_unique$`91506`, data_unique$`1995000`, xlab = "Zip Code", ylab = "Price", xlim = c(91300, 91610), ylim = c(500000, 4000000))
