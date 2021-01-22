# Develish-Data-Demons
Final assignment UCACCMET2J Annie, Dorian and Cas

creator_data.csv
Cleaned CSV file with all the creators with wikipedia pages of whom at least one character appear on wikipedia, with additional variables.

creator_data_cleaned.csv
Cleaned creator_data file with year of birth indicated for more creators, based on birthDate variable.

creators_with_description.csv
Manually coded creator_data_cleaned. The original descriptions were replaced by categories of medium in which the creator worked: Literature, Cartoon/Comic, Film/TV, Other.

creators.txt
List of the creator's Wikipedia page titles only. Used as a way to store that data and save runtime when making changes to the code.

creator_data_extraction.py
Python script to make creators.txt and creator_data.csv. See comments scripts for details.

creator_data_cleanuo.py
Python script transform creator_data.csv into creator_data_cleaned.csv. See comments in script for details.

exploratory.R
R script for data analysis and creation of the graphs. See comments in script for details.

color_by_medium.R
R script for creating the graph sorted by medium, using the creators_with_description.csv

.pdf files
Contain PDF versions of the graphs used in the presentation and report.
