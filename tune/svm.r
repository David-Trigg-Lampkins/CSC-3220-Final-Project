# This file needs model.r to be run first
# Source: https://www.tidymodels.org/learn/work/tune-svm/

library(tidymodels, dplyr)
library(kernlab)

set.seed(123)

# Go quick with parallelism
plan(multisession, workers = parallel::detectCores() - 1)

svmTuneSpec <-
  svm_rbf(
    cost = tune(),
    rbf_sigma = tune()
  ) |>
  set_engine("kernlab") |>
  set_mode("classification")

svmTuneSpec

# Resample and select 5 different possible values for hyperparameters
svmGrid <- grid_regular(
  cost(),
  rbf_sigma(),
  levels = 5
)

svmGrid

svmTuneWf <- workflow() |>
  add_model(svmTuneSpec) |>
  add_formula(crashSeverity ~ .)

svmRes <- svmTuneWf |>
  tune_grid(
    resamples = folds,
    grid = svmGrid,
    metrics = evalMetrics,
    control = controlResamples
  )

svmRes

svmTuneMetrics <- svmRes |> collect_metrics()

svmRes |>
  collect_metrics() |>
  mutate(cost = factor(cost)) |>
  ggplot(aes(cost, mean, color = cost)) +
  geom_line(linwidth = 1.5, alpha = 0.6) +
  geom_point(size = 2) +
  facet_wrap(~ .metric, scales = "free", nrow = 2) +
  scale_color_viridis_d(option = "plasma", begin = .9, end = 0)

# Select the best based on a specific metric
bestSVM <- svmRes |> select_best(metric = "recall")

bestSVM

# Finalize model
finalSVMWf <- svmTuneWf |>
  finalize_workflow(bestSVM)

# Finalize fit
finalSVMFit <- finalSVMWf |>
  last_fit(split, metrics = evalMetrics)

# Prevent parallel processing
plan(sequential)

finalSVMFit |> collect_metrics()

finalSVMFit |>
  collect_predictions() |>
  roc_curve(crashSeverity, .pred_class) |>
  autoplot()

# Extract workflow
finalSVM <- extract_workflow(finalSVMFit)

finalSVM