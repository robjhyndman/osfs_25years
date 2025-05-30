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
  tar_target(plot1, make_plot1(downloads)),
  tar_target(plot2, make_plot2(downloads, top10)),
  tar_target(
    plot3,
    make_plot2(downloads, top10, first_month = yearmonth("2020-Jan"))
  ),
  tar_target(ets_benchmark, create_ets_benchmark()),
  tar_target(arima_benchmark, create_arima_benchmark()),
  tar_quarto(osfs25, "osfs25.qmd")
)
