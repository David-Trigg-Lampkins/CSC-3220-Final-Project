# This file needs model.r to be run first

library(tidymodels, dplyr)
library(rpart.plot, vip)
library(future)

set.seed(67)

# Go quick with parallelism
plan(multisession, workers = parallel::detectCores() - 1)

kNNTuneSpec <-
  nearest_neighbor(
    neighbors = tune()
  ) |>
  set_engine("kknn") |>
  set_mode("classification")

kNNTuneSpec

# Resample and select 5 different possible values for hyperparameters
kNNGrid <- grid_regular(
  neighbors(),
  levels = 5
)

kNNGrid

kNNTuneWf <- workflow() |>
  add_model(kNNTuneSpec) |>
  add_recipe(crashRecipe)

kNNRes <- kNNTuneWf |>
  tune_grid(
    resamples = folds,
    grid = kNNGrid,
    metrics = evalMetrics,
    control = controlResamples
  )

kNNRes

kNNTuneMetrics <- kNNRes |> collect_metrics()

kNNRes |>
  collect_metrics() |>
  mutate(neighbors = factor(neighbors)) |>
  ggplot(aes(neighbors, mean, color = neighbors)) +
  geom_line(linewidth = 1.5, alpha = 0.6) +
  geom_point(size = 2) +
  facet_wrap(~ .metric, scales = "free", nrow = 2) +
  scale_color_viridis_d(option = "plasma", begin = .9, end = 0)

# Select the best based on a specific metric
bestKNN <- kNNRes |>  select_best(metric = "f_meas")

bestKNN

# Finalize model
finalKNNWf <- kNNTuneWf |>
  finalize_workflow(bestKNN)

# Finalize fit
finalKNNFit <- finalKNNWf |>
  last_fit(split, metrics = evalMetrics)

# Prevent parallel processing
plan(sequential)

finalKNNFit |> collect_metrics()

finalKNNFit |>
  collect_predictions() |>
  roc_curve(crashSeverity, .pred_class) |>
  autoplot()

# Extract workflow
finalKNN <- extract_workflow(finalKNNFit)

finalKNN

# Plot kNN
finalKNN |>
  extract_fit_engine()

# Find variable importance
finalKNN |>
  extract_fit_parsnip() |>
  vip()
