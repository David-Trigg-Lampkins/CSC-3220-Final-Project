# This file needs model.r to be run first
# Oviya
library(tidymodels)
library(randomForest)
library(vip)
library(doParallel) 
library(ggplot2)

set.seed(67)

# Parallel processing
# Detect number of cores and use all but one "exhaustive"
all_cores <- parallel::detectCores(logical = FALSE)
cl <- makePSOCKcluster(all_cores - 1)
registerDoParallel(cl)


# Mark hyperparameters for tuning 
rf_tune_model <- rand_forest(
  mode = "classification",
  engine = "randomForest",
  mtry = tune(), # Number of variables randomly sampled at each split
  trees = tune(), # Number of trees in the forest
  min_n = tune() # Minimum number of data points in a node for splitting
)

# Workflow
rf_tune_workflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(rf_tune_model)

# Regular grid 
rf_grid_regular <- grid_regular(
  mtry(range = c(2, 8)),          
  trees(range = c(100, 1000)),   
  min_n(range = c(5, 30)),         
  levels = 3                        
)

print(rf_grid_regular)

# Hyperparameter tuning
chosen_grid <- rf_grid_regular  

# Tune the model using cross-validation
rf_tune_results <- rf_tune_workflow |>
  tune_grid(
    resamples = folds,            
    grid = chosen_grid, 
    metrics = evalMetrics, 
    control = control_grid(
      save_pred = TRUE,
      verbose = TRUE,
      allow_par = TRUE # Enable parallel processing
    )
  )


# Tuning results
show_best(rf_tune_results, metric = "accuracy", n = 10)

show_best(rf_tune_results, metric = "f_meas", n = 10)

show_best(rf_tune_results, metric = "recall", n = 10)

# Select best model based on accuracy
best_rf_params <- select_best(rf_tune_results, metric = "accuracy")
print(best_rf_params)

# Plot performance across different hyperparameters
autoplot(rf_tune_results, metric = "accuracy") +
  labs(title = "Random Forest Tuning Results - Accuracy",
       subtitle = "Performance")

autoplot(rf_tune_results, metric = "f_meas") +
  labs(title = "Random Forest Tuning Results - F-Measure",
       subtitle = "Performance")



rf_tune_results |>
  collect_metrics() |>
  filter(.metric == "accuracy") |>
  ggplot(aes(x = mtry, y = mean, color = factor(min_n))) +
  geom_point(size = 3) +
  geom_line(aes(group = interaction(min_n, trees))) +
  facet_wrap(~ trees, labeller = label_both) +
  labs(title = "Accuracy vs mtry",
       x = "Number of Predictors",
       y = "Mean Accuracy",
       color = "Min Node Size") +
  theme_minimal()

# Update workflow with best hyperparameters
final_rf_workflow <- rf_tune_workflow |>
  finalize_workflow(best_rf_params)

<<<<<<< HEAD
# Select the best based on a specific metric
bestRf <- treeRes |> select_best(metric = "f_meas")
=======
print(final_rf_workflow)
>>>>>>> bce174ec8d624a5c45c187da320c179309cd632a

# Final fit 
final_rf_fit <- final_rf_workflow |>
  fit(data = trainData)

print(final_rf_fit)

# Make predictions on test data
test_predictions <- augment(final_rf_fit, testData)

# Calculate test set metrics
test_metrics <- test_predictions |>
  metrics(truth = crashSeverity, estimate = .pred_class)
print(test_metrics)

# Detailed metrics
print(test_predictions |> accuracy(crashSeverity, .pred_class))

print(test_predictions |> precision(crashSeverity, .pred_class))

print(test_predictions |> recall(crashSeverity, .pred_class))

print(test_predictions |> f_meas(crashSeverity, .pred_class))

# Confusion matrix
conf_mat_result <- test_predictions |>
  conf_mat(truth = crashSeverity, estimate = .pred_class)
print(conf_mat_result)

# Visualize confusion matrix
test_predictions |>
  conf_mat(crashSeverity, .pred_class) |>
  autoplot(type = "heatmap") +
  labs(title = "Confusion Matrix",
       subtitle = paste("Test Set Performance with Optimized Hyperparameters"))

# Variable importance
vip_data <- final_rf_fit |>
  extract_fit_parsnip() |>
  vip(num_features = 15)

print(vip_data)

# Compare 
print(best_rf_params)

# Stop parallel processing cluster
stopCluster(cl)
registerDoSEQ()

