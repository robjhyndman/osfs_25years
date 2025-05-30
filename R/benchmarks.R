create_ets_benchmark <- function() {
  bench::mark(
    forecast = forecast::ets(AirPassengers) |> forecast(h = 10),
    fable = as_tsibble(AirPassengers) |> model(ETS(value)) |> forecast(h = 10),
    smooth = smooth::es(AirPassengers) |>
      forecast(h = 10, interval = "parametric"),
    check = FALSE
  ) |>
    select(expression, min, median, `itr/sec`, mem_alloc) |>
    kbl(format = "latex", booktabs = TRUE, digits = 2)
}

create_arima_benchmark <- function() {
  bench::mark(
    forecast = auto.arima(AirPassengers, lambda = 0, biasadj = TRUE) |>
      forecast(h = 12),
    fable = as_tsibble(AirPassengers) |>
      model(ARIMA(log(value))) |>
      forecast(h = 12),
    smooth = auto.ssarima(log(AirPassengers)) |>
      forecast(h = 12, interval = "parametric"),
    check = FALSE
  ) |>
    select(expression, min, median, `itr/sec`, mem_alloc) |>
    kbl(format = "latex", booktabs = TRUE, digits = 2)
}
