import json
from os import readlink, write
from collections import Counter

# List with alphabet to be used in loading the JSON files
alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', \
'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

# ---FUNCTION FOR EXTRACTING A USABLE VALUE---
# Defining a new function that takes a dictionary and a string of a variable name as arguments
# and returns a usable value for that variable

def clean_data(dict, attribute):
    "Returns the correct value for the attribute from the dictionary."
    value = dict.get(f'ontology/{attribute}_label')
    if (value != None): # If there is a label, use it
        if (',' in str(value)): # If a comma appears, it is a list of labels. Replace with 'and' to keep order in CSV file
            value = str(value).replace('[', '').replace(']', '').replace("'", '').replace('"', '').replace(',', ' and')
        # If no comma appears, return the label. 
    elif (dict.get(f'ontology/{attribute}') != None): # If there is no label but a dbpedia link, extract a label from the link
        value = dict.get(f'ontology/{attribute}')
        if (',' in str(value)): # If there is a comma, make it better for CSV
            value = str(value).removeprefix('http://dbpedia.org/resource/').replace('[', '').replace(']', '').replace("'", '').replace('"', '').replace(',', ' and')
        # If there is none, just remove the link
        else:
            value = str(value).removeprefix('http://dbpedia.org/resource/')
    else: # If neither link nor label exist, return NA, readable in R
        value = 'NA'
    return value


# ---FICTIONAL CHARACTER LOOP---
# Go through the JSON files, search for fictional characters, and extract their creator

creator_list = []
for i in range(26): # Loops through the letters of the alphabet
    print(f'Letter {alphabet[i]} of character loop') # Optional: print status
    with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
        people = json.load(json_file)
        for person in people: # For each dictionary in the opened JSON file
            # Check if the type label for the person contains 'fiction', in which case it is a fictional character
            if 'fiction' in str(person['http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label']):
                # Almost the same as the clean_data function, but adapted to making a list of all names of creators
                # The list includes multiples
                name = person.get('ontology/creator')
                if (name != None):
                    name = str(name)
                    if (',' in name): # If there is a comma, add each of the multiple creators
                        name = name.replace('[', '').replace(']', '').replace('"', '').replace("'", '').replace('http://dbpedia.org/resource/', '').replace(' ', '').split(',')
                        creator_list.extend(name) # Extend the list of creators by the ones found
                    else: # Otherwise, just remove the link
                        name = name.removeprefix('http://dbpedia.org/resource/').replace(' ', '')
                        creator_list.append(name) # Append the creator found to the list
            # Ignore all other (natural) persons

# ---EXPORTING LIST---
# Export the list of creators to a TXT file
# This allows the commenting out of the fictional character loop after changes to only the creators loop

with open('creators.txt', 'w', encoding = 'utf-8') as creator_txt:
    creator_txt.write(','.join(creator_list)) # Make a string from the list, separated by commas and write to TXT file
    

# ---CREATORS LOOP---
# Go through the CSV files once more and extract the information on creators to a CSV file

with open('creators.txt', encoding = 'utf-8') as creator_txt:
    creator_txt = creator_txt.read().split(',') # Change to a creator list
    creator_set = set(creator_txt) # Make a set from the creator list
    creator_counter = Counter(creator_txt) # Make a counter from the creator list
    #print(len(creator_set)) # Optionally print the total number of creators
    with open('creator_data.csv', 'w', encoding = 'utf-8') as csv_output:
        # List of variables in the CSV:
        # title number_of_characters description gender birthDate birthYear deathDate deathYear ethnicity nationality 
        # country region religion activeYearsStartYear genre notableWork almaMater 
        csv_output.write('Title, Number_of_characters, Description, Gender, birthDate, birthYear, ' +
            'deathDate, deathYear, ethnicity, nationality, country, region, religion, ' +
            'activeYearsStartYear, genre, notableWork, almaMater \n') # Write the headers in the CSV
        for i in range(26): # Go through the alphabet and the corresponding JSON files again
            print(f'Letter {alphabet[i]} of creator loop') # Optional: print status
            with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
                people = json.load(json_file)
                for person in people: # For each dictionary in the opened JSON file
                    if (person['title'] in creator_set): # If their title is in the set of creators
                        number_of_characters = creator_counter[person['title']] # Count the number of characters (co)created
                        if (person.get('http://purl.org/dc/elements/1.1/description') != None): # Add description
                            description = person.get('http://purl.org/dc/elements/1.1/description')
                        else: # Or NA (the clean_data function doesn't work here, variable name format is different)
                            description = 'NA'
                        # Write into each line all variables, using the clean_data function
                        csv_output.write(f"{person['title'].replace('_', ' ')}, {number_of_characters}, {description}, " + 
                            f"{clean_data(person, 'gender')}, {clean_data(person, 'birthDate')}, {clean_data(person, 'birthYear')}, " +
                            f"{clean_data(person, 'deathDate')}, {clean_data(person, 'deathYear')}, {clean_data(person, 'ethnicity')}, " +
                            f"{clean_data(person, 'nationality')}, {clean_data(person, 'country')}, {clean_data(person, 'region')}, " +
                            f"{clean_data(person, 'religion')}, {clean_data(person, 'activeYearsStartYear')}, {clean_data(person, 'genre')}, " +
                            f"{clean_data(person, 'notableWork')}, {clean_data(person, 'almaMater')}\n")
                    # Ignore those that aren't in the set of creators
                            