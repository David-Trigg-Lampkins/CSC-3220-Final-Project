# The file clean.r and null_model.r must be run first
# Every other file in the folder must be run after this file

library(tidymodels)
library(vip)
library(kknn)
library(randomForest)

set.seed(67)

# Remember to run null_model.r first since it contains reused functions

# Split training and test sets
# Moved to null_model.r to ensure same data sets

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
folds <- vfold_cv(trainData, v = 10, strata = crashSeverity)
folds
