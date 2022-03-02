source("R/packages.R")
source("R/fonts.R")
source("R/functions.R")
source("R/correspondence_analysis.R")
source("R/plan.R")

# options(clustermq.scheduler = "multicore") # optional parallel computing

conf <- drake_config(plan, verbose = 2, lock_envir = FALSE)
