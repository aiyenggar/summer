import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee_rawlocation_cluster.csv", encoding(ISO-8859-1)clear
rename * cga_*
rename cga_patent_id patent_id
save cg_rawassignee_rawlocation_cluster.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_uspatentcitation.csv", encoding(ISO-8859-1)clear
rename * cit_*
rename cit_patent_id patent_id

merge m:m patent_id using cd_rawassignee_rawlocation_cluster.dta
rename patent_id cg_patent_id

export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_citation_citing.csv", replace
save cgcd_citation_citing.dta, replace

