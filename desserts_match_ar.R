library(tidyverse)
library(here)
library(janitor)
library(rvest)  # use to scrape website content

# Check if that data folder exists and creates it if not
dir.create("data", showWarnings = FALSE)

# Read the webpage code
webpage <- read_html("https://www.eatthis.com/iconic-desserts-united-states/")

# Extract the desserts listing
dessert_elements<- html_elements(webpage, "h2")
dessert_listing <- dessert_elements %>% 
  html_text2() %>%             # extracting the text associated with this type of elements of the webpage
  as_tibble() %>%              # make it a data frame
  rename(dessert = value) %>%  # better name for the column
  head(.,-3) %>%               # 3 last ones were not desserts 
  rowid_to_column("rank") %>%  # adding a column using the row number as proxy for the rank
  write_csv("data/iconic_desserts.csv") # save it as csv

favorite_desserts <- read_csv("favorite_desserts.csv") %>% clean_names()
iconic_desserts <- read_csv(here("data", "iconic_desserts.csv")) %>% clean_names()

iconic_desserts_cleaned <- iconic_desserts %>% 
  mutate(across(where(is.character), tolower))

favorite_desserts_cleaned <- favorite_desserts %>% 
  select(dessert = favorite_dessert, first_name, last_name) %>% 
  mutate(across(where(is.character), tolower))

joined_desserts <- left_join(favorite_desserts_cleaned, iconic_desserts)

fav_desserts_vec <- favorite_desserts_cleaned$dessert

# matched_desserts <- for (i in seq_along(fav_desserts_vec)){
#   str_detect(iconic_desserts_cleaned, pattern = )
#   return(TRUE)
# }

