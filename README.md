# Indicators of research quality, quantity, openness and responsibility in institutional promotion, review and tenure policies across seven countries 

This repository holds code and data for the preprint "Indicators of research quality, quantity, openness and responsibility in institutional promotion, review and tenure policies across seven countries""



## Reproducible code
The analytic pipeline for creating the figures is reproducible through the
`drake` package. Running `r_make()` will rebuild the analysis.

The pipeline is specified in the file `R/03-plan.R`. You can visualise the
dependencies with the following code:

```r
library(drake)
source("R/03-plan.R")

vis_drake_graph(plan)
```


All packages that are used during the analysis are specified in `R/packages.R`.
For the analysis files to render you will need to install the font "Hind" (for
example from [Google Fonts](https://fonts.google.com/)) and
register it with
[`extrafont`](https://cran.r-project.org/web/packages/extrafont/README.html).
See the file `load_fonts.R` for specific instructions.


### Code files

The code to reproduce all values and figures can be found in three RMarkdown 
documents:

- 01-analysis.Rmd
- 02-correspondence-analysis.Rmd
- 03-additional-analyses.Rmd

Further core files for the analysis pipeline's reproducibility are the following:

|File name                        |Purpose                                                                    |
|:-------------------------------|:--------------------------------------------------------------------------|
|_drake.R                        |Core file for building the analysis. Run with `drake::r_make("_drake.R")`.|
|R/00-packages.R                 |Lists and loads all packages relevant to the analysis.                 |
|R/01-functions.R                |Functions that wrap preprocessing tasks as outlined in `plan.R`.|
|R/02-plan.R                     |Describes all inputs and outputs along with the functions processing them.|


## Data description
Procedures for generating the data are outlined in the preprint. Data collection
was conducted in GoogleSheets. Data was then downloaded and collated via the 
code in `R/collate-data.R` and further prepared for analysis, by merging with
data from the Times Higher Education World University Rankings (WUR). We 
manually copied the data from the WUR, and cleaned and merged it with code.

One of the Austrian institutions was granted anonymity, since their 
RPT-documents were not public at the time of the study. For this reason, we have
taken two steps:

1. Remove the institution's name from the metadata.
2. Obfuscate the institutions ranking position in data from the WUR.


For this reason, results concerning the relationship between indicators and
rankings deviate slightly when using the data we share here from the results in
the preprint. 


### Overview of data files

|File name                        |Purpose                                                               |
|:-------------------------------|:---------------------------------------------------------------------|
|data/policies_collated_cleaned_translated_recoded.csv |Indicator data on the RPT-policies. This includes the original snippet of text where an indicator was found, an English translation, as well as further metadata on the specific policies.|
|data/metadata.csv|Metadata on the included institutions regarding their position in our sampling strategy, as well as research and citation values from the WUR.|
|data/merged_data.csv |The final dataset on which the analysis rests. This dataset contains the policy coded data, metadata, and an additional column with more readable names for the indicators for creating figures.|


## Further resources
You can find more information on the `drake` package here:
https://books.ropensci.org/drake/



## Package versions used
The analysis was last rendered with the following package versions:

```
- Session info -----------------------------------------------------------------
 setting  value
 version  R version 4.1.2 (2021-11-01)
 os       Windows 10 x64 (build 19044)
 system   x86_64, mingw32
 ui       RStudio
 language (EN)
 collate  German_Austria.1252
 ctype    German_Austria.1252
 tz       Europe/Berlin
 date     2022-03-02
 rstudio  2021.09.1+372 Ghost Orchid (desktop)
 pandoc   2.14.0.3 @ C:/Users/tklebel/AppData/Local/Programs/RStudio/bin/pandoc/ (via rmarkdown)

- Packages ---------------------------------------------------------------------
 package      * version  date (UTC) lib source
 ash            1.0-15   2015-09-01 [1] CRAN (R 4.1.1)
 assertthat     0.2.1    2019-03-21 [1] CRAN (R 4.1.1)
 backports      1.3.0    2021-10-27 [1] CRAN (R 4.1.1)
 base64url      1.4      2018-05-14 [1] CRAN (R 4.1.2)
 broom          0.7.10   2021-10-31 [1] CRAN (R 4.1.1)
 cachem         1.0.6    2021-08-19 [1] CRAN (R 4.1.2)
 callr          3.7.0    2021-04-20 [1] CRAN (R 4.1.1)
 cellranger     1.1.0    2016-07-27 [1] CRAN (R 4.1.1)
 cli            3.1.0    2021-10-27 [1] CRAN (R 4.1.1)
 colorspace   * 2.0-2    2021-06-24 [1] CRAN (R 4.1.1)
 corrplot     * 0.92     2021-11-18 [1] CRAN (R 4.1.2)
 crayon         1.4.2    2021-10-29 [1] CRAN (R 4.1.1)
 DBI            1.1.1    2021-01-15 [1] CRAN (R 4.1.1)
 dbplyr         2.1.1    2021-04-06 [1] CRAN (R 4.1.1)
 desc           1.4.0    2021-09-28 [1] CRAN (R 4.1.2)
 devtools       2.4.3    2021-11-30 [1] CRAN (R 4.1.2)
 digest         0.6.29   2021-12-01 [1] CRAN (R 4.1.2)
 dplyr        * 1.0.7    2021-06-18 [1] CRAN (R 4.1.2)
 drake        * 7.13.3   2021-09-21 [1] CRAN (R 4.1.2)
 ellipsis       0.3.2    2021-04-29 [1] CRAN (R 4.1.1)
 evaluate       0.14     2019-05-28 [1] CRAN (R 4.1.1)
 extrafont    * 0.17     2014-12-08 [1] CRAN (R 4.1.1)
 extrafontdb    1.0      2012-06-11 [1] CRAN (R 4.1.1)
 fansi          0.5.0    2021-05-25 [1] CRAN (R 4.1.1)
 fastmap        1.1.0    2021-01-25 [1] CRAN (R 4.1.1)
 filelock       1.0.2    2018-10-05 [1] CRAN (R 4.1.2)
 forcats      * 0.5.1    2021-01-27 [1] CRAN (R 4.1.1)
 fs             1.5.2    2021-12-08 [1] CRAN (R 4.1.2)
 fuzzyjoin    * 0.1.6    2020-05-15 [1] CRAN (R 4.1.2)
 gdtools        0.2.3    2021-01-06 [1] CRAN (R 4.1.1)
 generics       0.1.1    2021-10-25 [1] CRAN (R 4.1.1)
 ggalt        * 0.4.0    2017-02-15 [1] CRAN (R 4.1.2)
 ggplot2      * 3.3.5    2021-06-25 [1] CRAN (R 4.1.1)
 glue           1.5.1    2021-11-30 [1] CRAN (R 4.1.2)
 gtable         0.3.0    2019-03-25 [1] CRAN (R 4.1.1)
 haven          2.4.3    2021-08-04 [1] CRAN (R 4.1.1)
 hms            1.1.1    2021-09-26 [1] CRAN (R 4.1.1)
 hrbrthemes   * 0.8.0    2020-03-06 [1] CRAN (R 4.1.1)
 htmltools      0.5.2    2021-08-25 [1] CRAN (R 4.1.1)
 httr           1.4.2    2020-07-20 [1] CRAN (R 4.1.1)
 igraph         1.2.9    2021-11-23 [1] CRAN (R 4.1.2)
 jsonlite       1.7.2    2020-12-09 [1] CRAN (R 4.1.1)
 KernSmooth     2.23-20  2021-05-03 [2] CRAN (R 4.1.2)
 knitr          1.36     2021-09-29 [1] CRAN (R 4.1.1)
 lattice        0.20-45  2021-09-22 [2] CRAN (R 4.1.2)
 lifecycle      1.0.1    2021-09-24 [1] CRAN (R 4.1.1)
 lubridate      1.8.0    2021-10-07 [1] CRAN (R 4.1.1)
 magrittr       2.0.1    2020-11-17 [1] CRAN (R 4.1.1)
 maps           3.4.0    2021-09-25 [1] CRAN (R 4.1.2)
 MASS           7.3-54   2021-05-03 [2] CRAN (R 4.1.2)
 memoise        2.0.1    2021-11-26 [1] CRAN (R 4.1.2)
 mnormt         2.0.2    2020-09-01 [1] CRAN (R 4.1.1)
 modelr         0.1.8    2020-05-19 [1] CRAN (R 4.1.1)
 munsell        0.5.0    2018-06-12 [1] CRAN (R 4.1.1)
 nlme           3.1-153  2021-09-07 [2] CRAN (R 4.1.2)
 patchwork    * 1.1.1    2020-12-17 [1] CRAN (R 4.1.1)
 pillar         1.6.4    2021-10-18 [1] CRAN (R 4.1.1)
 pkgbuild       1.3.0    2021-12-09 [1] CRAN (R 4.1.2)
 pkgconfig      2.0.3    2019-09-22 [1] CRAN (R 4.1.1)
 pkgload        1.2.4    2021-11-30 [1] CRAN (R 4.1.2)
 prettyunits    1.1.1    2020-01-24 [1] CRAN (R 4.1.1)
 processx       3.5.2    2021-04-30 [1] CRAN (R 4.1.1)
 progress       1.2.2    2019-05-16 [1] CRAN (R 4.1.1)
 proj4          1.0-10.1 2021-01-26 [1] CRAN (R 4.1.1)
 prompt         1.0.1    2021-03-12 [1] CRAN (R 4.1.1)
 ps             1.6.0    2021-02-28 [1] CRAN (R 4.1.1)
 psych        * 2.1.9    2021-09-22 [1] CRAN (R 4.1.2)
 purrr        * 0.3.4    2020-04-17 [1] CRAN (R 4.1.1)
 R6             2.5.1    2021-08-19 [1] CRAN (R 4.1.1)
 RColorBrewer   1.1-2    2014-12-07 [1] CRAN (R 4.1.1)
 Rcpp           1.0.7    2021-07-07 [1] CRAN (R 4.1.1)
 readr        * 2.1.1    2021-11-30 [1] CRAN (R 4.1.2)
 readxl         1.3.1    2019-03-13 [1] CRAN (R 4.1.1)
 remotes        2.4.2    2021-11-30 [1] CRAN (R 4.1.2)
 reprex         2.0.1    2021-08-05 [1] CRAN (R 4.1.1)
 rlang          0.4.12   2021-10-18 [1] CRAN (R 4.1.1)
 rmarkdown      2.11     2021-09-14 [1] CRAN (R 4.1.1)
 rprojroot      2.0.2    2020-11-15 [1] CRAN (R 4.1.2)
 rstudioapi     0.13     2020-11-12 [1] CRAN (R 4.1.1)
 Rttf2pt1       1.3.9    2021-07-22 [1] CRAN (R 4.1.1)
 rvest          1.0.2    2021-10-16 [1] CRAN (R 4.1.1)
 scales         1.1.1    2020-05-11 [1] CRAN (R 4.1.1)
 sessioninfo    1.2.2    2021-12-06 [1] CRAN (R 4.1.2)
 stargazer    * 5.2.2    2018-05-30 [1] CRAN (R 4.1.1)
 storr          1.2.5    2020-12-01 [1] CRAN (R 4.1.2)
 stringi        1.7.6    2021-11-29 [1] CRAN (R 4.1.2)
 stringr      * 1.4.0    2019-02-10 [1] CRAN (R 4.1.1)
 systemfonts    1.0.3    2021-10-13 [1] CRAN (R 4.1.1)
 testthat       3.1.1    2021-12-03 [1] CRAN (R 4.1.2)
 tibble       * 3.1.6    2021-11-07 [1] CRAN (R 4.1.2)
 tidyr        * 1.1.4    2021-09-27 [1] CRAN (R 4.1.1)
 tidyselect     1.1.1    2021-04-30 [1] CRAN (R 4.1.1)
 tidyverse    * 1.3.1    2021-04-15 [1] CRAN (R 4.1.1)
 tmvnsim        1.0-2    2016-12-15 [1] CRAN (R 4.1.1)
 txtq           0.2.4    2021-03-27 [1] CRAN (R 4.1.2)
 tzdb           0.2.0    2021-10-27 [1] CRAN (R 4.1.1)
 usethis        2.1.5    2021-12-09 [1] CRAN (R 4.1.2)
 utf8           1.2.2    2021-07-24 [1] CRAN (R 4.1.1)
 vctrs          0.3.8    2021-04-29 [1] CRAN (R 4.1.1)
 withr          2.4.3    2021-11-30 [1] CRAN (R 4.1.2)
 xfun           0.28     2021-11-04 [1] CRAN (R 4.1.2)
 xml2           1.3.3    2021-11-30 [1] CRAN (R 4.1.2)
```
