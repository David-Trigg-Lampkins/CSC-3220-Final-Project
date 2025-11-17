# This file is for evaluating the models created in model.r and comparing them to the null model created in null_model.r

library(dplyr)

# Functions

# Takes two metric set tibbles as arguments, determine if tbl2 is better than tbl1 for all metrics
checkModelAll <- function(tbl1, tbl2) {
  # Join by metric
  joined <- inner_join(
    tbl1 |> select(.metric, .estimate1 = .estimate),
    tbl2 |> select(.metric, .estimate2 = .estimate),
    by = ".metric"
  )
  
  # Check if all values in tbl2 are greater than tbl1
  all(joined$.estimate2 > joined$.estimate1)
}

# Takes two metric set tibbles as arguments, determine if tbl2 is better than tbl1 for at least one metric
checkModelSome <- function(tbl1, tbl2) {
  # Join by metric
  joined <- inner_join(
    tbl1 |> select(.metric, .estimate1 = .estimate),
    tbl2 |> select(.metric, .estimate2 = .estimate),
    by = ".metric"
  )
  
  # Check if all values in tbl2 are greater than tbl1
  any(joined$.estimate2 > joined$.estimate1)
}

# Evaluation

print("kNN (regular):")
checkModelSome(nullPerf, kNNPerf)
checkModelAll(nullPerf, kNNPerf)

print("Random forest (regular):")
checkModelSome(nullPerf, rfPerf)
checkModelAll(nullPerf, rfPerf)