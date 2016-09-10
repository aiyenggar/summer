# encoding=utf8  
import csv
sufList = ["BLR", "BEI", "ISR", "AUS", "BOS", "SIV"]
csvSuffix = ".csv"

searchFile="/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee_rawlocation_cluster.csv"
outputFilePrefix="/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee_rawlocation_cluster_"
keysFilePrefix="/Users/aiyenggar/OneDrive/stata/qgis/cgcd_uspatentcitation_"

for suffix in sufList:
    keysFile = keysFilePrefix + suffix + csvSuffix
    outputFile = outputFilePrefix + suffix + csvSuffix
    keysDict = {}
    with open(keysFile, 'r', encoding='utf-8') as keysf:
        reader = csv.reader(keysf)
        for row in reader:
            if reader.line_num == 1:
                continue
            if (row[1] not in keysDict):
                keysDict[row[1]] = 1
            else:
                keysDict[row[1]] += 1
        keysf.close()
    
    print("Size of keysFile is " + str(len(keysDict)))
    
    searchf = open(searchFile, 'r', encoding='utf-8')
    reader = csv.reader(searchf)
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

