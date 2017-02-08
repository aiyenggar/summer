set more off
local destdir ~/datafiles/patents/
cd `destdir'

use `destdir'rawlocation.dta, clear
rename id rawlocation_id
rename city city_rawloc
rename state state_rawloc
rename country country_rawloc
rename latlong latlong_rawloc
merge m:1 location_id using `destdir'locationid_urban_areas.dta

rename city city_loc
rename state state_loc
rename country country_loc
drop if _merge == 2

// There is one location_id ro8fiqvk0hdg that is not referenced by any rawlocation_id
// There are 328,838 empty location_id that are referenced by a rawlocation_id, but obviously absent in location.tsv
// Choosing to keep all

order rawlocation_id location_id region city_loc state_loc country_loc latitude longitude pop areakm
drop _merge
sort rawlocation_id
save `destdir'rawlocation_urban_areas.dta, replace
export delimited using `destdir'rawlocation_urban_areas.csv, replace

use `destdir'rawinventor.dta, clear
merge 1:1 rawlocation_id using `destdir'rawlocation_urban_areas.dta, keep(match master) nogen
rename sequence inventorseq
merge m:1 patent_id using `destdir'application.dta, keep(match master) nogen
gen appl_date = date(date,"YMD")
gen year=year(appl_date)
rename number application_id
drop id series_code country date uuid
order year patent_id inventor_id region country_loc 
sort patent_id
save `destdir'rawinventor_urban_areas.dta, replace
// rawinventor_region has 13,734,673 entries; 
// 3,831,577 have an empty region that includes 2,338,849 unique patents, 1,219,931 unique inventors
// 9,903,096 have region defined that include 4,736,011  unique patents,  2,424,569 unique inventors
// Total unique inventors: 3,287,305  
export delimited using `destdir'rawinventor_urban_areas.csv, replace

use `destdir'rawassignee.dta, clear
gen assignee = organization if !missing(organization)
replace assignee = name_first + " " + name_last if missing(assignee)
drop name_first name_last organization
rename sequence assigneeseq
rename type assigneetype
// We have 5,300,888 entries in rawassignee
merge 1:1 rawlocation_id using `destdir'rawlocation_urban_areas.dta, keep(match master) nogen
drop uuid
merge m:1 patent_id using `destdir'application.dta, keep(match master) nogen
gen appl_date = date(date,"YMD")
gen year=year(appl_date)
rename number application_id
drop id series_code country date 
order year patent_id assignee_id region assignee
sort patent_id
save `destdir'rawassignee_urban_areas.dta, replace
export delimited using `destdir'rawassignee_urban_areas.csv, replace
// 360,637 unique assignee ids, 187,224 since 2001
/* 
tab assigneetype if year > 2000
assigneetyp |
          e |      Freq.     Percent        Cum.
------------+-----------------------------------
          2 |  1,360,657       47.39       47.39
          3 |  1,471,529       51.25       98.65
          4 |     13,651        0.48       99.12
          5 |     10,920        0.38       99.50
          6 |     11,203        0.39       99.89
          7 |      2,644        0.09       99.99
          8 |          2        0.00       99.99
          9 |        105        0.00       99.99
         12 |         83        0.00       99.99
         13 |        110        0.00      100.00
         14 |         61        0.00      100.00
         15 |         43        0.00      100.00
         16 |          2        0.00      100.00
------------+-----------------------------------
      Total |  2,871,010      100.00
*/








// Try and move this to Python
use `destdir'uspatentcitation.applicant.dta, clear
keep uuid patent_id citation_id
merge m:1 patent_id using application, keep(match) nogenerate
gen appl_date = date(date,"YMD")
gen year=year(appl_date)
drop if year > 2012

keep uuid patent_id citation_id year 
rename uuid cit_uuid
rename patent_id cg_patent_id
rename citation_id ct_patent_id
save `destdir'uspc.appl.year.dta, replace

use `destdir'uspc.appl.year.dta, clear
// We start with 11,822,154 samples
gen patent_id=cg_patent_id
sort patent_id
joinby patent_id using rawassignee_region, unmatched(master)
rename assignee_id cg_assignee_id
rename region cg_assignee_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region
save `destdir'uspc.appl.year.cg_assignee_region.dta, replace

use `destdir'uspc.appl.year.cg_assignee_region.dta, clear
// With default joinby options, We now have 11,584,475 samples, a drop from where we started.
// After using unmatched(master) we have 12,038,020 samples of which 1,185,567 have an empty cg_assignee_id and  1,372,492 have an empty cg_assignee_region
gen patent_id=ct_patent_id
sort patent_id
joinby patent_id using rawassignee_region, unmatched(master)
rename assignee_id ct_assignee_id
rename region ct_assignee_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region ct_assignee_id ct_assignee_region
save `destdir'uspc.appl.year.cgct_assignee_region.dta, replace
// With default joinby options, This data seems to have 10,029,476 fields lower than we started with. 
// After using unmatched(master) we have 12,256,759 samples 
// of which  1,205,622 have an empty cg_assignee_id and   1,400,372 have an empty cg_assignee_region
// and  1,940,176 have an empty ct_assignee_id and   2,685,029 have an empty ct_assignee_region
// count if cg_assignee_id=="" | ct_assignee_id=="" is 2,869,978
// count if cg_assignee_id=="" & ct_assignee_id=="" is 275,820
export delimited using `destdir'uspc.appl.year.cgct_assignee_region.csv, replace

use `destdir'uspc.appl.year.cgct_assignee_region.dta, clear
gen patent_id=cg_patent_id
sort patent_id
joinby patent_id using rawinventor_region, unmatched(master)
rename inventor_id cg_inventor_id
rename region cg_inventor_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region ct_assignee_id ct_assignee_region cg_inventor_id cg_inventor_region 
sort ct_patent_id
save `destdir'uspc.appl.year.ass.cg_inventor_region.dta, replace
export delimited using `destdir'uspc.appl.year.ass.cg_inventor_region.csv, replace

use `destdir'uspc.appl.year.cgct_assignee_region.dta, clear
gen patent_id=ct_patent_id
sort patent_id
joinby patent_id using rawinventor_region, unmatched(master)
rename inventor_id ct_inventor_id
rename region ct_inventor_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region ct_assignee_id ct_assignee_region ct_inventor_id ct_inventor_region 
save `destdir'uspc.appl.year.ass.ct_inventor_region.dta, replace

duplicates drop ct_patent_id ct_inventor_id, force
keep ct_patent_id ct_inventor_id ct_inventor_region
sort ct_patent_id
save ct_patent_inventor_region.dta, replace
export delimited using `destdir'ct_patent_inventor_region.csv, replace

use `destdir'uspc.appl.year.ass.cg_inventor_region.dta, clear
joinby ct_patent_id using ct_patent_inventor_region, unmatched(master)
drop _merge
save `destdir'uspc.appl.year.ass.inv.region.dta, replace
export delimited using `destdir'uspc.appl.year.ass.inv.region.csv, replace
