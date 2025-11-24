# Trey
# This file needs clean.r to be run first

library(dplyr, tidymodels)

set.seed(67)

# Help prevent confounders (such as traffic volume)
crashes <- df |> select(-ID_NUMBER, -CASENO, -DATEOFCRAS, -TIMEO)

# Prevent data leakage
crashes <- crashes |> select(-TOTALKIL, -TOTALINJU, -TOTAL_INCA, -TOTAL_OTHE)

# Split training and test sets
split <- initial_split(crashes, prop = 0.80)
trainData <- training(split)
testData <- testing(split)

# Null "model" recommended by Mr. C
majority <- names(which.max(table(trainData$crashSeverity)))

preds <- tibble(
  truth = trainData$crashSeverity,
  .pred_class = factor(majority, levels = levels(trainData$crashSeverity))
)

metrics(preds, truth = truth, estimate = .pred_class)

evalMetrics <- metric_set(accuracy, precision, recall)
nullPerf <- evalMetrics(preds, truth = truth, estimate = .pred_class)

nullPerf
