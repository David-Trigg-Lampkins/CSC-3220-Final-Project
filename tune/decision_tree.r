# This file needs model.r to be run first

library(tidymodels, dplyr)
library(rpart.plot, vip)

set.seed(123)

treeTuneSpec <-
  decision_tree(
    #cost_complexity = tune(),
    tree_depth = tune(),
    min_n = tune()
  ) |>
  set_engine("rpart") |>
  set_mode("classification")

treeTuneSpec

# Resample and select 5 different possible values for hyperparameters
treeGrid <- grid_regular(
  #cost_complexity(),
  tree_depth(),
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
bestTree <- treeRes |> select_best(metric = "accuracy")

bestTree

# Finalize model
finalTreeWf <- treeTuneWf |>
  finalize_workflow(bestTree)

# Finalize fit
finalTreeFit <- finalTreeWf |>
  last_fit(split)

finalTreeFit |> collect_metrics()

finalTreeFit |>
  collect_predictions() |>
  roc_curve(crashSeverity, .pred_class) |>
  autoplot()

# Extract workflow
finalTree <- extract_workflow(finalTreeFit)

finalTree

# Plot decision tree
finalTree |>
  extract_fit_engine() |>
  rpart.plot(roundint = FALSE)

# Find variable importance
finalTree |>
  extract_fit_parsnip() |>
  vip()
