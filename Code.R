#### Author: Veronica Munoz Mendoza


# Libraries
library(glmnet)     #  This library contains the functions for training regularised linear regression models.
library(DescTools)  #  Descriptive statistics library.

train <- read.csv("CA_train_data.csv")
test <- read.csv("CA_test_data.csv")

##### DATA UNDERSTANDING #####

# Importing libraries
library(ggplot2)    # Importing for data visualization.
library(tidyverse)  # Importing for data manipulation.

# DESCRIBING THE DATA
view(train)     # Visualizing the entire dataset.

class(train)    # Checking if the data import was successful and if the variable "train" is a data.frame.
dim(train)      # Checking the dimensions of the train dataset (537 observations, 9 variables).
str(train)      # Displaying the structure of the dataset.
names(train)    # Listing the variable names.
head(train)     # Displaying the first few rows of the training data.
tail(train)     # Displaying the last few rows of the training data.
summary(train)  # Providing summary statistics of the training data.


any(is.na(train)) # Checking for missing values. Expecting FALSE as there should be no missing values.

# Preliminary analysis conclusion:
# The data set contains 537 observations and 9 variables. All variables are numeric or integer types.There are no missing or NA values.

# FUTHER ANALYSIS AND VISUALIZATION - EDA (Exploratory Data Analysis)

# SCATTER PLOTS
# Scatter plot comparing independent variables with the dependent variable
names(train) # Listing the variable names

# Creating scatter plots for each variable against Y
independent_vars <- c("Relative_Compactness", "Surface_Area", "Wall_Area", "Roof_Area", "Overall_Height", "Orientation", "Glazing_Area", "Glazing_Area_Distribution")

# Set up the grid of plots
par(mfrow = c(2, 4)) # 2 rows and 4 columns

for(var in independent_vars) {
  plot(train[[var]], train$Y, xlab = var, ylab = "Y", main = paste("Scatter Plot:", var, "vs Y"))
}

# HISTOGRAMS
# Creating histograms to visualize the distribution and central tendency of numeric variables.
# Looping through each column and creating a histogram for numeric variables.
for(col in names(train)){
  if(is.numeric(train[[col]])){
    hist(train[[col]], col="blue", main=col, xlab="")
  }
}

# SCATTERPLOT MATRIX 
# Creating a scatterplot matrix to explore variable relationships, their patterns, and the correlation with the target variable.
library (psych)

pairs.panels(train [,c("Relative_Compactness", "Surface_Area", "Wall_Area",   
                       "Roof_Area", "Overall_Height", "Orientation",           
                       "Glazing_Area", "Glazing_Area_Distribution", "Y")],main = "Scatterplot Matrix")


# CORRELATION COEFFICIENTS - Pearson's R
# Creating a correlation matrix to examine the relationships between variables and visualizing it with a heatmap.
cor_matrix <- cor(train)
print(cor_matrix)


# Installing pheatmap as I would like to visualized the correlation matrix with a heatmap. 
library(pheatmap)

# Create the heatmap
pheatmap(cor_matrix, 
         main = "Correlation Matrix Heatmap",
         angle_col = 45) 


# CONCLUSIONS: 
# Strongest correlation with Y is Overall_Height with a correlation coefficient of 0.898. 
# As the overall height increases, the value of Y also tends to increase.

# Weakest correlation with Y: Orientation with a correlation coefficient of 0.006. 
# The correlation coefficient is close to zero, indicating that there is almost no linear relationship between these two variables.

# Based on the strength and direction of the linear relation between the variables,  
# the following correlation coefficients will be good candidates for predicting Cooling Aid (Y) variable: 
    # Relative_Compactness: correlation coefficient of 0.628 with Y, indicating a moderate positive correlation.
    # Surface_Area: This variable has a correlation coefficient of -0.668 with Y, indicating a moderate negative correlation.
    # Wall_Area: This variable has a correlation coefficient of 0.453 with Y, indicating a moderate positive correlation.
    # Roof_Area: This variable has a correlation coefficient of -0.865 with Y, indicating a strong negative correlation.
    # Overall_Height: This variable has a correlation coefficient of 0.898 with Y, indicating a strong positive correlation.

# There is a strong correlation of -0.99163908 between Relative_Compactness and Surface_Area. 
# This suggest multicolienarity between the variables which might affect the performance of our model. 
# I will implement Ridge Regression in the modelling section to deal with the multicolienarity. 

