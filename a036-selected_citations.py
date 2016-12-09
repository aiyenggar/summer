# -*- coding: utf-8 -*-
"""
Created on Fri Dec  9 05:48:51 2016

@author: aiyenggar
"""

import csv

#cg_patent_id,ct_patent_id,year,cg_inventor_region,ct_inventor_region,ass_sim,loc_sim
keysFile="/Users/aiyenggar/OneDrive/PatentsView/uspc.appl.sim.inv_region.csv"

#cg_patent_id,ct_patent_id,year,cg_inventor_region,ct_inventor_region,ass_sim,loc_sim
outputFile="/Users/aiyenggar/OneDrive/PatentsView/selected.uspc.appl.sim.inv_region.csv"

keysf = open(keysFile, 'r', encoding='utf-8')
kreader = csv.reader(keysf)

outputf = open(outputFile, 'w', encoding='utf-8')
writer = csv.writer(outputf)

regions = dict({})
regions['Tel Aviv-Yafo']=0
regions['Bangalore']=0
regions['Beijing']=0
regions['Boston-Cambridge-Newton, MA-NH']=0
regions['Austin-Round Rock, TX']=0
regions['San Francisco-Oakland-Hayward, CA']=0
regions['San Jose-Sunnyvale-Santa Clara, CA']=0

for row in kreader:
    if kreader.line_num == 1:
        writer.writerow(row)
        continue

    if (row[3] in regions):
        regions[row[3]] += 1
        writer.writerow(row)

    if kreader.line_num % 1000000 == 0:
        print("Read " + str(kreader.line_num) + " citation lines")
        print(regions)

outputf.close()
keysf.close()
