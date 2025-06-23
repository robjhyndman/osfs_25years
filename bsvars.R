library(bsvars)
library(forecast)

us_fiscal_lsuw |>
  specify_bsvar$new(p = 1) |>
  estimate(S = 1000, show_progress = FALSE) |>
  estimate(S = 5000, show_progress = FALSE) |>
  forecast(h = 4)


fit <- us_fiscal_lsuw |>
  specify_bsvar$new(p = 1) |>
  estimate(S = 1000, show_progress = FALSE) |>
  estimate(S = 5000, show_progress = FALSE)

fit

vd <- compute_variance_decompositions(fit, h = 4)
vd
plot(vd)
# How to modify y labels?
# Why base graphics and not ggplot2?

ir <- compute_impulse_responses(fit, h = 4)
ir
plot(ir)

hd <- compute_historical_decompositions(fit)
hd
plot(hd)

fc <- forecast(fit, h = 4)
fc
plot(fc, xlab = "Days", data_in_plot = 0.2, col = "#c14b14")

# Which variable is which?

summary(fc)
# Which variable is which? Names not retained
# How to extract prediction intervals?
# Nice to have as.data.frame(fc)
pi <- summary(fc) |>
  purrr::map2_dfr(colnames(us_fiscal_lsuw), function(x, y) {
    as.data.frame(x, row.names = FALSE) |>
      dplyr::mutate(var = y)
  })
pi


us_fiscal_lsuw |>
  specify_bsvar$new(p = 1, exogenous = us_fiscal_ex) |>
  estimate(S = 1000, show_progress = FALSE) |>
  estimate(S = 5000, show_progress = FALSE) |>
  forecast(
    #horizon = 4, #8
    exogenous_forecast = us_fiscal_ex_forecasts,
    conditional_forecast = us_fiscal_cond_forecasts
  ) |>
  plot(col = "#c24b14")

help(forecast)
# No need for some lines

# Help for people who come with data in data frame or tibble format?
# Does it handle high frequency data (e.g., hourly)?
