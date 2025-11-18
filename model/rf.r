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
