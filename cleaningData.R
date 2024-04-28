library(dplyr)
library(readr)
library(stringr)
install.packages("isotree")
library(ggplot2)
library(isotree)
options(scipen = 999)
set.seed(111)
# Read the data
data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/ProjectCrawler/LACountyHomesDB.csv")

data2$address <- gsub(",","",data2$address)
#merged_data <- rbind(data2, data)



# Remove "(lot)" from 'lot_size' and 'home_area'
#data$lot_size <- gsub("\\s*\\(lot\\)\\s*", "", data$lot_size, ignore.case = TRUE)
data$home_area <- gsub("\\s*\\(lot\\)\\s*", "", data$home_area, ignore.case = TRUE)

#Removing beds and baths from csv
data$num_bed <- gsub(" beds", "", data$num_bed)
data$num_bed <- gsub(" bed", "", data$num_bed)
data$num_bath <- gsub(" baths", "", data$num_bath)
data$num_bath <- gsub(" bath", "", data$num_bath)

# Function to convert acres to square feet
convert_acres_to_sqft <- function(lot_size) {
  # Check if 'acre' or 'acres' is in the string
  if (grepl("acre", lot_size)) {
    # Extract the numeric part and convert it to numeric
    numeric_part <- as.numeric(gsub("[^0-9.]", "", lot_size))
    # Convert acres to square feet
    converted_size <- numeric_part * 43560
    return(converted_size)
  } else {
    # If 'sq ft' is in the string, just remove non-numeric characters and return the number
    return(as.numeric(gsub("[^0-9]", "", lot_size)))
  }
}

# Apply the conversion function to the 'lot_size' column
data$home_area <- sapply(data$home_area, convert_acres_to_sqft)

# Convert bed, bath and price columns to numbers
data$num_bed <- as.numeric(data$num_bed) # Assuming fractional beds are not a concern
data$num_bath <- as.numeric(data$num_bath) # Assuming fractional baths can exist
data$price <- as.integer(gsub("[^0-9.]", "", gsub("\\$", "", data$price)))

# Remove zip and state from address
data$address <- sub(", CA [0-9]{5}$", "", data$address)

#Fill in missing bed and bath with median
data$num_bed[is.na(data$num_bed)] <- median(data$num_bed, na.rm = TRUE)
data$num_bath[is.na(data$num_bath)] <- median(data$num_bath, na.rm = TRUE)

# Use Linear regression to fill in missing home_area values

#seperate the missing value rows
train_data <- filter(data, !is.na(home_area))
predict_data <- filter(data, is.na(home_area))

model <- lm(home_area ~ num_bed + num_bath + zip_code + price, data = train_data)

predicted_home_area <- predict(model, newdata = predict_data)

data$home_area[is.na(data$home_area)] <- predicted_home_area


n_missing <- sum(is.na(data$price))
data <- data %>% filter(!is.na(price))
n_predictions <- length(predicted_home_area)

# Drop the 'lot_size' column
#data <- select(data, -lot_size)

data_unique <- distinct(merged_data)


badEntries <- sum(rowSums(is.na(data)) > 2)
goodEntries <- !(rowSums(is.na(data)) > 2)
cleanedData <- data[goodEntries, ]
data$
data <- data %>% mutate(num_bath = replace(num_bath, num_bath == "-", NA))
View(data)

removed <- data[data$price < 80000000, ]
View(removed)


model <- isolation.forest(data[, c("zip_code", "num_bed", "num_bath", "home_area")], ntree=500, sample_size=256)


scores <-predict(model, data[, c("zip_code", "num_bed", "num_bath", "home_area")], type="score")
data$anomaly_score <- scores

threshold <- quantile(data$anomaly_score, 0.9988)
data$outlier <- data$anomaly_score > threshold

outliers_data <- data[data$outlier, ]

ggplot(data, aes(x=home_area, y = price, color=outlier)) + geom_point() + theme_minimal() + labs(title = "Isolation Forest Outliers: Home area vs Price")

#Saving modified file
write.csv(removed, "C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/ProjectCrawler/LACountyHomesDB.csv", row.names = FALSE)

