# The file clean.r and null_model.r must be run first
# Every other file in the folder must be run after this file

library(tidymodels)
library(vip)
library(kknn)
library(randomForest)

set.seed(67)

<<<<<<< HEAD
# Remember to run null_model.r first since it contains reused functions
=======
# Functions used across multiple files
evalMetrics <- metric_set(accuracy, recall, f_meas, roc_auc)
controlResamples <- control_resamples(save_pred = TRUE, verbose = TRUE)

# Help prevent confounders (such as traffic volume)
crashes <- df |> select(-ID_NUMBER, -CASENO, -DATEOFCRAS, -TIMEO)

# Prevent data leakage
crashes <- crashes |> select(-TOTALKIL, -TOTALINJU, -TOTAL_INCA, -TOTAL_OTHE)
>>>>>>> bce174ec8d624a5c45c187da320c179309cd632a

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
