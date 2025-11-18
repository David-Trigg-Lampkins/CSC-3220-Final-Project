# Ryan
# plain decision tree with cross validation

# define the decision tree model specification. use rpart as engine for model
treeModel <- decision_tree(mode = "classification", engine = "rpart")

# create the workflow by bundling crashRecipe and treeModel
treeWorkflow <- workflow() |> add_recipe(crashRecipe) |> add_model(treeModel)

# fit the model with cross-validation folds
treeFitCV <- treeWorkflow |> fit_resamples(folds)

# 4. view metrics from the model
print(collect_metrics(treeFitCV))
