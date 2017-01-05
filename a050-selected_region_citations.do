cap log close
log using knowledge-flows.log, append

set more off
local destdir /Users/aiyenggar/datafiles/patents/
local reportdir /Users/aiyenggar/OneDrive/code/articles/knowledge-flows-images/
cd `reportdir'

import delimited "`destdir'selected.uspc.appl.sim.inv_region.csv", delimiter(comma) varnames(1) encoding(ISO-8859-1)clear
save `destdir'selected.uspc.appl.sim.inv_region.dta, replace

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

save `destdir'summer.dta, replace
export delimited using `destdir'summer.csv, replace

set more off
local destdir /Users/aiyenggar/datafiles/patents/
local reportdir /Users/aiyenggar/OneDrive/code/articles/knowledge-flows-images/
cd `reportdir'

use `destdir'summer.dta, clear
collapse (sum) la (sum) lap (sum) lpa (sum)lpap (first)yr_reg_total, by(year cg_inventor_region)
gen nla = round((la*100/yr_reg_total), 0.01)
gen nlap = round((lap*100/yr_reg_total), 0.01)
gen nlpa = round((lpa*100/yr_reg_total), 0.01)
gen nlpap = round((lpap*100/yr_reg_total), 0.01)
gen nl=nla+nlap /* Same location flows, across assignees */
gen na=nla+nlpa /* Same assignee flows, across locations */

drop if year < 2000
/*
replace cg_inventor_region="Austin-Round Rock, TX" if cg_inventor_region=="Austin-Round Rock, TX"
replace cg_inventor_region="Boston-Cambridge-Newton, MA-NH" if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH"
replace cg_inventor_region="San Francisco-Oakland-Hayward, CA" if cg_inventor_region=="San Francisco-Oakland-Hayward, CA"
replace cg_inventor_region="San Jose-Sunnyvale-Santa Clara, CA" if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA"

graph twoway (connected nla year, mlabel(nla)) (connected nlap year, mlabel(nlap)), ///
	by(cg_inventor_region) legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee))
*/
graph twoway (connected nla year if cg_inventor_region=="Bangalore", mlabel(nla) msymbol(d)) (connected nla year if cg_inventor_region=="Beijing", msymbol(t)) ///
	(connected nla year if cg_inventor_region=="Tel Aviv-Yafo", msymbol(s)) (connected nla year if cg_inventor_region=="Austin-Round Rock, TX", msymbol(sh)) ///
	(connected nla year if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH", msymbol(x)) (connected nla year if cg_inventor_region=="San Francisco-Oakland-Hayward, CA", msymbol(o)) ///
	(connected nla year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA", mlabel(nla) msymbol(oh)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Region Same Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameRegionSameAssigneeFlows) ht(5) caption(Same Region Same Assignee Flows)

graph twoway (connected nlap year if cg_inventor_region=="Bangalore", mlabel(nlap) msymbol(d)) (connected nlap year if cg_inventor_region=="Beijing", msymbol(t)) ///
	(connected nlap year if cg_inventor_region=="Tel Aviv-Yafo",  msymbol(s)) (connected nlap year if cg_inventor_region=="Austin-Round Rock, TX",  msymbol(sh)) ///
	(connected nlap year if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH",  msymbol(x)) (connected nlap year if cg_inventor_region=="San Francisco-Oakland-Hayward, CA",  msymbol(o)) ///
	(connected nlap year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA", mlabel(nlap) msymbol(oh)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Region Different Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameRegionDiffAssigneeFlows) ht(5) caption(Same Region Different Assignee Flows)

graph twoway (connected nlpa year if cg_inventor_region=="Bangalore", mlabel(nlpa) msymbol(d)) (connected nlpa year if cg_inventor_region=="Beijing",  msymbol(t)) ///
	(connected nlpa year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nlpa) msymbol(s)) (connected nlpa year if cg_inventor_region=="Austin-Round Rock, TX",  msymbol(sh)) ///
	(connected nlpa year if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH",  msymbol(x)) (connected nlpa year if cg_inventor_region=="San Francisco-Oakland-Hayward, CA", msymbol(o)) ///
	(connected nlpa year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA",  msymbol(oh)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") /// 
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Different Region Same Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(DiffRegionSameAssigneeFlows) ht(5) caption(Different Region Same Assignee Flows)

graph twoway (connected nlpap year if cg_inventor_region=="Bangalore", msymbol(d)) (connected nlpap year if cg_inventor_region=="Beijing",  msymbol(t)) ///
	(connected nlpap year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(nlpap) msymbol(s)) (connected nlpap year if cg_inventor_region=="Austin-Round Rock, TX", msymbol(sh)) ///
	(connected nlpap year if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH",  msymbol(x)) (connected nlpap year if cg_inventor_region=="San Francisco-Oakland-Hayward, CA",  msymbol(o)) ///
	(connected nlpap year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA", mlabel(nlpap) msymbol(oh)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Different Region Different Assignee Flows") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(DiffRegionDiffAssigneeFlows) ht(5) caption(Different Region Different Assignee Flows)

graph twoway (connected nl year if cg_inventor_region=="Bangalore", mlabel(nl) msymbol(d)) (connected nl year if cg_inventor_region=="Beijing",  msymbol(t)) ///
	(connected nl year if cg_inventor_region=="Tel Aviv-Yafo",  msymbol(s)) (connected nl year if cg_inventor_region=="Austin-Round Rock, TX", msymbol(sh)) ///
	(connected nl year if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH",  msymbol(x)) (connected nl year if cg_inventor_region=="San Francisco-Oakland-Hayward, CA",  msymbol(o)) ///
	(connected nl year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA", mlabel(nl) msymbol(oh)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Region Flows (Aggregated over Assignees)") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameRegionFlows) ht(5) caption(Same Region Flows)

graph twoway (connected na year if cg_inventor_region=="Bangalore",  msymbol(d)) (connected na year if cg_inventor_region=="Beijing",  msymbol(t)) ///
	(connected na year if cg_inventor_region=="Tel Aviv-Yafo", mlabel(na) msymbol(s)) (connected na year if cg_inventor_region=="Austin-Round Rock, TX", mlabel(na) msymbol(sh)) ///
	(connected na year if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH",  msymbol(x)) (connected na year if cg_inventor_region=="San Francisco-Oakland-Hayward, CA",  msymbol(o)) ///
	(connected na year if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA",  msymbol(oh)), ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///
	ylabel(, angle(horizontal)) yscale(titlegap(*+10)) ///
	title("Same Assignee Flows (Aggregated over Regions)") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Bangalore) label(2 Beijing) label(3 Tel Aviv-Yafo) label(4 Austin-Round Rock) label(5 Boston-Cambridge-Newton) label(6 San Francisco-Oakland-Hayward) label(7 San Jose-Sunnyvale-Santa Clara))
graph2tex, epsfile(SameAssigneeFlows) ht(5) caption(Same Assignee Flows)

	
	
	
	
	
	
graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="Bangalore", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Bangalore") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(BangaloreNormalized) ht(5) caption(Knowledge Flows in Bangalore)

graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="Beijing", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Beijing") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(BeijingNormalized) ht(5) caption(Knowledge Flows in Beijing)

graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="Tel Aviv-Yafo", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Tel Aviv-Yafo") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(TelAviv-YafoNormalized) ht(5) caption(Knowledge Flows in Tel Aviv-Yafo)

graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Boston-Cambridge-Newton") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(Boston-Cambridge-NewtonNormalized) ht(5) caption(Knowledge Flows in Boston-Cambridge-Newton, MA-NH)

graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="Austin-Round Rock, TX", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to Austin-Round Rock") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(Austin-RoundRockNormalized) ht(5) caption(Knowledge Flows in Austin-Round Rock, TX)

graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="San Francisco-Oakland-Hayward, CA", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to San Francisco-Oakland-Hayward") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(SanFrancisco-Oakland-HaywardNormalized) ht(5) caption(Knowledge Flows in San Francisco-Oakland-Hayward, CA)

graph twoway (connected nla year, msymbol(Oh)) (connected nlap year, msymbol(Dh)) ///
	(connected nlpa year, msymbol(Th)) (connected nlpap year, msymbol(Sh)) if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA", ///
	ytitle("Normalized Citations (percent)") xtitle("Year of Citation") ///  
	title("Knowledge Flows to San Jose-Sunnyvale-Santa Clara") ///
	note("Data Source: PatentsView.org") ///
	legend(cols(1) label(1 Same Region, Same Assignee) label(2 Same Region, Different Assignee) label(3 Different Region, Same Assignee) label(4 Different Region, Different Assignee))
graph2tex, epsfile(SanJose-Sunnyvale-SantaClaraNormalized) ht(5) caption(Knowledge Flows in San Jose-Sunnyvale-Santa Clara, CA)

log close
