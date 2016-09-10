import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee.csv", encoding(ISO-8859-1)clear
preserve

keep if cdi_cluster=="Bangalore"
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee_BLR.csv", replace
save cd_rawinventor_rawassignee_BLR.dta, replace

restore
preserve
keep if cdi_cluster=="Beijing"
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee_BEI.csv", replace
save cd_rawinventor_rawassignee_BEI.dta, replace

restore
preserve
keep if cdi_cluster=="Israel"
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee_ISR.csv", replace
save cd_rawinventor_rawassignee_ISR.dta, replace

restore
preserve
keep if cdi_cluster=="Austin"
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee_AUS.csv", replace
save cd_rawinventor_rawassignee_AUS.dta, replace

restore
preserve
keep if cdi_cluster=="Boston"
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee_BOS.csv", replace
save cd_rawinventor_rawassignee_BOS.dta, replace

restore
keep if cdi_cluster=="Silicon Valley"
export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cd_rawinventor_rawassignee_SIV.csv", replace
save cd_rawinventor_rawassignee_SIV.dta, replace

clear
