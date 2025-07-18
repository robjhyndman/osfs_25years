library(targets)
library(tarchetypes)

tar_option_set(
  packages = c("tibble", "fpp3", "cranlogs", "kableExtra", "forecast", "smooth")
)
tar_source()

list(
  tar_target(history_file, "data/history.csv", format = "file"),
  tar_target(history, read.csv(history_file)),
  tar_target(packages, ctv_packages),
  tar_target(downloads, get_downloads(packages)),
  tar_target(top10, get_top_ten(downloads)),
  tar_target(top_ten_table, make_top_ten_table(top10)),
  tar_target(table1, make_table_history(head(history, 10))),
  tar_target(table2, make_table_history(tail(history, -10))),
  tar_target(
    plot1,
    make_download_plot(downloads, top10 |> filter(Package == "forecast"))
  ),
  tar_target(
    plot2a,
    make_download_plot(downloads, top10)
  ),
  tar_target(
    plot2b,
    make_download_plot(downloads, top10 |> filter(Package != "forecast"))
  ),
  tar_target(
    plot2c,
    make_download_plot(
      downloads,
      top10 |> filter(Package != "forecast"),
      first_month = yearmonth("2020-Jan")
    )
  ),
  tar_target(ets_benchmark, create_ets_benchmark()),
  tar_target(arima_benchmark, create_arima_benchmark()),
  tar_target(
    py_packages,
    c(
      "aeon",
      "darts",
      "gluonts",
      "kats",
      "merlion",
      "mlforecast",
      "neuralforecast",
      "neuralprophet",
      "pmdarima",
      "pytorch-forecasting",
      "skforecast",
      "sktime",
      "statsforecast",
      "statsmodels"
    )
  ),
  tar_target(pypi, pypi_downloads2(py_packages)),
  tar_target(pypi_graph1, pypi_graph(pypi)),
  tar_target(pypi_graph2, pypi_graph(pypi, all = FALSE)),
  tar_target(r_reco, R_reconciliation_packages()),
  tar_target(r_reco_table, reco_pkg_table(r_reco)),
  tar_target(py_reco, Python_reconciliation_packages()),
  tar_target(py_reco_table, reco_pkg_table(py_reco)),
  tar_quarto(osfs25, "osfs25.qmd", extra_files = fs::dir_ls("figs"))
)
