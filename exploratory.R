setwd("~/Desktop/data_analysis/Final project/Develish-Data-Demons")

library(tidyverse)

people_data <- read_csv("fictional_characters.csv") 
species_data <- count(people_data, species_label)
gender_data <- count(people_data, gender_label)
death_data <- count(people_data, deathYear)
ethnicity_data <- count(people_data, ethnicity_label)
religion_data <- count(people_data, religion)