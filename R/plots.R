make_download_plot <- function(
  downloads,
  packages,
  first_month = yearmonth("2000-Jan")
) {
  pkgs <- unique(packages$Package)
  pkgs <- c("forecast", pkgs[pkgs != "forecast"])
  cols <- c(
    "#000000",
    '#e41a1c',
    '#377ef8',
    '#4daf4a',
    '#984ea3',
    '#a65628',
    '#ff7f00',
    '#999999',
    '#f781bf',
    "#80b1d3"
  )
  cols <- cols[seq_along(pkgs)]
  names(cols) <- pkgs
  downloads <- downloads |>
    filter(Package %in% packages$Package, Month >= first_month) |>
    mutate(Package = factor(Package, levels = pkgs))
  if (nrow(packages) > 1) {
    p <- downloads |> ggplot(aes(x = Month, y = Count / 1e3, color = Package))
  } else {
    p <- downloads |> ggplot(aes(x = Month, y = Count / 1e3))
  }
  p <- p +
    geom_line() +
    labs(y = "Downloads (thousands)") +
    theme(
      axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0))
    )
  if (!("forecast" %in% packages$Package)) {
    p <- p + scale_y_continuous(breaks = seq(0, 100, 20), minor_breaks = NULL)
  }
  p +
    scale_x_yearmonth(breaks = seq(first_month, length = 50, by = 24)) +
    scale_color_manual(values = cols)
}
