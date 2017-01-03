# -*- coding: utf-8 -*-
"""
Created on Fri Dec  9 05:48:51 2016

@author: aiyenggar
"""

import csv

#cit_uuid,cg_patent_id,ct_patent_id,year,cg_assignee_id,cg_assignee_region,ct_assignee_id,ct_assignee_region,cg_inventor_id,cg_inventor_region,ct_inventor_id,ct_inventor_region
keysFile="/Users/aiyenggar/datafiles/patents/uspc.appl.year.ass.inv.region.csv"

#cg_patent_id,ct_patent_id,year,cg_inventor_region,ct_inventor_region,ass_sim,loc_sim
outputFile="/Users/aiyenggar/datafiles/patents/uspc.appl.sim.inv_region.csv"

keysf = open(keysFile, 'r', encoding='utf-8')
kreader = csv.reader(keysf)

outputf = open(outputFile, 'w', encoding='utf-8')
writer = csv.writer(outputf)

# Read the entire keysFile to memory
oheader=list([])

for row in kreader:
    if kreader.line_num == 1:
        oheader.append(row[1])
        oheader.append(row[2])
        oheader.append(row[3])
        oheader.append(row[9])
        oheader.append(row[11])
        oheader.append('ass_sim')
        oheader.append('loc_sim')
        writer.writerow(oheader)
        continue

    ass_sim = 2 # indeterminate by default
    if (len(row[4]) > 0 and len(row[6]) > 0):
        if (row[4] == row[6]):
            ass_sim = 1
        else:
            ass_sim = 0
    loc_sim = 2 # indeterminate by default
    if (len(row[9]) > 0 and len(row[11]) > 0):
        if (row[9] == row[11]):
            loc_sim = 1
        else:
            loc_sim = 0
            
    entry = list([])
    entry.append(row[1])
    entry.append(row[2])
    entry.append(row[3])
    entry.append(row[9])
    entry.append(row[11])
    entry.append(ass_sim)
    entry.append(loc_sim)
    writer.writerow(entry)

    if kreader.line_num % 1000000 == 0:
        print("Read " + str(kreader.line_num) + " citation lines")

outputf.close()
keysf.close()
