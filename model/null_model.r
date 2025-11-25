# Trey
# This file needs clean.r to be run first

library(dplyr, tidymodels)
library(parsnip)

set.seed(67)

# Functions used across multiple files
evalMetrics <- metric_set(accuracy, f_meas, recall)
controlResamples <- control_resamples(save_pred = TRUE, verbose = TRUE)

# Help prevent confounders (such as traffic volume)
crashes <- df |> select(-ID_NUMBER, -CASENO, -DATEOFCRAS, -TIMEO)

# Prevent data leakage
crashes <- crashes |> select(-TOTALKIL, -TOTALINJU, -TOTAL_INCA, -TOTAL_OTHE)

# Split training and test sets
split <- initial_split(crashes, prop = 0.80)
trainData <- training(split)
testData <- testing(split)

# Improved "null" model by Mr. C
# Apparently this is the official tidyverse method with parsnip
# Allows cross-validation for a null model
nullModel <- null_model() |>
  set_engine("parsnip") |>
  set_mode("classification")

nullWf <- workflow() |>
  add_model(nullModel) |>
  add_variables(outcomes = crashSeverity, predictors = NULL)

nullModelPerf <- nullWf |>
  fit_resamples(
    metrics = evalMetrics,
    resamples = vfold_cv(df, v = 10, strata = crashSeverity),
    control = controlResamples
  )

nullModelPerf |> collect_metrics()

# Final null fit
finalNullFit <- nullWf |>
  last_fit(split, metrics = evalMetrics, control = controlResamples)

nullPerf <- finalNullFit |> collect_metrics()
nullPerf