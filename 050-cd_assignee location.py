# encoding=utf8  
import csv

keysFile="/Users/aiyenggar/OneDrive/stata/qgis/cd_patents.csv"
searchFile="/Users/aiyenggar/OneDrive/stata/qgis/rawassignee.tsv"
outputFile="/Users/aiyenggar/OneDrive/stata/qgis/cd_rawassignee.csv"

keysDict = {}
with open(keysFile, 'r', encoding='utf-8') as keysf:
    reader = csv.reader(keysf)
    for row in reader:
        if reader.line_num == 1:
            continue
        if (row[0] not in keysDict):
            keysDict[row[0]] = 1
        else:
            keysDict[row[0]] += 1
            print("Seeing " + row[0] + " more than once " + str(keysDict[row[0]]))
    keysf.close()

print("Size of keysFile is " + str(len(keysDict)))

searchf = open(searchFile, 'r', encoding='iso-8859-1')
reader = csv.reader(searchf, delimiter='\t')
outputf = open(outputFile, 'w', encoding='utf-8')
writer = csv.writer(outputf)

for row in reader:
    if reader.line_num == 1:
        writer.writerow(row)
        continue
    if row[1] in keysDict:
        writer.writerow(row)

keysf.close()
outputf.close()