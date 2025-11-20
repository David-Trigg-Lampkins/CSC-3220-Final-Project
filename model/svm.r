# Trigg
install.packages("kernlab")
library(kernlab)
library(tidymodels)
#linear
linearSVM <- svm_linear(mode = "classification", 
                        cost = 0.01, engine = "kernlab")
linearworkflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(linearSVM)
linearSVMFit <- fit(linearworkflow, trainData)
linearSVMFit

#RBF
rbfSVM <- svm_rbf(mode = "classification", cost = 10, 
                  rbf_sigma = 3, engine = "kernlab") 
RbfWflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(rbfSVM)
rbfSVMFit <- fit(RbfWflow, trainData)
testPred <- augment(rbfSVMFit, testData)
testPred |> recall(crashSeverity, .pred_class)
testPred |> conf_mat(crashSeverity, .pred_class)
testPred |>
  conf_mat(crashSeverity, .pred_class) |>
  autoplot(type = "heatmap")

#polynomial
polySVM <- svm_poly(mode = "classification", cost = 1, 
                    degree = 2, engine = "kernlab")
PolyWflow <- workflow() |>
  add_recipe(crashRecipe) |>
  add_model(polySVM)
polySVMFit <- fit(RbfWflow, trainData)
testPred <- augment(polySVMFit, testData)
testPred |> recall(crashSeverity, .pred_class)
testPred |> conf_mat(crashSeverity, .pred_class)
testPred |>
  conf_mat(crashSeverity, .pred_class) |>
  autoplot(type = "heatmap")