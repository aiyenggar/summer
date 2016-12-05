# encoding=utf8  j

# Isn't this file essentially mapping rawlocation_id to region name (or cluster)?
import csv

#location_id,Cluster
keysFile="/Users/aiyenggar/OneDrive/code/qgis/all_locationid_cluster.csv"

#id location_id	 city state	 country lat long
searchFile="/Users/aiyenggar/OneDrive/code/qgis/rawlocation.tsv"

#rawlocation_id,location_id,city,state,country,latlong,cluster
outputFile="/Users/aiyenggar/OneDrive/code/qgis/cd_rawlocation_cluster_inventor.csv"

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

        