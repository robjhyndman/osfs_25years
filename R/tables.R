make_table_history <- function(history) {
  history |>
    kbl(
      longtable = FALSE,
      format = "latex",
      booktabs = TRUE,
      escape = FALSE,
      linesep = "",
      row.names = FALSE
    ) |>
    column_spec(1, width = "4cm") |>
    column_spec(2, width = "10cm") |>
    row_spec(0, bold = TRUE)
}
