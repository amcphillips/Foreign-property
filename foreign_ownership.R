install.packages("tidyverse")
install.packages("janitor")
install.packages("usethis")

library(tidyverse)
library(janitor)
library(usethis)
library(sf)

# Import raw data

raw_data <- read_csv("E:/R data/Foreign property/OCOD_FULL_2024_02.csv")

# Clean column titles
raw_data <- raw_data |>
  clean_names()

# Extract only the relevant variables
core <- raw_data |>
  select(title_number, property_address, district, region, postcode, price_paid, country_incorporated_1)
 
# Create geographic summary  
region <- core |>
  group_by(region) |> 
  summarise(n = sum(n())) |>
  mutate(prop = scales::label_percent()(n / sum(n)))

LA <- core |>
  group_by(district) |> 
  summarise(n = sum(n())) |>
  mutate(prop = scales::label_percent()(n / sum(n)))

source <- core |>
  group_by(country_incorporated_1) |>
  summarise(n = sum(n())) |>
  mutate(prop = scales::label_percent()(n / sum(n)))

# Only include those with a price paid entry which should only be residential properties
price <- core |>
  drop_na(price_paid)
  
    
price_sum <- price |>
  group_by(region) |> 
  summarise_each(funs(sum, max, min, mean, median), price_paid)
  #summarise(n = sum(n()))
  
write.csv(region, file = "E:/R data/Foreign property/region.csv",row.names=FALSE)
write.csv(LA, file = "E:/R data/Foreign property/LA.csv",row.names=FALSE)
write.csv(price_sum, file = "E:/R data/Foreign property/price_sum.csv",row.names=FALSE) 
write.csv(source, file = "E:/R data/Foreign property/source.csv",row.names=FALSE) 



