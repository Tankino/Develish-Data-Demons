import json

alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', \
'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

with open('fictional_characters.csv', 'w', encoding = 'utf-8') as csv_file:
    with open('data_headers.txt') as data_headers:
        csv_file.write('title, ontology/gender_label, ontology/gender, ontology/species_label, ontology/species, ontology/birthDate, ontology/birthYear, ontology/deathDate, ontology/deathYear, \
            ontology/deathCause_label, ontology/deathCause, ontology/ethnicity_label, ontology/ethnicity, ontology/religion _label, ontology/religion \
            ontology/nationality_label,ontology/nationality, ontology/country_label, ontology/country \
            ontology/region_label, ontology/region, ontology/creator_label, ontology/creator')
    for i in range(26):
        with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
            people = json.load(json_file)
            for person in people:
                if 'fiction' in str(person['http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label']):
                    csv_file.write(f"{person['title']}, {person.get('ontology/gender_label')}, {person.get('ontology/gender')}, {person.get('ontology/species_label')}, {person.get('ontology/species')}, {person.get('ontology/birthDate')}, {person.get('ontology/birthYear')}, {person.get('ontology/deathDate')}, {person.get('ontology/deathYear')}, {person.get('ontology/deathCause_label')}, {person.get('ontology/deathCause')}, {person.get('ontology/ethnicity_label')}, {person.get('ontology/ethnicity')}, {person.get('ontology/religion _label')}, {person.get('ontology/religion')}, {person.get('ontology/nationality_label')}, {person.get('ontology/nationality')}, {person.get('ontology/country_label')}, {person.get('ontology/country')}, {person.get('ontology/region_label')}, {person.get('ontology/region')}, {person.get('ontology/creator_label')}, {person.get('ontology/creator')} \n")