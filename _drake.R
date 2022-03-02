source("R/01-packages.R")
source("R/fonts.R")
source("R/02-functions.R")
source("R/04-correspondence_analysis.R")
source("R/03-plan.R")

# options(clustermq.scheduler = "multicore") # optional parallel computing

conf <- drake_config(plan, verbose = 2, lock_envir = FALSE)
