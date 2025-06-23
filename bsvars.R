library(bsvars)
library(forecast)

us_fiscal_lsuw |>
  specify_bsvar$new(p = 1) |>
  estimate(S = 100, show_progress = FALSE) |>
  estimate(S = 1000, show_progress = FALSE) |>
  forecast(horizon = 4) -> predictive

predictive
# Nicer print?
summary(predictive)
# Which variable is which? Names not retained
# How to extract prediction intervals?
pi <- summary(predictive) |>
  purrr::map2_dfr(colnames(us_fiscal_lsuw), function(x, y) {
    as.data.frame(x, row.names = FALSE) |>
      dplyr::mutate(var = y)
  })
pi


plot(predictive, xlab = "Days", data_in_plot = 0.2, col = "#c14b14")
# How to modify y labels?
# Why base graphics and not ggplot2?

us_fiscal_lsuw |>
  specify_bsvar$new(p = 1, exogenous = us_fiscal_ex) |>
  estimate(S = 5, show_progress = FALSE) |>
  estimate(S = 10, show_progress = FALSE) |>
  forecast(
    horizon = 8,
    exogenous_forecast = us_fiscal_ex_forecasts,
    conditional_forecast = us_fiscal_cond_forecasts
  ) |>
  plot(col = "#c24b14")


help(forecast)
# No need for some lines
