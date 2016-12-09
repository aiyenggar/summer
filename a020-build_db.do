set more off
local datadir /Users/aiyenggar/OneDrive/PatentsView/
cd `datadir'

use `datadir'rawlocation.dta, clear
merge m:1 location_id using locationid_region
// There is one location_id ro8fiqvk0hdg that is not referenced by any rawlocation_id
// There are 328,838 empty location_id that are referenced by a rawlocation_id, but obviously absent in location.tsv
// Choosing to keep all
rename id rawlocation_id
keep rawlocation_id location_id region
sort rawlocation_id
// Out of a total of 128912 unique location_id, 53424 have been mapped to a region and 75488 have been left empty
// Those 75488 we need to ensure do not fall under any urban region of the world
save `datadir'rawlocation_region.dta, replace

use `datadir'rawinventor.dta, clear
merge 1:1 rawlocation_id using rawlocation_region
keep if _merge==3
// Check if all the rawlocation_id look ok. I saw some four digit ones
keep patent_id inventor_id region
sort patent_id
save `datadir'rawinventor_region.dta, replace
// rawinventor_region has 13,734,673 entries; 2,353,724 have an empty region (hopefully because it is not an urban center)
export delimited using `datadir'rawinventor_region.csv, replace

use `datadir'rawassignee.dta, clear
// We have 5,300,888 entries in rawassignee
merge 1:1 rawlocation_id using rawlocation_region
keep if _merge==3
keep patent_id assignee_id region
sort patent_id
save `datadir'rawassignee_region.dta, replace
// rawassignee_region has 5,300,888 entries; 698,480 have an empty region (hopefully because it is not an urban center)

use `datadir'uspatentcitation.applicant.dta, clear
keep uuid patent_id citation_id
merge m:1 patent_id using application, keep(match) nogenerate
gen appl_date = date(date,"YMD")
gen year=year(appl_date)
drop if year > 2012

keep uuid patent_id citation_id year 
rename uuid cit_uuid
rename patent_id cg_patent_id
rename citation_id ct_patent_id
save `datadir'uspc.appl.year.dta, replace

use `datadir'uspc.appl.year.dta, clear
// We start with 11,822,154 samples
gen patent_id=cg_patent_id
sort patent_id
joinby patent_id using rawassignee_region, unmatched(master)
rename assignee_id cg_assignee_id
rename region cg_assignee_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region
save `datadir'uspc.appl.year.cg_assignee_region.dta, replace

use `datadir'uspc.appl.year.cg_assignee_region.dta, clear
// With default joinby options, We now have 11,584,475 samples, a drop from where we started.
// After using unmatched(master) we have 12,038,020 samples of which 1,185,567 have an empty cg_assignee_id and  1,372,492 have an empty cg_assignee_region
gen patent_id=ct_patent_id
sort patent_id
joinby patent_id using rawassignee_region, unmatched(master)
rename assignee_id ct_assignee_id
rename region ct_assignee_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region ct_assignee_id ct_assignee_region
save `datadir'uspc.appl.year.cgct_assignee_region.dta, replace
// With default joinby options, This data seems to have 10,029,476 fields lower than we started with. 
// After using unmatched(master) we have 12,256,759 samples 
// of which  1,205,622 have an empty cg_assignee_id and   1,400,372 have an empty cg_assignee_region
// and  1,940,176 have an empty ct_assignee_id and   2,685,029 have an empty ct_assignee_region
// count if cg_assignee_id=="" | ct_assignee_id=="" is 2,869,978
// count if cg_assignee_id=="" & ct_assignee_id=="" is 275,820
export delimited using `datadir'uspc.appl.year.cgct_assignee_region.csv, replace

use `datadir'uspc.appl.year.cgct_assignee_region.dta, clear
gen patent_id=cg_patent_id
sort patent_id
joinby patent_id using rawinventor_region, unmatched(master)
rename inventor_id cg_inventor_id
rename region cg_inventor_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region ct_assignee_id ct_assignee_region cg_inventor_id cg_inventor_region 
sort ct_patent_id
save `datadir'uspc.appl.year.ass.cg_inventor_region.dta, replace
export delimited using `datadir'uspc.appl.year.ass.cg_inventor_region.csv, replace

use `datadir'uspc.appl.year.cgct_assignee_region.dta, clear
gen patent_id=ct_patent_id
sort patent_id
joinby patent_id using rawinventor_region, unmatched(master)
rename inventor_id ct_inventor_id
rename region ct_inventor_region
keep cit_uuid cg_patent_id ct_patent_id year cg_assignee_id cg_assignee_region ct_assignee_id ct_assignee_region ct_inventor_id ct_inventor_region 
save `datadir'uspc.appl.year.ass.ct_inventor_region.dta, replace

duplicates drop ct_patent_id ct_inventor_id, force
keep ct_patent_id ct_inventor_id ct_inventor_region
sort ct_patent_id
save ct_patent_inventor_region.dta, replace
export delimited using `datadir'ct_patent_inventor_region.csv, replace

use `datadir'uspc.appl.year.ass.cg_inventor_region.dta, clear
joinby ct_patent_id using ct_patent_inventor_region, unmatched(master)
drop _merge
save `datadir'uspc.appl.year.ass.inv.region.dta, replace
export delimited using `datadir'uspc.appl.year.ass.inv.region.csv, replace