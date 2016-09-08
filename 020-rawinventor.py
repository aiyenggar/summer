# encoding=utf8  
import csv

keysFile="/Users/aiyenggar/OneDrive/stata/qgis/rawlocation_defined_clusters.csv"
searchFile="/Users/aiyenggar/OneDrive/stata/qgis/rawinventor.tsv"
outputFile="/Users/aiyenggar/OneDrive/stata/qgis/rawinventor_defined_clusters.csv"

keysDict = {}
with open(keysFile, 'r', encoding='iso-8859-1') as keysf:
    reader = csv.reader(keysf)
    for row in reader:
        if reader.line_num == 1:
            continue
        keysDict[row[0]] = 1
    keysf.close()

print("Size of keysFile is " + str(len(keysDict)))

searchf = open(searchFile, 'r', encoding='iso-8859-1')
outputf = open(outputFile, 'w', encoding='utf-8')

reader = csv.reader(searchf, delimiter='\t')
writer = csv.writer(outputf)

for row in reader:
    if reader.line_num == 1:
        writer.writerow(row)
        continue
    if row[3] in keysDict:
        writer.writerow(row)

outputf.close()
searchf.close()

        