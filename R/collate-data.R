library(tidyverse)
library(googlesheets4)
library(googledrive)

files <- drive_find(type = "spreadsheet", pattern = "PoliciesAnalysis")

# do not include Russia, spurious old portugal file and duplicated Brazil file
files_clean <- files %>%
  filter(!str_detect(name, "_old|\\(1|Russia"),
         !str_detect(name, "translated"))

sheet_ids <- files_clean %>%
  # filter(str_detect(name, "USA")) %>%
  pull(id)

translated_files <- files %>%
  filter(str_detect(name, "translated"))

translated_ids <- translated_files %>% pull(id)


get_gs_data <- function(sheet_id, only_r2 = FALSE,
                        out_dir = "data/raw/individual_files/") {

  # first get all relevant sheet names
  # we need an elaborate approach, since there are now revisions
  # Revisions are marked as "R2_Copy of {original sheet name}"
  # Therefore we find the names with revisions and keep the ones with "R2"
  find_correct_sheets <- function(sheet_id, only_r2) {
    all_sheets <- sheet_names(sheet_id)

    sheets <- tibble(sheet_name = all_sheets) %>%
      filter(str_detect(sheet_name, "_\\d")) %>%
      mutate(policy_name = str_extract(sheet_name, "[A-Z]{2}_.*")) %>%
      group_by(policy_name) %>%
      mutate(correct_sheet = case_when(
        n() == 1 ~ TRUE,
        n() > 1 & str_detect(sheet_name, "^R2") ~ TRUE,
        TRUE ~ FALSE)) %>%
      filter(correct_sheet) %>%
      pull(sheet_name) %>%
      set_names(.)

    if (only_r2) {
      sheets %>%
        keep(str_detect, "^R2")
    } else {
      sheets
    }
  }


  relevant_sheets <- find_correct_sheets(sheet_id, only_r2)

  read_individual_sheet <- function(sheet, sheet_id) {
    the_sheet <- read_sheet(sheet = sheet, ss = sheet_id, col_types = "c")

    sheet_sane <- str_extract_all(sheet, "[:alpha:]|[:alnum:]|_") %>%
      map_chr(paste, collapse = "")

    write_csv(the_sheet,
              paste0(out_dir, sheet_sane, ".csv"))
    Sys.sleep(8)
  }

  relevant_sheets %>%
    walk(~read_individual_sheet(sheet = .x, sheet_id = sheet_id))


  sleep <- 10
  print(glue::glue("Sleeping for {sleep} seconds."))

  Sys.sleep(sleep)
}

# initial data collation
# map over all input sheets
sheet_ids %>%
  walk(get_gs_data, only_r2 = FALSE)

# start collating and cleaning the data
all_policies <- list.files("data/raw/individual_files/", full.names = TRUE) %>%
  set_names(str_extract(., "[A-Z]{2,3}_\\d.*?(?=\\.csv)")) %>%
  map_dfr(read_csv, .id = "policy", col_type = cols(.default = col_character()))


# find indicator metadata
indicator_metadata <- all_policies %>%
  distinct(Group, Code) %>%
  mutate(Group = case_when(
    str_detect(Code, "Are the following") ~ "None",
    str_detect(Code, "GE9") ~ "Other",
    TRUE ~ Group
  )) %>%
  drop_na()

fixed_metadata <- all_policies %>%
  select(-Group) %>%
  left_join(indicator_metadata) %>%
  select(policy, Group, Code, everything())

fixed_overall <- fixed_metadata %>%
  select(-Instructions) %>%
  filter(Group != "None") %>%
  rename(quant_indicator = Answer1, qual_answer = Answer2) %>%
  mutate(Comment = coalesce(Comment, `...8`, `...7`)) %>%
  select(-c(`...8`, `...7`)) %>%
  arrange(policy)

write_csv(fixed_overall, "data/transformed/policies_collated_cleaned.csv")


# repeat process for translated sheets ----
# map over translation files
translated_ids %>%
  walk(get_gs_data, out_dir = "data/raw/translated_snippets/")

# start collating and cleaning the data
translated_policies <- list.files("data/raw/translated_snippets/", full.names = TRUE) %>%
  set_names(str_extract(., "[A-Z]{2,3}_\\d.*?(?=\\.csv)")) %>%
  map_dfr(read_csv, .id = "policy", col_type = cols(.default = col_character()))

# check that everything is translated
translated_policies %>%
  select(policy, Group, Answer2, Translation) %>%
  filter(!str_detect(Answer2, "CopyPasteSnippet") | is.na(Answer2),
         !is.na(Answer2)) %>%
  filter(is.na(Translation))
# fixed a few missing translations upstream

