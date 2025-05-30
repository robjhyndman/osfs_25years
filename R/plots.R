make_plot1 <- function(downloads) {
  downloads |>
    filter(Package == "forecast") |>
    ggplot(aes(x = Month, y = Count / 1e3)) +
    geom_line() +
    labs(y = "Downloads (thousands)")
}
make_plot2 <- function(
  downloads,
  top_ten,
  first_month = yearmonth("2000-Jan")
) {
  downloads |>
    filter(Package %in% top_ten$Package) |>
    filter(Package != "forecast", Month >= first_month) |>
    ggplot(aes(x = Month, y = Count / 1e3, color = Package)) +
    geom_line() +
    labs(y = "Downloads (thousands)")
}
