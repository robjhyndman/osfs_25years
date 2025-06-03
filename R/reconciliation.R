R_reconciliation_packages <- function() {
  tibble(
    pkg = c("hts", "thief", "fable", "ForeReco"),
    first_release = c(2010, 2016, 2019, 2020),
    last_release = c(2024, 2018, 2025, 2024),
    cross_sectional = c(TRUE, FALSE, TRUE, TRUE),
    temporal = c(FALSE, TRUE, FALSE, TRUE),
    cross_temporal = c(FALSE, FALSE, FALSE, TRUE),
    probabilistic = c(FALSE, FALSE, TRUE, TRUE),
    bu = c(TRUE, TRUE, TRUE, TRUE),
    td = c(TRUE, TRUE, TRUE, TRUE),
    ols = c(TRUE, TRUE, TRUE, TRUE),
    wls = c(TRUE, TRUE, TRUE, TRUE),
    mint = c(TRUE, TRUE, TRUE, TRUE)
  )
}

Python_reconciliation_packages <- function() {
  tibble(
    pkg = c("sktime", "Darts", "pyhts", "HierarchicalForecast"),
    first_release = c(2019, 2020, 2021, 2022),
    last_release = c(2025, 2025, 2022, 2025),
    cross_sectional = c(TRUE, TRUE, TRUE, TRUE),
    temporal = c(FALSE, FALSE, TRUE, FALSE),
    cross_temporal = c(FALSE, FALSE, FALSE, FALSE),
    probabilistic = c(FALSE, FALSE, FALSE, TRUE),
    bu = c(TRUE, TRUE, FALSE, TRUE),
    td = c(TRUE, TRUE, FALSE, TRUE),
    ols = c(TRUE, TRUE, TRUE, TRUE),
    wls = c(TRUE, TRUE, TRUE, TRUE),
    mint = c(TRUE, TRUE, TRUE, TRUE)
  )
}

reco_pkg_table <- function(tab) {
  tab <- tab |>
    rename(
      `First release` = first_release,
      `Last release` = last_release,
      `Cross-sectional` = cross_sectional,
      `Temporal` = temporal,
      `Cross-temporal` = cross_temporal,
      `Probabilistic` = probabilistic,
      `BU` = bu,
      `TD` = td,
      `OLS` = ols,
      `WLS` = wls,
      `MinT` = mint
    )
  tab <- t(tab) |> as.data.frame()
  colnames(tab) <- tab[1, ]
  tab <- tab[-1, ]
  tab[tab == "TRUE"] <- "\\checkmark"
  tab[tab == "FALSE"] <- ""
  colnames(tab) <- paste0("\\texttt{", colnames(tab), "}")
  tab |>
    kbl(
      booktabs = TRUE,
      longtable = FALSE,
      escape = FALSE,
      format = "latex",
      linesep = "",
      align = "ccccc",
    ) |>
    row_spec(row = 0, bold = TRUE)
}
