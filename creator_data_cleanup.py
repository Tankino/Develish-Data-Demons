with open('creator_data.csv', encoding = 'utf-8') as creator_input:
    # in input: birthDate is 4, birthYear is 5
    with open('creator_data_cleaned.csv', 'w', encoding = 'utf-8') as creator_output:
        creator_output.write(creator_input.readline().replace('birthDate', 'doNotUse'))
        for line in creator_input:
            a_creator = str(line).split(',')
            birthyear_fromdate = a_creator[4].split('-')[0].strip()
            if ((birthyear_fromdate != 'NA') and (birthyear_fromdate != a_creator[5])):
                a_creator[5] = ' ' + birthyear_fromdate
            creator_output.write(','.join(a_creator))
            