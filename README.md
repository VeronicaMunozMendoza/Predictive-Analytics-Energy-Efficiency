# Predictive Analytics for Building Energy Efficiency

In a world driven by data analytics, predictive analytics is a powerful tool. By leveraging historical and current data to forecast future outcomes, it can enhance decision-making, reduce costs, and improve customer experiences.

This project aims to predict the Cooling Load (Watts per m²) based on building parameters. The Cooling Load indicates the heat energy needed to maintain a steady indoor temperature during high outside temperatures. My goal is to train a model that predicts this load within +/- 4 Watts per m².

I will use RStudio and the R language for this project. RStudio offers comprehensive packages for data processing, statistical analysis, and visualization. R's flexibility and extensive functionality allow for effective complex data analyses and predictive model building. By utilizing these tools, I aim to develop an accurate Cooling Load prediction model.

I have two CSV files: CA_test_data.csv and CA_rain_data.csv. My first step is to perform an Exploratory Data Analysis (EDA) to understand the data. The insights gained from the EDA will guide me in preparing and transforming the data for my model.

## PRELIMINARY ANALYSIS CONCLUSIONS: 

Based on the information gathered from the preliminary analysis, the dataset is made of 537 observations distributed among 9 variables, all the variables are numeric or integer data types. On the other side, we can confidently say that our data is complete as it does not contain missing or NA values. This is very beneficial at a later stage during the project as missing data can bring into play bias which can lead to skewed results or inaccurate conclusions.   

The dataset is complete, making us confident that the analysis base is solid, and the results have the support of the general picture of the data. The following step will be performing an in-depth exploratory data analysis (EDA) to discover how the patterns are formed and their correlation. This lays the foundation for the data modelling section which will help to predict the Cooling Load. 

It is important to always be vigilant of any discrepancies that might occur or any unusual findings as we want to create a robust model that is reliable, thus this is one of the most important phases when creating a predictive analytics model. 

## FURTHER EXPLORATORY ANALYSIS (EDA)

After identifying the data types in the training dataset, I took a deeper look at the data. My methodology involves using summary statistics, visualizations, and exploratory analysis methods to identify trends, anomalies, and relationships, determining which variables will best fit the model. 

Here are some of the plots created in RStudio:

### Boxplots
![Rplot](https://github.com/user-attachments/assets/10cf22bc-5b80-48d2-b917-0520c71c5d17)

### Histograms
![Rplot01](https://github.com/user-attachments/assets/70eef22d-4037-451c-8ee9-0d4526687c01)

### Scatterplot Matrix
![Rplot02](https://github.com/user-attachments/assets/753b3f4d-36ee-427a-a784-027f016d5785)

### Correlation Matrix Heat Map
  ![Rplot03](https://github.com/user-attachments/assets/4bdc85a0-2fe9-4cc0-bcf8-9f0eed41581b)


## EXPLORATORY DATA ANALYSIS CONCLUSIONS

The dataset's variables have different ranges and distributions, explaining some scatterplot clusters. Variables like Overall_Height, Orientation, and Glazing_area have more uniform distributions. The target variable, Y, shows a wide range, indicating substantial variation in the Cooling Load.

The dataset is complete, with no missing or NA values, allowing me to proceed without handling missing data.

Overall_Height has the strongest correlation with Y (r = 0.898), while Orientation has the weakest (r = 0.006). I've also observed multicollinearity between Relative_Compactness and Roof_Area, with a strong negative correlation.

Key variables for predicting the Cooling Load include:

- Relative_Compactness: moderate positive correlation (0.628)
- Surface_Area: moderate negative correlation (-0.668)
- Wall_Area: moderate positive correlation (0.453)
- Roof_Area: strong negative correlation (-0.865)
- Overall_Height: strong positive correlation (0.898)

Multicollinearity exists between some independent variables:

- Relative_Compactness and Surface_Area: strong negative correlation (-0.992)
- Relative_Compactness and Roof_Area: strong negative correlation (-0.860)
- Surface_Area and Roof_Area: strong positive correlation (0.873)
- Overall_Height and Roof_Area: strong negative correlation (-0.973)

To address multicollinearity, I will use Ridge Regression in the next project phase to enhance model reliability and robustness.

For a more in-depth analysis beyond EDA, I will use regression analysis, given the numeric nature of the data and the continuous target variable.


## Linear Regression: 

I have created two linear regression models, one with all the building parameters and a second one only with 6 parameters. After training the model I have monitor how each of them perform in comparisno with the other, the conclusions were: 

- The adjusted R-squared of the first model is 0.8855, whereas the second model achieves 0.8857. Model 2 has a slightly higher adjusted R-squared.
- The residual standard error for model 1 is 3.291, marginally better than the previous model.
- I will use the model with 6 variables as it has a slightly better adjusted R-squared and helps avoid overfitting.

### R code and output: 

<img width="644" alt="Screenshot 2024-07-25 at 21 00 30" src="https://github.com/user-attachments/assets/12f74737-edb9-4951-bd70-11685fae4757">

## Modelling & Evaluation


The next phase involves data partitioning to implement cross-validation and ridge regression. I ensured data leakage prevention and reproducibility by setting random training indices without replacement. I selected 70% of the data for training and 30% for validation and set up cross-validation for Ridge Regression (alpha = 0). Additionally, I created a second model (Model B) to compare RMSE and determine the most suitable model for the test set.

This are the results: 

<img width="383" alt="image" src="https://github.com/user-attachments/assets/f6462879-22d1-4f58-b51d-f60fc5611e67">


The final step is to train the model using the training set and then make predictions with the trained model.


### R Code: 

<img width="452" alt="image" src="https://github.com/user-attachments/assets/51842e2a-001d-44b5-801a-a53f4fea5d8c">


### Output

<img width="441" alt="image" src="https://github.com/user-attachments/assets/b72780de-5380-4538-b2bd-ae65c01e2084">

In the previous scatterplot shows the ground truth vs. test predictions, with axes ranging from 10 to 45. There are two data clusters: one between 11-19 and another between 26-40, both with a positive linear correlation. The blue line represents the line of best fit. Points closer to this line indicate better model performance.

Predictions are more accurate in the 11-19 range, as points are closer to the line. In the 26-40 range, predictions are more dispersed, indicating less accuracy. This could be due to more data in the 11-19 range, constraints in predicting higher values, or increased variability and complexity in the data.


## Conclusion

<img width="165" alt="image" src="https://github.com/user-attachments/assets/e029ac2e-9825-40f6-b195-64432fa79498">

The RMSE comparison shows a small difference: Model B has an RMSE of 3.39 (Watts per m²) and the test dataset has an RMSE of 3.07 (Watts per m²), indicating better performance on the test dataset.

The model meets the specified criteria of +/- 4 (Watts per m²). However, it is advisable to monitor its performance over time and consider other influencing factors.


<img width="441" alt="image" src="https://github.com/user-attachments/assets/9685e1d4-cb0c-4212-926b-83b0b101edae">

The line graph depicts the model performance, actual values vs predicted values. We can see that there is some fluctuation on both the actual and the predicted and both seem to overlay within each other. This indicates the performance of the predictive model is pretty accurate with the actual observed data.  
