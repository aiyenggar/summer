import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawassignee.csv", encoding(ISO-8859-1)clear
save cd_rawassignee.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/all_locationid_cluster.csv", varnames(1) encoding(ISO-8859-1) clear
save all_locationid_cluster.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawlocation_assignee.csv", varnames(1) encoding(ISO-8859-1) clear
rename id rawlocation_id
replace location_id="missing_location_id" if missing(location_id)
merge m:1 location_id using all_locationid_cluster
keep if _merge==3
drop _merge
save cd_rawlocation_cluster_assignee.dta, replace

use cd_rawassignee, clear
merge 1:1 rawlocation_id using cd_rawlocation_cluster_assignee.dta
drop _merge
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawassignee_rawlocation_cluster.csv", replace
//save cd_rawassignee_rawlocation_cluster.dta, replace

erase cd_rawlocation_cluster_assignee.dta
erase all_locationid_cluster.dta
erase cd_rawassignee.dta
