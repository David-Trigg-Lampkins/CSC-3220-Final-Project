# Trey

# Create kNN model
kNN <- nearest_neighbor(mode="classification", neighbors=7, engine = "kknn")

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

crashesWorkflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(kNN)

crashesFitCV <-
  crashesWorkflow |>
  fit_resamples(resamples = folds, metrics = evalMetrics, control = controlResamples)

crashesFitCV

print(collect_metrics(crashesFitCV))
