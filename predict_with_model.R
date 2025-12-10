# -----------------------------
# Forecast script using pre-trained ARMAX model
# -----------------------------
# Author: Maria Marroco
# Last updated: 2025-04-27
# -----------------------------
# This script loads a pre-trained ARMAX model and allows users to make predictions
# using their own data, as long as the format matches the expected input.
#
# Required columns in your CSV:
# - Water
# - Hour
# - Temperature
# - NH3
# - N_days (days of fattening)
# -----------------------------

# --- Load libraries ---
library(forecast)
library(dplyr)

# --- Load the pre-trained model ---
load("trained_armax_model.RData")  # This will load the model into your environment

# --- Load your own test data ---
# Replace 'your_data.csv' with your CSV file
your_data <- read.csv("your_data.csv")

# --- Visualize the observed Water time series ---
plot.ts(your_data$Water, col = "blue", lwd = 2, ylab = "Water Consumption", 
        main = "Observed Water Consumption Over Time")

# --- Prepare the regressor variables ---
t <- 1:nrow(your_data)
w <- 2 * pi / 24

harmonics <- data.frame(
  t = t,
  s1 = sin(w * t),
  c1 = cos(w * t),
  s2 = sin(2 * w * t),
  c2 = cos(2 * w * t),
  s3 = sin(3 * w * t),
  c3 = cos(3 * w * t),
  s4 = sin(4 * w * t),
  c4 = cos(4 * w * t)
)

# --- Ensure required variables are present ---
required_cols <- c("Temperature", "NH3", "N_days")
missing_cols <- setdiff(required_cols, names(your_data))

if (length(missing_cols) > 0) {
  stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
}

external_vars <- your_data %>%
  select(Temperature, NH3, N_days)

X_new <- cbind(harmonics, external_vars)

# --- Make forecast ---
forecast_result <- forecast(model, xreg = X_new, level = 95)

# --- Plot forecast results ---
predictions <- forecast_result$mean
lower_bound <- forecast_result$lower[, 1]
upper_bound <- forecast_result$upper[, 1]

plot.ts(predictions, col = "red", lwd = 2, ylab = "Predicted Water Consumption", 
        main = "Forecasted Water Intake")
lines(lower_bound, col = "gray", lty = 2)
lines(upper_bound, col = "gray", lty = 2)

legend("topleft", legend = c("Prediction", "95% Confidence Interval"),
       col = c("red", "gray"), lty = c(1, 2), lwd = 2)

# --- Plot prediction errors ---
if ("Water" %in% colnames(your_data)) {
  actual <- your_data$Water
  errors <- actual - predictions
  
  plot.ts(errors, col = "darkgreen", lwd = 2, ylab = "Prediction Error",
          main = "Prediction Errors Over Time")
  abline(h = 0, col = "black", lty = 2)
} else {
  warning("Column 'Water' not found in test data. Cannot compute prediction errors.")
}

# --- Optional: Export predictions to CSV ---
results <- data.frame(
  Actual = if ("Water" %in% colnames(your_data)) your_data$Water else NA,
  Prediction = as.numeric(predictions),
  Lower_95 = as.numeric(lower_bound),
  Upper_95 = as.numeric(upper_bound)
)

write.csv(results, "predictions_output.csv", row.names = FALSE)

cat("Forecast complete. Results saved to 'predictions_output.csv'.\n")
