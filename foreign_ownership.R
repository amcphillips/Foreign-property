install.packages("tidyverse")
install.packages("janitor")
install.packages("usethis")

library(tidyverse)
library(janitor)
library(usethis)
library(sf)

# Import raw data

raw_data <- read_csv("E:/R data/OCOD_FULL_2024_02.csv")

# Clean column titles
raw_data <- raw_data |>
  clean_names()

# Extract only the relevant variables
core <- raw_data |>
  select(title_number, property_address, district, region, postcode, price_paid, country_incorporated_1)
 
# Create geographic summary  
geog_sum <- core |>
  group_by(region, district) |> 
  summarise(n = sum(n()))



# Only include those with a price paid entry which should only be residential properties
price <- core |>
  drop_na(price_paid)
  
    
price_sum <- price |>
  group_by(region) |> 
  summarise_each(funs(sum, max, min, mean, median), price_paid)
  #summarise(n = sum(n()))
  
write.csv(geog_sum, file = "E:/R data/geog_sum.csv",row.names=FALSE)
write.csv(price_sum, file = "E:/R data/price_sum.csv",row.names=FALSE) 




