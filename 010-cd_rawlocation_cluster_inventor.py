# encoding=utf8  
import csv

keysFile="/Users/aiyenggar/OneDrive/stata/qgis/all_locationid_cluster.csv"
searchFile="/Users/aiyenggar/OneDrive/stata/qgis/rawlocation.tsv"
outputFile="/Users/aiyenggar/OneDrive/stata/qgis/cd_rawlocation_cluster_inventor.csv"

regions = ["Bangalore", "Israel", "Beijing", "Silicon Valley", "Austin", "Boston"]

keysDict = {}
with open(keysFile) as keysf:
    reader = csv.reader(keysf)
    for row in reader:
        if reader.line_num == 1:
            continue
        if (row[1] in regions):
            keysDict[row[0]] = row[1]
    keysf.close()

searchf = open(searchFile, 'r', encoding='iso-8859-1')
outputf = open(outputFile, 'w', encoding='utf-8')

reader = csv.reader(searchf, delimiter='\t')
writer = csv.writer(outputf)

for row in reader:
    if reader.line_num == 1:
        row[0] = "rawlocation_id"
        row.append("cluster")
        writer.writerow(row)
        continue
    if row[1] in keysDict:
        row.append(keysDict[row[1]])
        writer.writerow(row)

outputf.close()
searchf.close()

        