#LINEAR REGRESSION 
# creating a linear regression to check the correlation between the independent variables and our outcome variable Y.  

train_copy1_9var <- train[, c(1,2,3,4,5,6,7,8,9)] # Creating a new object with all the independent variables. 
str(train_copy1_9var)  #  Checking the structure/format of the data.

# using the lm() to train the model
linear_regression_model <- lm(Y ~ Relative_Compactness +  Surface_Area + Wall_Area + Roof_Area + Overall_Height
                                  + Orientation + Glazing_Area + Glazing_Area_Distribution, data = train_copy1_9var)

# viewing a summary of the trained model for inference purposes.
summary(linear_regression_model)


# CONCLUSIONS: 
#  The following variables might not be statistical significant to predict the response variable,
#  due to p-value being higher than 0.5 (0.973743 & 0.236224) or being NA.
#     Roof_Area                         NA         NA      NA       NA    
#     Orientation                 0.004196   0.127427   0.033 0.973743    
#     Glazing_Area_Distribution   0.112964   0.095262   1.186 0.236224 

# The residual standard error is 3.293, which measures the average deviation of the observed values from the predicted values.

# The adjusted R-squared indicates that 88.5% of the variability in the response variable can be explained by Y.
# The F-statistic is 593.4, with a p-value less than 2.2e-16, suggesting that the model's overall fit is statistically significant.
#     Residual standard error: 3.293 on 529 degrees of freedom
#     Multiple R-squared:  0.887,	Adjusted R-squared:  0.8855 
#     F-statistic: 593.4 on 7 and 529 DF,  p-value: < 2.2e-16

# Seems this model is a good fit, I will remove this 3 variables and see if the model will perform better. 

# PLOTING RESIDUALS
# Calculate the residuals
residuals <- resid(linear_regression_model)

# Plot the residuals against Y, add a fitted line, and a horizontal line at zero
plot(linear_regression_model$fitted.values, residuals,
     xlab = "Y", ylab = "Residuals", main = "Residuals vs. Y Plot")
lines(lowess(linear_regression_model$fitted.values, residuals), col = "red")
abline(h = 0, lty = 2)

# CONCLUSIONS: 
# The residuals seem to be scattered randomly around the zero line, and there doesn't appear to be any clear pattern. 
# This suggests that the assumptions of linearity and homoscedasticity (equal variance of residuals) are met.

#### DATA PREPARATION #####

# FEATURE SELECTION
# I will be removing Roof_Area, Orientation and Glazing_Area_Distribution 
# to see if the Adjusted R-squared has significant changes. 
train2 <- train[, c(1,2,3,5,7,9)]  #  Creating a new object with all the independent variables. 
str(train2)                        #  Checking the structure/format of the data.

# using a new lm() to train the model. 
linear_regression_model_2 <- lm(Y ~ Relative_Compactness +  Surface_Area + Wall_Area + Overall_Height
                               + Glazing_Area, data = train2)

summary(linear_regression_model_2) # viewing a summary of the trained model for inference purposes.

# CONCLUSIONS: 
# The adjusted R-squared of the linear_regression_model is 0.8855, whereas model2_6var achieves 0.8857. Model2_6var has a slightly higher adjusted R-squared.
# The residual standard error for the linear_regression_model is 3.291, marginally better than the previous model.
# I will use the model with 6 variables as it has a slightly better adjusted R-squared and helps avoid overfitting.. 

#### DATA MODELLING #####

# DATA PARTITION

# -- MODEL A --- 

# Set seed for reproducibility 
set.seed(2)

# Generate random training indices (70% for training, 30% for validation) without replacement. 
train_indices <- sample(1:nrow(train2), nrow(train2) * 0.7, replace = FALSE)

# Create training and validation partitions
train_partition <- train2[train_indices, ]  #  Make a new subset of the whole training data using the indices gathered.
val <- train2[-train_indices, ]  #  Make a new subset of the whole training data using the indices NOT used.

## Libraries
library(DescTools)  #  For Descriptive statistics (we can use this to calculate some prediction error metrics)
library(glmnet)     #  For Ridge regression model training and evaluation

