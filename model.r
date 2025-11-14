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