# This file needs model.r to be run first

library(tidymodels, dplyr)
library(rpart.plot, vip)
library(future)

set.seed(123)

# Go quick with parallelism
plan(multisession, workers = parallel::detectCores() - 1)

treeTuneSpec <-
  rand_forest(
    trees = tune(),
    min_n = tune()
  ) |>
  set_engine("randomForest") |>
  set_mode("classification")

treeTuneSpec

# Resample and select 5 different possible values for hyperparameters
treeGrid <- grid_regular(
  trees(),
  min_n(),
  levels = 5
)

treeGrid

treeTuneWf <- workflow() |>
  add_model(treeTuneSpec) |>
  add_formula(crashSeverity ~ .)

treeRes <- treeTuneWf |>
  tune_grid(
    resamples = folds,
    grid = treeGrid
  )

treeRes

treeTuneMetrics <- treeRes |> collect_metrics()

treeRes |>
  collect_metrics() |>
  mutate(tree_depth = factor(tree_depth)) |>
  ggplot(aes(min_n, mean, color = tree_depth)) +
  geom_line(linwidth = 1.5, alpha = 0.6) +
  geom_point(size = 2) +
  facet_wrap(~ .metric, scales = "free", nrow = 2) +
  scale_x_log10(labels = scales::label_number()) +
  scale_color_viridis_d(option = "plasma", begin = .9, end = 0)

# Select the best based on a specific metric
bestRf <- treeRes |> select_best(metric = "accuracy")

bestRf

# Finalize model
finalRfWf <- treeTuneWf |>
  finalize_workflow(bestRf)

# Finalize fit
finalRfFit <- finalRfWf |>
  last_fit(split)

# Prevent parallel processing
plan(sequential)

finalRfFit |> collect_metrics()

finalRfFit |>
  collect_predictions() |>
  roc_curve(crashSeverity, .pred_class) |>
  autoplot()

# Extract workflow
finalRf <- extract_workflow(finalRfFit)

finalRf

# Plot decision tree
finalRf |>
  extract_fit_engine() |>
  rpart.plot(roundint = FALSE)

# Find variable importance
finalRf |>
  extract_fit_parsnip() |>
  vip()
