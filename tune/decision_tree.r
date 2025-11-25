# Load necessary libraries
library(tidymodels)
library(rpart)
library(rpart.plot)
library(vip)

# We enable tuning for cost_complexity, tree_depth, and min_n
tree_spec <- decision_tree(
  cost_complexity = tune(),
  tree_depth = tune(),
  min_n = tune()
) |>
  set_engine("rpart") |>
  set_mode("classification")

# Create a grid of values to try for the hyperparameters
tree_grid <- grid_regular(
  cost_complexity(),
  tree_depth(),
  min_n(),
  levels = 5
)

# Combine the recipe from File 1 with the tunable model
tree_workflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(tree_spec)

# Use parallel processing to speed it up if available
doParallel::registerDoParallel()

tree_res <- tree_workflow |>
  tune_grid(
    resamples = folds,
    grid = tree_grid,
    metrics = evalMetrics,
    control = controlResamples
  )

# View the results of the tuning
tree_res |> collect_metrics()

# Plot the performance profiles
tree_res |> autoplot()

# Select the best set of hyperparameters based on area under curve

<<<<<<< HEAD
# Select the best based on a specific metric
bestTree <- treeRes |> select_best(metric = "f_meas")
=======
best_tree <- tree_res |> select_best(metric = "roc_auc")
>>>>>>> bce174ec8d624a5c45c187da320c179309cd632a

print(best_tree)

# Update the workflow with the best hyperparameters
final_tree_workflow <- tree_workflow |>
  finalize_workflow(best_tree)

# Fit to the training set and evaluate on the test set (using the 'split' object)
final_fit <- final_tree_workflow |>
  last_fit(split, metrics = evalMetrics)

# View final metrics on the test set
final_fit |> collect_metrics()

# Extract the final fitted model object for plotting
final_tree_model <- extract_workflow(final_fit)

# Plot the decision tree
final_tree_model |>
  extract_fit_engine() |>
  rpart.plot(roundint = FALSE)

# Plot variable importance
final_tree_model |>
  extract_fit_parsnip() |>
  vip()