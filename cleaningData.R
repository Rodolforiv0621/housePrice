library(dplyr)
library(stringr)

# Read the data
data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/LACountyDBFinal.csv")

# Remove "(lot)" from 'lot_size' and 'home_area'
data$lot_size <- gsub("\\s*\\(lot\\)\\s*", "", data$lot_size, ignore.case = TRUE)
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
data$num_bed <- as.numeric(gsub("[^0-9.]", "", data$num_bed)) # Assuming fractional beds are not a concern
data$num_bath <- as.numeric(gsub("[^0-9.]", "", data$num_bath)) # Assuming fractional baths can exist
data$price <- as.numeric(gsub("[^0-9.]", "", gsub("\\$", "", data$price)))

# Remove zip and state from address
data$address <- sub(", CA [0-9]{5}$", "", data$address)

#Fill in missing bed and bath with median
data$num_bed[is.na(data$num_bed)] <- median(data$num_bed, na.rm = TRUE)
data$num_bath[is.na(data$num_bath)] <- median(data$num_bath, na.rm = TRUE)

# Use Linear regression to fill in missing price values

#seperate the missing value rows
train_data <- filter(data, !is.na(lot_size))
predict_data <- filter(data, is.na(lot_size))

model <- lm(lot_size ~ num_bed + num_bath + home_area + price, data = train_data)

predicted_lot_size <- predict(model, newdata = predict_data)

predict_data$lot_size <- predicted_lot_size

final_data <- rbind(train_data, predict_data)

# Drop the 'lot_size' column
#data <- select(data, -lot_size)

data_unique <- distinct(data)
View(data_unique)
#Saving modified file
write.csv(data_unique, "C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/noDupLACountyDB.csv", row.names = FALSE)

