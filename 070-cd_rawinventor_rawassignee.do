import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawassignee_rawlocation_cluster.csv", encoding(ISO-8859-1)clear
rename * cda_*
rename cda_patent_id patent_id
save cd_rawassignee_rawlocation_cluster.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawlocation_cluster_year.csv", encoding(ISO-8859-1)clear
rename * cdi_*
rename cdi_patent_id patent_id

merge m:m patent_id using cd_rawassignee_rawlocation_cluster.dta
rename patent_id cd_patent_id
drop _merge

export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee.csv", replace
save cd_rawinventor_rawassignee.dta, replace

