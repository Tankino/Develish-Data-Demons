# ---BIRTHYEAR EXTRACTION---
# Extracts the birthyear from the birthdate and copies it into the birthyear column
# if the latter is empty or has a different birthyear
# In CSV: birthDate is position 4, birthYear is position 5

with open('creator_data.csv', encoding = 'utf-8') as creator_input:
    with open('creator_data_cleaned.csv', 'w', encoding = 'utf-8') as creator_output:
        creator_output.write(creator_input.readline()) # Copy the headers to the new CSV file
        for line in creator_input:
            a_creator = str(line).split(',') # Transform each line into a list
            birthyear_fromdate = a_creator[4].split('-')[0].strip() # Split the birthdate into a list and use the year
            if ((birthyear_fromdate != 'NA') and (birthyear_fromdate != a_creator[5])): # If found birthyear is empty or different
                a_creator[5] = ' ' + birthyear_fromdate # Assign the birthyear column the new birthyear
            creator_output.write(','.join(a_creator)) # Write the whole list into one line of the new CSV
            