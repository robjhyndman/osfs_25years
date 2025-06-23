pypi_downloads_pkg <- function(pkg) {
  sql <- paste0(
    "SELECT
  COUNT(*) AS num_downloads,
  DATE_TRUNC(DATE(timestamp), MONTH) AS `month`
FROM `bigquery-public-data.pypi.file_downloads`
WHERE
  file.project ='",
    pkg,
    "'
  AND DATE(timestamp)
    BETWEEN DATE_TRUNC(DATE_SUB(CURRENT_DATE(), INTERVAL 120 MONTH), MONTH)
    AND CURRENT_DATE()
GROUP BY `month`
ORDER BY `month` DESC"
  )
  tb <- bigrquery::bq_project_query("graphical-fort-463705-n8", query = sql)
  #tb <- bigrquery::bq_project_query("pypi-stats-463705", query = sql)
  bigrquery::bq_table_download(tb) |>
    mutate(package = pkg)
}

pypi_downloads <- function(pkgs) {
  if (file.exists("data/pypi.csv")) {
    return(readr::read_csv("data/pypi.csv"))
  }

  out <- purrr::map(pkgs, pypi_downloads_pkg)
  browser()
  write.csv(out, "data/pypi.csv", row.names = FALSE)
  out
}

pypi_downloads2 <- function(pkgs) {
  pkgs |>
    purrr::map_dfr(function(x) {
      file <- paste0("data/", x, ".json")
      jsonlite::fromJSON(file)$data |>
        mutate(package = x)
    }) |>
    tibble::as_tibble() |>
    filter(category == "with_mirrors") |>
    group_by(date, package) |>
    summarise(downloads = sum(downloads), .groups = "drop") |>
    mutate(date = tsibble::yearmonth(date)) |>
    tsibble::as_tsibble(key = package, index = date)
}

pypi_graph <- function(pypi, all = TRUE) {
  pypi_order <- pypi |>
    filter(date == max(date)) |>
    arrange(desc(downloads)) |>
    pull(package)
  cols <- c(
    "#000000",
    "#e41a1c",
    "#377ef8",
    "#4daf4a",
    "#984ea3",
    "#a65628",
    "#ff7f00",
    "#999999",
    "#f781bf",
    "#80b1d3",
    rainbow(4)
  )
  names(cols) <- pypi_order
  pypi <- pypi |>
    mutate(
      downloads = downloads / 1e3,
      Package = factor(package, levels = pypi_order)
    )
  if (!all) {
    pypi <- pypi |>
      filter(package %in% pypi_order[-c(1:2)])
  }
  pypi |>
    ggplot() +
    aes(x = date, y = downloads, color = Package) +
    geom_line(linewidth = .7) +
    labs(x = "Month", y = "Pypi downloads (thousands)") +
    scale_color_manual(values = cols)
}
