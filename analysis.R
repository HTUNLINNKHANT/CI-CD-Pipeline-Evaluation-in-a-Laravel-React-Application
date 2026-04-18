required_columns <- c(
  "Week",
  "Deployment_Frequency",
  "Lead_Time_Days",
  "Failure_Rate_Percentage",
  "MTTR_Hours",
  "PHP_Coverage",
  "React_Coverage"
)

run_t_test <- TRUE
split_week <- 6

data <- read.csv("dora_metrics.csv", stringsAsFactors = FALSE)

missing_columns <- setdiff(required_columns, names(data))
if (length(missing_columns) > 0) {
  stop(paste("Missing required columns:", paste(missing_columns, collapse = ", ")))
}

if (anyNA(data[required_columns])) {
  stop("Dataset contains missing values in required columns.")
}

numeric_columns <- setdiff(required_columns, "Week")
for (col in required_columns) {
  data[[col]] <- as.numeric(data[[col]])
}

if (anyNA(data[required_columns])) {
  stop("Non-numeric values found in required columns.")
}

data$Phase <- ifelse(data$Week <= split_week, "Pre_Pipeline", "Post_Pipeline")
data$Phase <- factor(data$Phase, levels = c("Pre_Pipeline", "Post_Pipeline"))

summary_stats <- data.frame(
  Metric = numeric_columns,
  Mean = sapply(data[numeric_columns], mean),
  Median = sapply(data[numeric_columns], median),
  SD = sapply(data[numeric_columns], sd),
  Min = sapply(data[numeric_columns], min),
  Max = sapply(data[numeric_columns], max),
  row.names = NULL
)

phase_comparison <- do.call(
  rbind,
  lapply(levels(data$Phase), function(phase_name) {
    subset_data <- data[data$Phase == phase_name, numeric_columns, drop = FALSE]
    data.frame(
      Phase = phase_name,
      Metric = numeric_columns,
      Mean = sapply(subset_data, mean),
      Median = sapply(subset_data, median),
      row.names = NULL
    )
  })
)

cat("=== Summary Statistics (All Weeks) ===\n")
print(summary_stats, row.names = FALSE)

cat("\n=== Pre vs Post Pipeline Comparison ===\n")
print(phase_comparison, row.names = FALSE)

if (run_t_test) {
  t_test_results <- do.call(
    rbind,
    lapply(numeric_columns, function(metric_name) {
      pre_values <- data[data$Phase == "Pre_Pipeline", metric_name]
      post_values <- data[data$Phase == "Post_Pipeline", metric_name]
      test_result <- t.test(pre_values, post_values, var.equal = FALSE)
      data.frame(
        Metric = metric_name,
        Pre_Mean = mean(pre_values),
        Post_Mean = mean(post_values),
        Mean_Difference = mean(post_values) - mean(pre_values),
        P_Value = test_result$p.value,
        CI_Lower = test_result$conf.int[1],
        CI_Upper = test_result$conf.int[2],
        row.names = NULL
      )
    })
  )

  cat("\n=== Welch t-test Results (Pre vs Post) ===\n")
  print(t_test_results, row.names = FALSE)
}
