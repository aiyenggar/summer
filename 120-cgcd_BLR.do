import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cg_rawassignee_rawlocation_cluster_BLR.csv", encoding(ISO-8859-1)clear
rename * cga_*
rename cga_patent_id patent_id
save cg_rawassignee_rawlocation_cluster.dta, replace

import delimited "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_uspatentcitation_BLR.csv", encoding(ISO-8859-1)clear
rename * cit_*
rename cit_patent_id patent_id

merge m:m patent_id using cg_rawassignee_rawlocation_cluster.dta, gen(_mcg)
rename patent_id cg_patent_id
erase cg_rawassignee_rawlocation_cluster.dta

rename cit_citation_id cd_patent_id
merge m:m cd_patent_id using cd_rawinventor_rawassignee_BLR.dta, gen(_mcd)

export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_BLR.csv", replace
gen cit_year=year(date(cit_date,"YMD"))
keep cg_patent_id cd_patent_id cit_year cga_assignee_id cga_cluster cdi_inventor_id cdi_cluster cda_assignee_id
drop if missing(cg_patent_id) | missing(cd_patent_id)
drop if missing(cga_assignee_id) | missing(cda_assignee_id)
drop if  cga_cluster=="DataUnavailable"

gen la =  cond(cga_cluster==cdi_cluster & cga_assignee_id==cda_assignee_id, 1, 0)
gen lap =  cond(cga_cluster==cdi_cluster & cga_assignee_id!=cda_assignee_id, 1, 0)
gen lpa =  cond(cga_cluster!=cdi_cluster & cga_assignee_id==cda_assignee_id, 1, 0)
gen lpap =  cond(cga_cluster!=cdi_cluster & cga_assignee_id!=cda_assignee_id, 1, 0)

export delimited using "/Users/aiyenggar/OneDrive/stata/qgis/cgcd_minimal_BLR.csv", replace
save cgcd_minimal_BLR.dta, replace

sort cit_year
collapse (sum) la (sum) lap (sum) lpa (sum)lpap, by(cit_year)


graph twoway (scatter la cit_year) (line lap cit_year) if cit_year >= 1976 & cit_year <= 2015, ///
	ytitle("Number of Patent Citations") xtitle("Year of Citation") ///
	title("Local Knowledge Flows in Bangalore") ///
	note("Source: PatentsView.org") ///
	legend(label(1 Same Location, Same Firm) label(2 Same Location, Different Firm))
//graph save BangaloreLocal1976.gph, replace
graph2tex, epsfile(BangaloreLocal1976) ht(5) caption(Local Knowledge Flows in Bangalore)


graph twoway (scatter la cit_year) (line lap cit_year) ///
	(scatter lpa cit_year) (line lpap cit_year) if cit_year >= 1976 & cit_year <= 2015, ///
	ytitle("Number of Patent Citations") xtitle("Year of Citation") ///  
	title("Knowledge Flows from Bangalore since 1976") ///
	note("Source: PatentsView.org") ///
	legend(label(1 Same Location, Same Firm) label(2 Same Location, Different Firm) label(3 Different Location, Same Firm) label(4 Different Location, Different Firm))
//graph save Bangalore1976.gph, replace
graph2tex, epsfile(Bangalore1976) ht(5) caption(Knowledge Flows from Bangalore)

