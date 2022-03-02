add_country_names <- function(df) {
  country_names <- tribble(
    ~country, ~country_name,
    "AT", "Austria",
    "BR", "Brazil",
    "DE", "Germany",
    "GB", "United Kingdom",
    "IN", "India",
    "PT", "Portugal",
    "USA", "United States"
  )

  df %>%
    left_join(country_names, by = "country")
}

make_metadata_shareable <- function(meta_non_share, meta_share) {
  df <- read_csv(meta_non_share)

  df_share <- df %>%
    mutate(uni_name = case_when(country == "AT" & university == 1 ~ "",
                                TRUE ~ uni_name))

  df_share %>%
    write_csv(meta_share)
}


make_data_shareable <- function(non_share, share) {
  df <- read_csv(non_share)

  df_clean <- df %>%
    select(-all_of(c("rank", "overall", "teaching", "industry_income",
              "industrial_outlook"))) %>%
    mutate(uni_name = case_when(country == "AT" & university == 1 ~ "",
                                TRUE ~ uni_name))

  df_anon <- df_clean %>%
    mutate(
      research = case_when(
        country == "AT" & university == 1 ~ research + rnorm(1, sd = 20),
        TRUE ~ research
      ),
      citations = case_when(
        country == "AT" & university == 1 ~ citations + rnorm(1, sd = 20),
        TRUE ~ citations
      ))

  df_anon %>%
    write_csv(share)
}



# stuff on principal component analysis ----
parallel_test <- function(x) {
  initial_par <- par()
  ev <- eigen(cor(x, use = "pairwise.complete.obs")) # get eigenvalues
  ap <- nFactors::parallel(subject = nrow(x), var = ncol(x), rep = 100, cent = 0.05)
  nS <- nFactors::nScree(x = ev$values, aparallel = ap$eigen$qevpea)
  nFactors::plotnScree(nS)
  par(initial_par)
}

#' Plot factormap
#'
#' Plots a 2D-Representation of a PCA.
#'
#' @param x A \code{data.frame} containing all the variables of interest.
#'
#' @export
factormap <- function(x) {
  FactoMineR::PCA(x, graph = F) %>%
    FactoMineR::plot.PCA(., choix = "var")
}




principal_comp <- function(x, n, rotate = "varimax", cut = .2) {
  psych::principal(x, n, rotate = rotate) %>%
    psych::print.psych(., sort = T, cut = cut)
}

