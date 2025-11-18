# The file clean.r must be run first
# Every other file in the folder must be run after this file

library(tidymodels, vip)
library(kknn)
library(randomForest)

set.seed(123)

# Help prevent confounders (such as traffic volume)
crashes <- df |> select(-ID_NUMBER, -BLM, -CASENO, -DATEOFCRAS, -TIMEO)

# Prevent data leakage
crashes <- crashes |> select(-TOTALKIL, -TOTALINJU, -TOTAL_INCA, -TOTAL_OTHE)

# Split training and test sets
split <- initial_split(crashes, prop = 0.80)
trainData <- training(split)
testData <- testing(split)

# Convert to dummy variables
# There are different methods of doing this in base R vs libraries
# Can do this in the tidymodels workflow
# https://topepo.github.io/caret/pre-processing.html#creating-dummy-variables

# General recipe for multiple models
crashRecipe <- recipe(crashSeverity ~ .,
                     data = trainData) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())

# Training with 10-fold cross-validation
folds <- vfold_cv(trainData, v = 10)
folds
