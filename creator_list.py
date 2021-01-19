import json
from os import readlink, write
from collections import Counter

alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', \
'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

def clean_data(dict, attribute):
    "Returns the correct value for the attribute from the dictionary"
    value = dict.get(f'ontology/{attribute}_label')
    if (value != None):
        if (',' in str(value)):
            value = str(value).replace('[', '').replace(']', '').replace("'", '').replace('"', '').replace(',', ' and')
    elif (dict.get(f'ontology/{attribute}') != None):
        value = dict.get(f'ontology/{attribute}')
        if (',' in str(value)):
            value = str(value).removeprefix('http://dbpedia.org/resource/').replace('[', '').replace(']', '').replace("'", '').replace('"', '').replace(',', ' and')
    else:
        value = 'NA'
    return value


# ---FICTIONAL CHARACTER LOOP---

# creator_list = []
# for i in range(26):
#     with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
#         people = json.load(json_file)
#         for person in people:
#             if 'fiction' in str(person['http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label']):
#                 name = person.get('ontology/creator')
#                 if (name != None):
#                     name = str(name)
#                     if ('[' in name):
#                         name = name.replace('[', '').replace(']', '').replace('"', '').replace("'", '').replace('http://dbpedia.org/resource/', '').replace(' ', '')
#                         creator_list.append(name)
#                     else:
#                         name = name.removeprefix('http://dbpedia.org/resource/').replace(' ', '')
#                         creator_list.append(name)

# with open('creators.txt', 'w', encoding = 'utf-8') as creator_txt:
#     creator_txt.write(','.join(creator_list))
    

# ---AUTHORS LOOP---

with open('creators.txt', encoding = 'utf-8') as creator_txt:
    creator_txt = creator_txt.read().split(',')
    creator_set = set(creator_txt)
    creator_counter = Counter(creator_txt)
    with open('creator_data.csv', 'w', encoding = 'utf-8') as csv_output:
        # title gender birthDate birthYear deathDate deathYear ethnicity nationality country region religion 
        # activeYearsStartYear genre notableWork almaMater 
        csv_output.write('Title, Number_of_characters, Gender, birthDate, birthYear, ' +
            'deathDate, deathYear, ethnicity, nationality, country, region, religion, ' +
            'activeYearsStartYear, genre, notableWork, almaMater \n')
        for i in range(26):
                with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
                    people = json.load(json_file)
                    for person in people:
                        if (person['title'] in creator_set):
                            number_of_characters = creator_counter[person['title']]
                            csv_output.write(f"{person['title'].replace('_', ' ')}, {number_of_characters}, " + 
                                f"{clean_data(person, 'gender')}, {clean_data(person, 'birthDate')}, {clean_data(person, 'birthYear')}, " +
                                f"{clean_data(person, 'deathDate')}, {clean_data(person, 'deathYear')}, {clean_data(person, 'ethnicity')}, " +
                                f"{clean_data(person, 'nationality')}, {clean_data(person, 'country')}, {clean_data(person, 'region')}, " +
                                f"{clean_data(person, 'religion')}, {clean_data(person, 'activeYearsStartYear')}, {clean_data(person, 'genre')}, " +
                                f"{clean_data(person, 'notableWork')}, {clean_data(person, 'almaMater')}\n")
                            #print(person['title'])
                            