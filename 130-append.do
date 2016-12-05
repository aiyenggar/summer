use "/Users/aiyenggar/OneDrive/stata/cgcd_minimal_AUS.dta", replace
append using "/Users/aiyenggar/OneDrive/stata/cgcd_minimal_BEI.dta"
append using "/Users/aiyenggar/OneDrive/stata/cgcd_minimal_BLR.dta"
append using "/Users/aiyenggar/OneDrive/stata/cgcd_minimal_ISR.dta"

label variable la "Same Location Same Assignee"
label variable lap "Same Location Different Assignee"
label variable lpa "Different Location Same Assignee"
label variable lpap "Different Location Different Assignee"
label variable cg_patent_id "Citing Patent ID"
label variable cd_patent_id "Cited Patent ID"
label variable cga_assignee_id "Assignee ID of citing patent"
label variable cga_cluster "Cluster of citing patent"
label variable cdi_inventor_id "Inventor ID of cited patent"
label variable cdi_cluster "Cluster of cited patent"
label variable cda_assignee_id "Assignee ID of cited patent"
label variable cit_year "Year of citation (same as year of grant of citing patent)"

export delimited using "/Users/aiyenggar/OneDrive/code/qgis/cgcd_all.csv", replace
save "/Users/aiyenggar/OneDrive/stata/cgcd_all.dta", replace
