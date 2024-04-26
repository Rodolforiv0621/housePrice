data <- read.csv("/Users/rodolforivera/Documents/housePrice/LACountyHomesDB.csv")

# Setting seed for reproducibility
set.seed(111)

# Generating random numbers 1-size of Data
randomIndices <- sample(1:nrow(data), size = .7 * nrow(data))

# Splitting randomized data into train and test sets
train_data <- data[randomIndices, ]
test_data <- data[-randomIndices, ]

# Creating linear regression model with multiple parameters
model <- lm(price ~ address + zip_code + num_bed + num_bath + home_area, data = train_data)

summary(model)