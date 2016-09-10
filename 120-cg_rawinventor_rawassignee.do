import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee_rawlocation_cluster.csv", encoding(ISO-8859-1)clear
rename * cga_*
rename cga_patent_id patent_id
save cg_rawassignee_rawlocation_cluster.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_uspatentcitation.csv", encoding(ISO-8859-1)clear
rename * cit_*
rename cit_patent_id patent_id

merge m:m patent_id using cg_rawassignee_rawlocation_cluster.dta
rename patent_id cg_patent_id

drop _merge

export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_citation_citing.csv", replace
save cgcd_citation_citing.dta, replace

//keep cg_patent_id cit_citation_id cit_date cga_assignee_id cga_type cga_name_first cga_name_last cga_organization cga_cluster 
//export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_citing_short.csv", replace
//save cgcd_citing_short.dta, replace

rename cit_citation_id cd_patent_id
merge m:m cd_patent_id using cd_rawinventor_rawassignee.dta, gen(_m2)
keep if _m2 == 3
 
keep cg_patent_id cd_patent_id cit_date cga_assignee_id cga_cluster cdi_inventor_id cdi_cluster cda_assignee_id cda_cluster
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_citing_cited_short.csv", replace
save cgcd_citing_cited_short.dta
