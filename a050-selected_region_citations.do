import delimited "/Users/aiyenggar/OneDrive/PatentsView/selected.uspc.appl.sim.inv_region.csv", delimiter(comma) varnames(1) encoding(ISO-8859-1)clear
save /Users/aiyenggar/OneDrive/PatentsView/selected.uspc.appl.sim.inv_region.dta, clear

// We start with 23,825,110 observations, leave with 5,820,864 observations
duplicates drop cg_patent_id ct_patent_id cg_inventor_region ct_inventor_region, force

drop if ass_sim==2
// Left with 5,058,782 observations

drop if loc_sim==2
// Left with 4,661,422 observations

gen la =  cond(loc_sim==1 & ass_sim==1, 1, 0)
gen lap =  cond(loc_sim==1 & ass_sim==0, 1, 0)
gen lpa =  cond(loc_sim==0 & ass_sim==1, 1, 0)
gen lpap =  cond(loc_sim==0 & ass_sim==0, 1, 0)

bysort year cg_inventor_region: gen yr_reg_total=_N

save /Users/aiyenggar/OneDrive/PatentsView/summer.dta, replace

use /Users/aiyenggar/OneDrive/PatentsView/summer.dta, clear
collapse (sum) la (sum) lap (sum) lpa (sum)lpap (first)yr_reg_total, by(year cg_inventor_region)
gen nla = round(la*100/yr_reg_total)
gen nlap = round(lap*100/yr_reg_total)
gen nlpa = round(lpa*100/yr_reg_total)
gen nlpap = round(lpap*100/yr_reg_total)
gen nl=nla+nlap /* Same location flows, across assignees */
gen na=nla+nlpa /* Same assignee flows, across locations */

drop if year < 2000
replace cg_inventor_region="Austin-Round Rock" if cg_inventor_region=="Austin-Round Rock, TX"
replace cg_inventor_region="Boston-Cambridge-Newton" if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH"
replace cg_inventor_region="San Francisco-Oakland-Hayward" if cg_inventor_region=="San Francisco-Oakland-Hayward, CA"
replace cg_inventor_region="San Jose-Sunnyvale-Santa Clara" if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA"

graph twoway (connected nla year, mlabel(nla)) (connected nlap year, mlabel(nlap)), ///
	by(cg_inventor_region) legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee))

graph twoway (connected nla year if cg_inventor_region=="Bangalore", mlabel(nla)) (line nla year if cg_inventor_region=="Beijing", mlabel(nla)) ///
	(line nla year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nla)) (line nla year if cg_inventor_region=="Austin-Round Rock", mlabel(nla)) ///
	(connected nla year if cg_inventor_region=="Boston-Cambridge-Newton", mlabel(nla)) (line nla year if cg_inventor_region=="San Francisco-Oakland-Hayward", mlabel(nla)) ///
	(line nla year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara", mlabel(nla)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Region Same Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameRegionSameAssigneeFlows) ht(5) caption(Same Region Same Assignee Flows)

graph twoway (connected nlap year if cg_inventor_region=="Bangalore", mlabel(nlap)) (line nlap year if cg_inventor_region=="Beijing", mlabel(nlap)) ///
	(line nlap year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nlap)) (line nlap year if cg_inventor_region=="Austin-Round Rock", mlabel(nlap)) ///
	(line nlap year if cg_inventor_region=="Boston-Cambridge-Newton", mlabel(nlap)) (line nlap year if cg_inventor_region=="San Francisco-Oakland-Hayward", mlabel(nlap)) ///
	(connected nlap year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara", mlabel(nlap)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Region Different Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameRegionDiffAssigneeFlows) ht(5) caption(Same Region Different Assignee Flows)

graph twoway (connected nlpa year if cg_inventor_region=="Bangalore", mlabel(nlpa)) (line nlpa year if cg_inventor_region=="Beijing", mlabel(nlpa)) ///
	(connected nlpa year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nlpa)) (line nlpa year if cg_inventor_region=="Austin-Round Rock", mlabel(nlpa)) ///
	(line nlpa year if cg_inventor_region=="Boston-Cambridge-Newton", mlabel(nlpa)) (line nlpa year if cg_inventor_region=="San Francisco-Oakland-Hayward", mlabel(nlpa)) ///
	(line nlpa year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara", mlabel(nlpa)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Diff Region Same Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(DiffRegionSameAssigneeFlows) ht(5) caption(Diff Region Same Assignee Flows)

graph twoway (line nlpap year if cg_inventor_region=="Bangalore", mlabel(nlpap)) (line nlpap year if cg_inventor_region=="Beijing", mlabel(nlpap)) ///
	(connected nlpap year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nlpap)) (line nlpap year if cg_inventor_region=="Austin-Round Rock", mlabel(nlpap)) ///
	(line nlpap year if cg_inventor_region=="Boston-Cambridge-Newton", mlabel(nlpap)) (line nlpap year if cg_inventor_region=="San Francisco-Oakland-Hayward", mlabel(nlpap)) ///
	(connected nlpap year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara", mlabel(nlpap)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Diff Region Diff Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(DiffRegionDiffAssigneeFlows) ht(5) caption(Diff Region Diff Assignee Flows)

graph twoway (connected nl year if cg_inventor_region=="Bangalore", mlabel(nl)) (line nl year if cg_inventor_region=="Beijing", mlabel(nl)) ///
	(line nl year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nl)) (line nl year if cg_inventor_region=="Austin-Round Rock", mlabel(nl)) ///
	(line nl year if cg_inventor_region=="Boston-Cambridge-Newton", mlabel(nl)) (line nl year if cg_inventor_region=="San Francisco-Oakland-Hayward", mlabel(nl)) ///
	(connected nl year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara", mlabel(nl)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Region Flows (Aggregated)") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameRegionFlows) ht(5) caption(Same Region Flows)

