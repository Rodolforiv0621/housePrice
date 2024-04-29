library(caret)

train_control <-  trainControl(
  method = "cv",  # K-fold cross-validation
  number = 10     # Number of folds
)

# Define the model 
formula <- price ~ zip_code + num_bed + num_bath + home_area

# Train the model
model <- train(formula, data = data, method = "lm", trControl = train_control)

print(model)

summary(model)

