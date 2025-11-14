library(tidymodels, vip)

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

# Not finished: kNN neads all features to be numeric

# Create kNN model
kNN <- nearest_neighbor(mode="classification", neighbors=5)

# General recipe for multiple models
crashRecipe <- recipe(crashSeverity ~ .,
                     data = trainData) |>
  step_normalize(all_numeric_predictors()) |>
  step_dummy(all_nominal_predictors())

# Workflow for kNN
crashClassWflow1 <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(kNN)

crashClassFit <- fit(crashClassWflow1, trainData)

testPred <- augment(crashClassFit, testData)

testPred |> metrics(crashSeverity, .pred_class)

# Macro averaged multiclass precision/recall
testPred |> precision(crashSeverity, .pred_class)
testPred |> recall(crashSeverity, .pred_class)
testPred |> conf_mat(crashSeverity, .pred_class)
testPred |>
  conf_mat(crashSeverity, .pred_class) |>
  autoplot(type = "heatmap")

# Random forest
rfModel <- rand_forest(mode = "classification",
                       engine = "randomForest",
                       mtry = 3,
                       min_n = 10)

# Workflow for rf
crashClassWflow2 <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(rfModel)

rfModelFit <- crashClassWflow2 |>
  fit(data = trainData)

rfModelFit

# Variable importance table
#rfModelFit |>
# extract_fit_parsnip() |>
#  vi()

testPredRf <- augment(rfModelFit, testData)

testPredRf |> metrics(crashSeverity, .pred_class)

# Macro averaged multiclass precision/recall
testPredRf |> precision(crashSeverity, .pred_class)
testPredRf |> recall(crashSeverity, .pred_class)

testPredRf |> conf_mat(truth=crashSeverity, estimate=.pred_class)
testPredRf |>
  conf_mat(crashSeverity, .pred_class) |>
  autoplot(type = "heatmap")

# Training with 10-fold cross-validation 
folds <- vfold_cv(trainData, v = 10)
folds

crashesWorkflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(kNN)

crashesFitCV <-
  crashesWorkflow |>
  fit_resamples(folds)

crashesFitCV

print(collect_metrics(crashesFitCV))

# Oviya
# Ensure crashSeverity is a factor for classification metrics
trainData <- trainData |> mutate(crashSeverity = as.factor(crashSeverity))  
testData  <- testData  |> mutate(crashSeverity = as.factor(crashSeverity))   

# 10-fold stratified CV (stratify on crashSeverity)
rf_folds <- vfold_cv(trainData, v = 10, strata = crashSeverity)             # NEW

# Metrics to compute (trimmed to accuracy + F1)
rf_metrics <- metric_set(accuracy, f_meas)                                   

# Run resampling on the rf workflow (save_pred=TRUE to inspect predictions)
rf_res <- crashClassWflow2 |>
  fit_resamples(
    resamples = rf_folds,
    metrics   = rf_metrics,
    control   = control_resamples(save_pred = TRUE, verbose = TRUE)
  )                                                                         

# Summary of CV metrics (mean, std_err, etc.)
cv_metrics_rf <- collect_metrics(rf_res)                                    
print(cv_metrics_rf)                                                        

# Collect all fold-level predictions 
cv_preds_rf <- collect_predictions(rf_res)                                  

# Quick peek at CV predictions
dplyr::glimpse(cv_preds_rf)                                                  
head(cv_preds_rf) 
