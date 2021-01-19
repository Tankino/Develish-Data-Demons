import json

alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', \
'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

def clean_data(dict, attribute):
    "Returns the correct value for the attribute from the dictionary"
    value = dict.get(f'ontology/{attribute}_label')
    if (value != None):
        if (',' in str(value)):
            value = str(value).replace('[', '').replace(']', '').replace(',', ' and').replace("'", '')
    elif (dict.get(f'ontology/{attribute}') != None):
        value = dict.get(f'ontology/{attribute}')
        if (',' in str(value)):
            value = str(value).removeprefix('http://dbpedia.org/resource/').replace('[', '').replace(']', '').replace(',', ' and').replace("'", '')
    else:
        value = 'NA'
    return value

with open('fictional_characters.csv', 'w', encoding = 'utf-8') as csv_file:
    csv_file.write('title, gender, creator, genre, firstAppearance, species, birthDate, birthYear, deathDate, deathYear, deathCause, ethnicity, religion, nationality, country, region\n')
    for i in range(26):
        with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
            people = json.load(json_file)
            for person in people:
                if 'fiction' in str(person['http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label']):
                    title = person.get('title').replace('_', ' ')
                    gender = clean_data(person, 'gender')
                    creator = clean_data(person, 'creator')
                    genre = clean_data(person, 'genre')
                    firstappearance = clean_data(person, 'firstAppearance')
                    species = clean_data(person, 'species')
                    birthdate = clean_data(person, 'birthDate')
                    birthyear = clean_data(person, 'birthYear')
                    deathdate = clean_data(person, 'deathDate')
                    deathyear = clean_data(person, 'deathYear')
                    deathcause = clean_data(person, 'deathCause')
                    ethnicity = clean_data(person, 'ethnicity')
                    country = clean_data(person, 'country')
                    region = clean_data(person, 'region')
                    print(f'{title}, {gender}, {creator}')
                    csv_file.write(f'{title}, {gender}, {creator}, {genre}, {firstappearance}, {species}, {birthdate}, {birthyear}, {deathdate}, {deathyear}, {deathcause}, {ethnicity}, {country}, {region}\n')
                    #csv_file.write(f"{person['title']}, {person.get('ontology/gender_label')}, {person.get('ontology/gender')}, {person.get('ontology/species_label')}, {person.get('ontology/species')}, {person.get('ontology/birthDate')}, {person.get('ontology/birthYear')}, {person.get('ontology/deathDate')}, {person.get('ontology/deathYear')}, {person.get('ontology/deathCause_label')}, {person.get('ontology/deathCause')}, {person.get('ontology/ethnicity_label')}, {person.get('ontology/ethnicity')}, {person.get('ontology/religion _label')}, {person.get('ontology/religion')}, {person.get('ontology/nationality_label')}, {person.get('ontology/nationality')}, {person.get('ontology/country_label')}, {person.get('ontology/country')}, {person.get('ontology/region_label')}, {person.get('ontology/region')}, {person.get('ontology/creator_label')}, {person.get('ontology/creator')} \n")
    # More code