graph twoway (connected na year if cg_inventor_region=="Bangalore", mlabel(na)) (line na year if cg_inventor_region=="Beijing", mlabel(na)) ///
	(connected na year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(na)) (line na year if cg_inventor_region=="Austin-Round Rock", mlabel(na)) ///
	(line na year if cg_inventor_region=="Boston-Cambridge-Newton", mlabel(na)) (line na year if cg_inventor_region=="San Francisco-Oakland-Hayward", mlabel(na)) ///
	(line na year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara", mlabel(na)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Assignee Flows (Aggregated)") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara) pos(1))
graph2tex, epsfile(SameAssigneeFlows) ht(5) caption(Same Assignee Flows)

	
	
	
	
	
	
graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="Bangalore", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Bangalore") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(BangaloreNormalized) ht(5) caption(Knowledge Flows in Bangalore)

graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="Beijing", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Beijing") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(BeijingNormalized) ht(5) caption(Knowledge Flows in Beijing)

graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="Tel Aviv-Yafo", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Tel Aviv-Yafo") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(TelAviv-YafoNormalized) ht(5) caption(Knowledge Flows in Tel Aviv-Yafo)

graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Boston-Cambridge-Newton, MA-NH") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(Boston-Cambridge-NewtonNormalized) ht(5) caption(Knowledge Flows in Boston-Cambridge-Newton, MA-NH)

graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="Austin-Round Rock, TX", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Austin-Round Rock, TX") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(Austin-Round RockNormalized) ht(5) caption(Knowledge Flows in Austin-Round Rock, TX)

graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="San Francisco-Oakland-Hayward, CA", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to San Francisco-Oakland-Hayward, CA") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(SanFrancisco-Oakland-HaywardNormalized) ht(5) caption(Knowledge Flows in San Francisco-Oakland-Hayward, CA)

graph twoway (connected nla year) (connected nlap year) ///
	(connected nlpa year) (connected nlpap year) if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to San Jose-Sunnyvale-Santa Clara, CA") ///
	note("Data Source: PatentsView.org") ///
	legend(label(1 Same Region, Same Assignee) label(2 Same Region, Diff Assignee) label(3 Diff Region, Same Assignee) label(4 Diff Region, Diff Assignee))
graph2tex, epsfile(SanJose-Sunnyvale-SantaClaraNormalized) ht(5) caption(Knowledge Flows in San Jose-Sunnyvale-Santa Clara, CA)

