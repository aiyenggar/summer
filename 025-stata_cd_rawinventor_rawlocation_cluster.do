import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawlocation_cluster_inventor.csv", varnames(1) encoding(ISO-8859-1)clear
save cd_rawlocation_cluster_inventor.dta, replace
import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor.csv", varnames(1) encoding(ISO-8859-1)clear
merge 1:1 rawlocation_id using cd_rawlocation_cluster_inventor.dta
keep if _merge == 3
drop _merge
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawlocation_cluster.csv", replace
erase cd_rawlocation_cluster_inventor.dta