translated_policies <- translated_policies %>%
  select(c("policy", "Code", "Question", "Translation"))

with_translation <- fixed_overall %>%
  left_join(translated_policies) %>%
  select(policy, Group, Code, Question, quant_indicator, qual_answer,
         Translation, Answer3, Comment)

write_csv(with_translation,
          "data/transformed/policies_collated_cleaned_translated.csv")


# get metadata -----
meta_file <- drive_find(type = "spreadsheet",
                        pattern = "CareerPromotionPoliciesDataset")

countries <- c("Austria", "Brazil", "Germany", "India", "Portugal", "UK", "USA")

get_metadata <- function(country, meta_file) {
  read_sheet(meta_file, sheet = country) %>%
    select(uni_id = `Uni id`, uni_name = `Uni name`,
           Status, Level, file = `Policy saved file`) %>%
    drop_na(file) %>%
    distinct(uni_id, uni_name, Status, Level) %>%
    separate(uni_id, into = c("country", "university"),
             sep = "_") %>%
    mutate(university = str_remove(university, "[:alpha:]")) %>%
    distinct(country, university, uni_name, Status, Level)
}

meta_result <- countries %>%
  map_dfr(~get_metadata(.x, meta_file)) %>%
  mutate(university = as.numeric(university)) %>%
  arrange(country, university)

meta_result_fixed <- meta_result %>%
  filter(!country == "XXX")

meta_result_fixed %>%
  rename(status = Status, level = Level) %>%
  write_csv("data/transformed/metadata.csv")


# integrate revised data -----
# While searching for examples, we discovered issues with the indicator
# "NumPublications", since it was conceived too broadly. We narrowed the scope
# of the indicator, checked all codings towards it, and rechecked documents
# where we removed to coding, to make sure we did not miss other true occurrences
# in the same document.
#
# During this process, we also found a few minor issues (e.g., missing snippets,
# missing codes for an indicator), which we fixed.
#
# specifically, we discovered the following missing indicators, and fixed them:
# DE 5 pub quality
# USA 32 gender balance reviewers
# de 4 peer review
# GB 5 peer review
# usa 26 pastoral work

# furthermore, removed the OA coding since it was applied incorrectly
# other small fixes of codings where applied via the column "indicator_new",
# besides the recoding of "NumPublications"
#
# below, we integrate this recoded data to establish a unified source
library(tidylog)
recoded_id <- drive_get(id = "1rMrR6rtq0hbZHhdLifz_rdZubDWTi1yv_y50k3YHD9I")
recoded_id

recoded_sheet <- read_sheet(recoded_id,
                            sheet = "policies_collated_cleaned_translated",
                            na = c("", "NA"),
                            col_types = "c")

# check: all new codings should have snippet and translation
recoded_sheet %>%
  filter(indicator_new == 1) %>%
  select(policy, Code, snippet_new, translation_new)
# looks good

expanded <- recoded_sheet %>%
  mutate(indicator_final = coalesce(indicator_new, quant_indicator),
         snippet_final = coalesce(snippet_new, qual_answer),
         translation_new = coalesce(translation_new, Translation),
         english_version = coalesce(translation_new, snippet_final))
# some snippets are carried over although indicator is negative -> purge them

purged <- expanded %>%
  mutate(snippet_final = case_when(indicator_new == 0 ~ NA_character_,
                                   is.na(indicator_new) ~ snippet_final,
                                   TRUE ~ snippet_final),
         english_version = case_when(indicator_new == 0 ~ NA_character_,
                                     is.na(indicator_new) ~ english_version,
                                     TRUE ~ english_version))


# further sanity checks:
# 0. there should be no missing indicators
purged %>%
  filter(is.na(indicator_final)) %>%
  count(Code)
# these are only related to metadata, so this is not ideal, but ok

# 1. if indicator is 1, should have snippet
purged %>%
  filter(indicator_final == 1 & is.na(snippet_final)) %>% View()
# four cases with gender, where the higher valued gender indicator was found,
# so snippet was not added to save time

# 2. if indicator is 0, should have no snippet
purged %>%
  filter(indicator_final == 0 & !is.na(snippet_final),
         indicator_new != 0 | is.na(indicator_new)) %>% View()
# four cases with snippets on purpose (add context, but don't change coding)

selected <- purged %>%
  select(policy, Group, Code, Question, quant_indicator = indicator_final,
         qual_answer = snippet_final, english_version,
         Answer3, `Comment on coding`)

# remove general impact since it is nebulous and was not applied consistently by
# all coders
selected <- selected %>%
  filter(Code != "Impact")

write_csv(selected, "data/transformed/policies_collated_cleaned_translated_recoded.csv")
