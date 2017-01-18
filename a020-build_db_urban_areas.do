set more off
local destdir /Users/aiyenggar/datafiles/patents/
cd `destdir'

use `destdir'rawlocation.dta, clear
keep id location_id
merge m:1 location_id using `destdir'locationid.latlong.region.dta
// There is one location_id ro8fiqvk0hdg that is not referenced by any rawlocation_id
// There are 328,838 empty location_id that are referenced by a rawlocation_id, but obviously absent in location.tsv
// Choosing to keep all
rename id rawlocation_id
replace region="Singapore" if (region!="Singapore" & country=="Singapore")
keep rawlocation_id location_id region country
sort rawlocation_id
save `destdir'rawlocation_urban_areas.dta, replace
export delimited using `destdir'rawlocation_urban_areas.csv replace

use `destdir'rawinventor.dta, clear
merge 1:1 rawlocation_id using `destdir'rawlocation_urban_areas.dta
keep if _merge==3
// Check if all the rawlocation_id look ok. I saw some four digit ones
merge m:1 patent_id using `destdir'application.dta, keep(match) nogenerate
gen appl_date = date(date,"YMD")
gen year=year(appl_date)
keep patent_id inventor_id region country year
sort patent_id
save `destdir'rawinventor_urban_areas.dta, replace
// rawinventor_region has 13,734,673 entries; 78 have an empty region; 242,038 are not assigned to a country
export delimited using `destdir'rawinventor_urban_areas.csv, replace

use `destdir'rawassignee.dta, clear
// We have 5,300,888 entries in rawassignee
merge 1:1 rawlocation_id using `destdir'rawlocation_urban_areas.dta
keep if _merge==3
keep patent_id assignee_id region country
sort patent_id
save `destdir'rawassignee_urban_areas.dta, replace
// rawassignee_region has 5,300,888 entries; <revise, should no longer be true> 698,480 have an empty region (hopefully because it is not an urban center)
export delimited using `destdir'rawassignee_urban_areas.csv, replace








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
