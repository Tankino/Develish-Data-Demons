import json

alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', \
'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

with open('fictional_characters.csv', 'w', encoding = 'utf-8') as csv_file:
    with open('data_headers.txt') as data_headers:
                for line in data_headers:
                    line = line.strip()
                    csv_file.write(line + ',')
    for i in range(26):
        with open(f'../People/{alphabet[i]}_people.json', encoding = 'utf-8') as json_file:
            people = json.load(json_file)
            for person in people:
                if 'fiction' in str(person['http://www.w3.org/1999/02/22-rdf-syntax-ns#type_label']):
                    print(person["title"])
                    csv_file.write(f'{person["title"]}\n')