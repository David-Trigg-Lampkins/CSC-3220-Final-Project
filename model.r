library(tidymodels)

crashes <- df
crashes$FIRSTHARMF <- as.integer(crashes$FIRSTHARMF)
crashes$LIGHTCONDI <- as.integer(crashes$LIGHTCONDI)
crashes$MANNEROFCO <- as.integer(crashes$MANNEROFCO)

# Split training and test sets
split <- initial_split(crashes, prop = 0.80)
trainData <- training(split)
testData <- testing(split)

# Not finished: kNN neads all features to be numeric

# Create kNN model
kNN <- nearest_neighbor(mode="classification", neighbors=5)

crashRecipe <- recipe(crashSeverity ~ FIRSTHARMF + MANNEROFCO + LIGHTCONDI,
                     data = trainData) |>
  step_normalize(all_numeric_predictors())

crashClassWflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(kNN)

crashClassFit <- fit(crashClassWflow, trainData)

testPred <- augment(crashClassFit, testData)

testPred |>
  ggplot(aes(x = crashSeverity, y = .pred_class)) + 
  geom_point()

# Training with 10-fold cross-validation 
folds <- vfold_cv(trainData, v = 10)
folds

crashesWorkflow1 <- workflow() |>
  add_model() |>
  add_formula(kNN) |>
  add_formula(crashSeverity ~ FIRSTHARMF + MANNEROFCO + LIGHTCONDI)

crashesFitCV <-
  crashesWorkflow1 |>
  fit_resamples(folds)

crashesFitCV

collect_metrics(crashesFitCV)