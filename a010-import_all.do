set more off
local datadir /Users/aiyenggar/OneDrive/PatentsView/
cd `datadir'

import delimited `datadir'application.tsv, varnames(1) encoding(UTF-8) clear
save application.dta, replace

import delimited `datadir'uspatentcitation.tsv, varnames(1) encoding(UTF-8) clear
save uspatentcitation.dta, replace

import delimited `datadir'rawassignee.tsv, varnames(1) encoding(UTF-8) clear
gen ntype = real(type)
drop type
rename ntype type
drop  if patent_id=="" & assignee_id==""
//replace assignee_id=organization if assignee=="" & (type==2 | type==3)
save rawassignee.dta, replace

import delimited `datadir'rawinventor.tsv, varnames(1) encoding(UTF-8) clear
save rawinventor.dta, replace

import delimited `datadir'rawlocation.tsv, varnames(1) encoding(UTF-8) clear
sort id
save rawlocation.dta, replace

import delimited `datadir'patent_inventor.tsv, varnames(1) encoding(UTF-8) clear
sort patent_id
save patent_inventor.dta, replace

import delimited `datadir'locationid_region.csv, varnames(1) encoding(UTF-8) clear
rename id location_id
save locationid_region.dta, replace
