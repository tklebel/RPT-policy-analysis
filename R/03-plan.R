plan <- drake_plan(
  shareable_metadata = make_data_shareable(
    non_share = file_in("data/metadata_non_share.csv"),
    share = file_out("data/metadata.csv")
  ),
  shareable_merged_data = make_data_shareable(
    non_share = file_in("data/merged_data_non_share.csv"),
    share = file_out("data/merged_data.csv")
  ),
  merged = shareable_merged_data,
  metadata = shareable_metadata,
  analysis = rmarkdown::render(
    knitr_in("01-analysis.Rmd"),
    output_file = file_out("01-analysis.html"),
    quiet = TRUE
  ),
  correspondence = rmarkdown::render(
    knitr_in("02-correspondence-analysis.Rmd"),
    output_file = file_out("02-correspondence-analysis.html"),
    quiet = TRUE
  ),
  addition = rmarkdown::render(
    knitr_in("03-additional-analyses.Rmd"),
    output_file = file_out("03-additional-analyses.html"),
    quiet = TRUE
  )
)
plan
