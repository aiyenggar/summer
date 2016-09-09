import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee.csv", encoding(ISO-8859-1)clear
save cg_rawassignee.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/all_locationid_cluster.csv", varnames(1) encoding(ISO-8859-1) clear
save all_locationid_cluster.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cg_rawlocation_assignee.csv", varnames(1) encoding(ISO-8859-1) clear
rename id rawlocation_id
replace location_id="missing_location_id" if missing(location_id)
merge m:1 location_id using all_locationid_cluster
keep if _merge==3
drop _merge
save cg_rawlocation_cluster_assignee.dta, replace

use cg_rawassignee, clear
merge 1:1 rawlocation_id using cg_rawlocation_cluster_assignee.dta
drop _merge
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee_rawlocation_cluster.csv", replace
//save cd_rawassignee_rawlocation_cluster.dta, replace

erase cg_rawlocation_cluster_assignee.dta
erase all_locationid_cluster.dta
erase cg_rawassignee.dta
