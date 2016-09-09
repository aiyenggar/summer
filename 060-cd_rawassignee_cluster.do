import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawassignee.csv", encoding(ISO-8859-1)clear
save cd_rawassignee.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawlocation_assignee.csv", varnames(1) encoding(ISO-8859-1) clear
save cd_rawlocation_assignee.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/all_locationid_cluster.csv", varnames(1) encoding(ISO-8859-1) clear
save all_locationid_cluster.dta, replace

use cd_rawlocation_assignee.dta, clear
rename id rawlocation_id
save, replace

use cd_rawlocation_assignee.dta, clear
replace location_id="missing_location_id" if missing(location_id)
save, replace

use cd_rawlocation_assignee.dta, clear
merge m:1 location_id using all_locationid_cluster
keep if _merge==3
drop _merge
save cd_rawlocation_cluster_assignee.dta, replace

use cd_rawassignee, clear
merge 1:1 rawlocation_id using cd_rawlocation_cluster_assignee.dta
drop _merge
save cd_rawassignee_cluster.dta, replace
