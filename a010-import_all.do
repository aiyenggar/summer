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

// Added 2017-01-18
local datadir /Users/aiyenggar/OneDrive/data/patentsview/
local destdir /Users/aiyenggar/datafiles/patents/
cd `destdir'
import delimited `datadir'locationid_urban_areas.csv, varnames(1) encoding(UTF-8) clear
rename id location_id
save `destdir'locationid_urban_areas.dta, replace

//Import country_ipr here

set more off
local datadir /Users/aiyenggar/OneDrive/data/patentsview/
local destdir /Users/aiyenggar/datafiles/patents/
cd `destdir'
import delimited `destdir'uspc-hjt-mapping.csv, varnames(1) encoding(UTF-8) clear
gen mainclass_id = string(class)
save `destdir'uspc-hjt-mapping.dta, replace

import delimited `datadir'uspc.tsv, varnames(1) encoding(UTF-8) clear
save `destdir'uspc.dta

sort sequence
duplicates drop patent_id, force

sort patent_id
save `destdir'primary.uspc.dta, replace

duplicates drop country, force
keep country ipr_score
drop if missing(country)
save country_ipr.dta, replace
export delimited using country_ipr.csv, replace

set more off
local datadir /Users/aiyenggar/OneDrive/data/patentsview/
local destdir /Users/aiyenggar/datafiles/patents/
cd `destdir'

import delimited `datadir'locationid_country.csv, varnames(1) encoding(UTF-8) clear
save `destdir'locationid_country.dta, replace

/* 20170118 Start Urban Areas */
use locationid_urban_areas.dta, clear
rename country country2
keep location_id region region_source latitude longitude country2
merge 1:1 location_id using locationid_country
drop ipr_score _merge
save temp.dta, replace

drop if missing(country)
duplicates drop country2, force
keep country2 country
rename country mcountry
save map.dta, replace

use temp.dta, clear
merge m:1 country2 using map.dta
drop _merge
replace country=mcountry if (missing(country) & !missing(mcountry))
drop country2 mcountry
save `destdir'locationid.latlong.urban_areas.dta, replace
export delimited using `destdir'locationid.latlong.urban_areas.csv, replace
rm map.dta
rm temp.dta
/* End Urban Areas */

/* Use this only when you need an integrated region */
use locationid_region.dta, clear
gen region_source = "MSA-Urban Centers" if !missing(region)
replace region_source = "PatentsView" if missing(region)

gen new_region = country if region_source=="PatentsView"
replace new_region = new_region + ", " + state if (region_source=="PatentsView" & !missing(state))
replace new_region = new_region + ", " + city if (region_source=="PatentsView" & !missing(city))
replace region=new_region if region_source=="PatentsView"
rename country country2
keep location_id region region_source latitude longitude country2
merge 1:1 location_id using locationid_country
drop ipr_score
drop _merge
save temp.dta, replace

drop if missing(country)
duplicates drop country2, force
keep country2 country
rename country mcountry
save map.dta, replace

use temp.dta, clear
merge m:1 country2 using map.dta
drop _merge
// 55 observations don't still have a country name, 21 unique country codes
replace country=mcountry if (missing(country) & !missing(mcountry))
replace country=mcountry if (region_source=="PatentsView" & country != mcountry)
replace country="United States" if (region=="Brownsville-Harlingen, TX" & country!="United States")
replace country="United States" if (region=="Watertown-Fort Drum, NY" & country!="United States")
replace country="United States" if (region=="Tucson, AZ" & country!="United States")
replace country="United States" if (region=="El Paso, TX" & country!="United States")
replace country="United States" if (region=="McAllen-Edinburg-Mission, TX" & country!="United States")
replace country="United States" if (region=="Ogdensburg-Massena, NY" & country!="United States")
replace country="United States" if (region=="Rio Grande City, TX" & country!="United States")
replace country="United States" if (region=="Bellingham, WA" & country!="United States")
replace country="Hong Kong" if (region=="Hong Kong" & country!="Hong Kong")
drop country2 mcountry
save `destdir'locationid.latlong.region.dta, replace
export delimited using `destdir'locationid.latlong.region.csv, replace
rm map.dta
rm temp.dta
/* end integrated region */
