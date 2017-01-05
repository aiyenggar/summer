set more off
local datadir /Users/aiyenggar/OneDrive/data/patentsview/
local destdir /Users/aiyenggar/datafiles/patents/
cd `destdir'

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
sort patent_id sequence
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

//Import country_ipr here
import delimited `datadir'locationid_country.csv, varnames(1) encoding(UTF-8) clear
rename id location_id
rename name country
rename cortez ipr_score
keep location_id country ipr_score
save locationid_country.dta, replace

set more off
local datadir /Users/aiyenggar/OneDrive/data/patentsview/
local destdir /Users/aiyenggar/datafiles/patents/
cd `destdir'

use locationid_region.dta, clear
gen region_source = "MSA-Urban Centers" if !missing(region)
replace region_source = "PatentsView" if missing(region)

gen new_region = country if region_source=="PatentsView"
replace new_region = new_region + ", " + state if (region_source=="PatentsView" & !missing(state))
replace new_region = new_region + ", " + city if (region_source=="PatentsView" & !missing(city))
replace region=new_region if region_source=="PatentsView"
keep location_id region region_source latitude longitude
merge 1:1 location_id using locationid_country
drop _merge
save `destdir'locationid.latlong.region.ipr.dta, replace
export delimited using `destdir'locationid.latlong.region.ipr.csv, replace
