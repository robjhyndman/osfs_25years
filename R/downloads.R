ctv_packages <- c(
  "acp",
  "autostsm.statespacer",
  "BayesARIMAX",
  "bayesforecast",
  "BayesSSM",
  "bssm",
  "bsts",
  "coconots",
  "diffusion",
  "DIMORA",
  "fable.prophet",
  "fable",
  "fableCount",
  "fabletools",
  "finnts",
  "flap",
  "forecast",
  "ForecastComb",
  "forecastHybrid",
  "forecastML",
  "ForeComp",
  "forecTheta",
  "GAS",
  "gasmodel",
  "glarma",
  "GlarmaVarSel",
  "greybox",
  "hts",
  "kDGLM",
  "legion",
  "MAPA",
  "modeltime.ensemble",
  "modeltime.resample",
  "modeltime",
  "multDM",
  "mvgam",
  "nnfor",
  "onlineforecast",
  "opera",
  "profoc",
  "prophet",
  "PTSR",
  "Rlgt",
  "scoringRules",
  "scoringutils",
  "seer",
  "smooth",
  "spINAR",
  "tfarima",
  "thief",
  "tscount",
  "tsgc",
  "tsintermittent",
  "tsissm",
  "tsmodels",
  "tstests",
  "tsutils",
  "Ucomp",
  "vars",
  "ZIM",
  "ZINARp",
  "ZRA"
)

get_downloads <- function(packages) {
  downloads <- cranlogs::cran_downloads(
    packages = packages,
    from = as.Date("2000-01-01"),
    to = as.Date("2025-05-31")
  ) |>
    tibble::as_tibble()
  first_download <- downloads |>
    filter(count > 0) |>
    pull(date) |>
    min()
  downloads <- downloads |>
    filter(date >= first_download) |>
    mutate(Month = yearmonth(date)) |>
    group_by(Month, package) |>
    summarise(Count = sum(count), .groups = "drop") |>
    rename(Package = package)
}

get_top_ten <- function(downloads) {
  downloads |>
    group_by(Package) |>
    summarise(Count = sum(Count)) |>
    arrange(desc(Count)) |>
    head(10)
}

make_top_ten_table <- function(top_ten) {
  top_ten <- top_ten |>
    mutate(Count = round(Count / 1e3))
  colnames(top_ten) <- c("Package", "Downloads ('000)")
  top_ten |>
    kbl(longtable = FALSE, format = "latex", booktabs = TRUE, linesep = "") |>
    row_spec(0, bold = TRUE)
}