# Convert data to matrix format
input_features <- as.matrix(train_partition[, -length(train_partition)])  #  We are not including the target value, or last column.
target <- train_partition$Y  #  The last column, called valence, is the target (or, y) value.

# Cross-validation for model performance estimation with Ridge Regression type (alpha = 0)
cv <- cv.glmnet(input_features, target, alpha = 0, nfolds = 5)

# Error estimation for lambda min and lambda 1se.
cv

# Store the validation results
cross_validation_MSE <- min(cv$cvm)  #  min() can be used to get the smallest MSE from the evaluated lambda values.
cross_validation_RMSE <- sqrt(cross_validation_MSE)  #  The square root of the MSE gives the RMSE.

# Display the cross-validation results
cross_validation_MSE  # Display the cross-validation MSE
cross_validation_RMSE  # Display the cross-validation RMSE

# -- MODEL B ---

# Set seed for reproducibility
set.seed(2)

# Generate random training indices (70% for training, 30% for validation) without replacement. 
train_indices_b <- sample(1:nrow(train2), nrow(train2) * 0.7, replace = FALSE)

# Create training and validation partitions
train_partition_b <- train2[train_indices_b, ]
val_b <- train2[-train_indices_b, ]

## Libraries
library(DescTools)  # For Descriptive statistics (we can use this to calculate some prediction error metrics)
library(glmnet)     # For Ridge regression model training and evaluation

# Convert data to matrix format
input_features_b <- as.matrix(train_partition_b[, -length(train_partition_b)])
target_b <- train_partition_b$Y

# Cross-validation for model performance estimation with Lasso Regression type (alpha = 1)
cv_b <- cv.glmnet(input_features_b, target_b, alpha = 1, nfolds = 5)

# Error estimation for lambda min and lambda 1se
cv_b

# Store the validation results
cross_validation_MSE_b <- min(cv_b$cvm)
cross_validation_RMSE_b <- sqrt(cross_validation_MSE_b)

# Display the cross-validation results
cross_validation_MSE_b  # Display the cross-validation MSE for Model B
cross_validation_RMSE_b  # Display the cross-validation RMSE for Model B

# Create a data frame for the comparison
model_comparison <- data.frame(
  Model = c("Model A", "Model B"),
  Cross_Validation_MSE = c(cross_validation_MSE, cross_validation_MSE_b),  # Replace with actual MSE values
  Cross_Validation_RMSE = c(cross_validation_RMSE, cross_validation_RMSE_b)  # Replace with actual RMSE values
)

# Display the comparison table
model_comparison


#### FINAL EVALUATION #####

# Final model training, using the our training set & lambda min.
model_b <- glmnet(input_features_b, target_b, alpha = 0, lambda = cv_b$lambda.min)

# Making predictions using the trained model
test_data_b <- test[, c(1,2,3,5,7,9)]
predictions_b <- predict(model_b, s = model_b$lambda, newx = as.matrix(test_data_b[, -length(test_data_b)]))

# Evaluate the performance obtained on the test set.
test_MSE_b <- MSE(predictions_b, test_data_b$Y)
test_RMSE_b <- RMSE(predictions_b, test_data_b$Y)

# Plot of test set predictions vs actual values below
plot(x = predictions_b, y = test_data_b$Y, frame = FALSE, pch = 19, 
     col = "red", xlab = "test prediction", ylab = "ground-truth")
abline(0, 1, col = "blue")

# Creating a plot to check predicted vs actual in dual line charts.
test_instances_b <- c(1:nrow(test_data_b))

# Plotting ground-truth line (Actual vs. Predicted)
plot(x = test_instances_b, y = test_data_b$Y, frame = FALSE, pch = 19, type = "l",
     col = "red", xlab = "test instance", ylab = "Y")

lines(x = test_instances_b, y = predictions_b, pch = 18, col = "blue", type = "l", lty = 2)  #  Add the prediction values.

legend("topleft", legend=c("Actual", "Predicted"), col=c("red", "blue"), lty = 1:2, cex=0.8) # Adding a legend also.

# Comparing RMSE to check model performance. Creating a data frame to hold the RMSE values.
rmse_comparison <- data.frame(
  Dataset = c("cv_model_b", "Test"),
  RMSE = c(cross_validation_RMSE_b, test_RMSE_b))

# Printing RSME comparison.
print(rmse_comparison)





