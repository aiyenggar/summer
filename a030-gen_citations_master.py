# -*- coding: utf-8 -*-
"""
Created on Fri Dec  9 05:48:51 2016

@author: aiyenggar
"""

import csv

#patent_id,inventor_id,region
keysFile="/Users/aiyenggar/datafiles/patents/rawinventor_region.csv"
#cit_uuid,cg_patent_id,ct_patent_id,year,cg_assignee_id,cg_assignee_region,ct_assignee_id,ct_assignee_region,cg_inventor_id,cg_inventor_region
searchFile="/Users/aiyenggar/datafiles/patents/uspc.appl.year.ass.cg_inventor_region.csv"
#cit_uuid,cg_patent_id,ct_patent_id,year,cg_assignee_id,cg_assignee_region,ct_assignee_id,ct_assignee_region,cg_inventor_id,cg_inventor_region,ct_inventor_id,ct_inventor_region
outputFile="/Users/aiyenggar/datafiles/patents/uspc.appl.year.ass.inv.region.csv"

keysf = open(keysFile, 'r', encoding='utf-8')
kreader = csv.reader(keysf)

# Read the entire keysFile to memory
kheader=list(["ct_inventor_id","ct_inventor_region"])
kDict=dict({})
for row in kreader:
    if kreader.line_num == 1:
        continue
    if (row[0] not in kDict):
        kDict[row[0]] = list([])
    kDict[row[0]].append([row[1],row[2]])
    if kreader.line_num % 1000000 == 0:
        print("Read " + str(kreader.line_num) + " patent inventor locations")
print("done reading to memory")

searchf = open(searchFile, 'r', encoding='utf-8')
sreader = csv.reader(searchf)
outputf = open(outputFile, 'w', encoding='utf-8')
writer = csv.writer(outputf)

for row in sreader:
   if sreader.line_num == 1:
       writer.writerow(row+kheader)
       continue
   if (row[2] in kDict): 
       mapped_list = kDict[row[2]] #be careful, we are mapping on ct_patent_id
       if (len(mapped_list) == 0):
           writer.writerow(row+['',''])
       for next_entry in mapped_list:
           writer.writerow(row+next_entry)
   else:
        writer.writerow(row+['',''])
   if sreader.line_num % 1000000 == 0:
        print("Processed " + str(sreader.line_num) + " lines")

outputf.close()
searchf.close()
