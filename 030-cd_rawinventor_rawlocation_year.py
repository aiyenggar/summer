# encoding=utf8  
import csv
import datetime

def getDate(dateString):
    sp=dateString.split('-')
    return datetime.date(int(sp[0]),int(sp[1]),int(sp[2]))
    
keysFile="/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawlocation_cluster.csv"
searchFile="/Users/aiyenggar/OneDrive/stata/qgis/patent.tsv"
outputFile="/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawlocation_cluster_year.csv"

default_date = getDate("1947-08-15")

keysDict = {}
with open(keysFile, 'r', encoding='utf-8') as keysf:
    reader = csv.reader(keysf)
    for row in reader:
        if reader.line_num == 1:
            continue
        if (row[1] not in keysDict):
            keysDict[row[1]] = default_date
    keysf.close()

print("Size of keysFile is " + str(len(keysDict)))

searchf = open(searchFile, 'r', encoding='iso-8859-1')
reader = csv.reader(searchf, delimiter='\t')

for row in reader:
    if reader.line_num == 1:
        continue
    if row[2] in keysDict:
        newDate = getDate(row[4])
        if ((keysDict[row[2]] == default_date) or (keysDict[row[2]] == newDate)):
            if newDate.year == 9177:
                newDate = newDate.replace(year=1977)
            keysDict[row[2]]=newDate
        else:
            print(row[2] + " has multiple dates. Prior " + keysDict[row[2]] + " Now " + newDate)
searchf.close()

keysf = open(keysFile, 'r', encoding='utf-8')
reader = csv.reader(keysf)
outputf = open(outputFile, 'w', encoding='utf-8')
writer = csv.writer(outputf)
for row in reader:
    if reader.line_num == 1:
        row.append("year")
        row.append("date")
        writer.writerow(row)
        continue
    row.append(keysDict[row[1]].year)
    row.append(keysDict[row[1]])
    writer.writerow(row)

keysf.close()
outputf.close()