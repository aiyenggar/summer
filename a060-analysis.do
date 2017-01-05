cap log close
log using knowledge-flows.log, append

set more off
local destdir /Users/aiyenggar/datafiles/patents/
local imagedir /Users/aiyenggar/OneDrive/code/articles/knowledge-flows-images/
cd `destdir'

use `destdir'summer.dta, clear

drop if year < 2000

/*
replace cg_inventor_region="Austin-Round Rock, TX" if cg_inventor_region=="Austin-Round Rock, TX"
replace cg_inventor_region="Boston-Cambridge-Newton, MA-NH" if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH"
replace cg_inventor_region="San Francisco-Oakland-Hayward, CA" if cg_inventor_region=="San Francisco-Oakland-Hayward, CA"
replace cg_inventor_region="San Jose-Sunnyvale-Santa Clara, CA" if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA"

replace ct_inventor_region="Austin-Round Rock, TX" if ct_inventor_region=="Austin-Round Rock, TX"
replace ct_inventor_region="Boston-Cambridge-Newton, MA-NH" if ct_inventor_region=="Boston-Cambridge-Newton, MA-NH"
replace ct_inventor_region="San Francisco-Oakland-Hayward, CA" if ct_inventor_region=="San Francisco-Oakland-Hayward, CA"
replace ct_inventor_region="San Jose-Sunnyvale-Santa Clara, CA" if ct_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA"
*/

bysort year cg_inventor_region: egen sumla = sum(la)
bysort year cg_inventor_region: egen sumlap = sum(lap)
bysort year cg_inventor_region: egen sumlpa = sum(lpa)
bysort year cg_inventor_region: egen sumlpap = sum(lpap)


gen nla = round(sumla*100/yr_reg_total, .01)
label variable nla "Local-Internal"
gen nlap = round(sumlap*100/yr_reg_total, .01)
label variable nlap "Local-External"
gen nlpa = round(sumlpa*100/yr_reg_total, .01)
label variable nlpa "Non-Local-Internal"
gen nlpap = round(sumlpap*100/yr_reg_total, .01)
label variable nlpap "Non-Local-External"
gen nl=nla+nlap /* Same location flows, across assignees */
label variable nl "Local Flows"
gen na=nla+nlpa /* Same assignee flows, across locations */
label variable na "Internal Flows"

gen cgaustin = 1 if cg_inventor_region=="Austin-Round Rock, TX"
replace cgaustin = 0 if missing(cgaustin)
label variable cgaustin "Citing Region = Austin"

gen ctaustin = 1 if ct_inventor_region=="Austin-Round Rock, TX"
replace ctaustin = 0 if missing(ctaustin)
label variable ctaustin "Cited Region = Austin"

gen cgbangalore = 1 if cg_inventor_region=="Bangalore"
replace cgbangalore = 0 if missing(cgbangalore)
label variable cgbangalore "Citing Region = Bangalore"

gen ctbangalore = 1 if ct_inventor_region=="Bangalore"
replace ctbangalore = 0 if missing(ctbangalore)
label variable ctbangalore "Cited Region = Bangalore"

gen cgbeijing = 1 if cg_inventor_region=="Beijing"
replace cgbeijing = 0 if missing(cgbeijing)
label variable cgbeijing "Citing Region = Beijing"

gen ctbeijing = 1 if ct_inventor_region=="Beijing"
replace ctbeijing = 0 if missing(ctbeijing)
label variable ctbeijing "Cited Region = Beijing"

gen cgboston = 1 if cg_inventor_region=="Boston-Cambridge-Newton, MA-NH"
replace cgboston = 0 if missing(cgboston)
label variable cgboston "Citing Region = Boston"

gen ctboston = 1 if ct_inventor_region=="Boston-Cambridge-Newton, MA-NH"
replace ctboston = 0 if missing(ctboston)
label variable ctboston "Cited Region = Boston"

gen cgsanfrancisco = 1 if cg_inventor_region=="San Francisco-Oakland-Hayward, CA"
replace cgsanfrancisco = 0 if missing(cgsanfrancisco)
label variable cgsanfrancisco "Citing Region = San Francisco"

gen ctsanfrancisco = 1 if ct_inventor_region=="San Francisco-Oakland-Hayward, CA"
replace ctsanfrancisco = 0 if missing(ctsanfrancisco)
label variable ctsanfrancisco "Cited Region = San Francisco"

gen cgsanjose = 1 if cg_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA"
replace cgsanjose = 0 if missing(cgsanjose)
label variable cgsanjose "Citing Region = San Jose"

gen ctsanjose = 1 if ct_inventor_region=="San Jose-Sunnyvale-Santa Clara, CA"
replace ctsanjose = 0 if missing(ctsanjose)
label variable ctsanjose "Cited Region = San Jose"

gen cgtelaviv = 1 if cg_inventor_region=="Tel Aviv-Yafo"
replace cgtelaviv = 0 if missing(cgtelaviv)
label variable cgtelaviv "Citing Region = Tel Aviv"

gen cttelaviv = 1 if ct_inventor_region=="Tel Aviv-Yafo"
replace cttelaviv = 0 if missing(cttelaviv)
label variable cttelaviv "Cited Region = Tel Aviv"

reg nl cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv
outreg2 using  `imagedir'local.tex, drop (_*) tex(pretty frag) label dec(2) replace
reg nl cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv
outreg2 using  `imagedir'local.tex, drop (_*) tex(pretty frag) label dec(2) append
xi: reg nl cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv i.year 
outreg2 using  `imagedir'local.tex, title(Effect of inventor resident regions on normalized aggregate local flows \label{local}) drop (_*) tex(pretty frag) label dec(2) append

reg na cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv
outreg2 using  `imagedir'internal.tex, drop (_*) tex(pretty frag) label dec(2) replace
reg na cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv
outreg2 using  `imagedir'internal.tex, drop (_*) tex(pretty frag) label dec(2) append
xi: reg na cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv i.year 
outreg2 using  `imagedir'internal.tex, title(Effect of inventor resident regions on normalized aggregate internal flows \label{internal}) drop (_*) tex(pretty frag) label dec(2) append

reg nla cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv
outreg2 using  `imagedir'localinternal.tex, drop (_*) tex(pretty frag) label dec(2) replace
reg nla cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv
outreg2 using  `imagedir'localinternal.tex, drop (_*) tex(pretty frag) label dec(2) append
xi: reg nla cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv i.year 
outreg2 using  `imagedir'localinternal.tex, title(Effect of inventor resident regions on normalized local-internal flows \label{localinternal}) drop (_*) tex(pretty frag) label dec(2) append

reg nlap cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv
outreg2 using  `imagedir'localexternal.tex, drop (_*) tex(pretty frag) label dec(2) replace
reg nlap cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv
outreg2 using  `imagedir'localexternal.tex, drop (_*) tex(pretty frag) label dec(2) append
xi: reg nlap cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv i.year 
outreg2 using  `imagedir'localexternal.tex, title(Effect of inventor resident regions on normalized local-external flows \label{localexternal}) drop (_*) tex(pretty frag) label dec(2) append

reg nlpa cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv
outreg2 using  `imagedir'nonlocalinternal.tex, drop (_*) tex(pretty frag) label dec(2) replace
reg nlpa cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv
outreg2 using  `imagedir'nonlocalinternal.tex, drop (_*) tex(pretty frag) label dec(2) append
xi: reg nlpa cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv i.year 
outreg2 using  `imagedir'nonlocalinternal.tex, title(Effect of inventor resident regions on normalized nonlocal-internal flows \label{nonlocalinternal}) drop (_*) tex(pretty frag) label dec(2) append

reg nlpap cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv
outreg2 using  `imagedir'nonlocalexternal.tex, drop (_*) tex(pretty frag) label dec(2) replace
reg nlpap cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv
outreg2 using  `imagedir'nonlocalexternal.tex, drop (_*) tex(pretty frag) label dec(2) append
xi: reg nlpap cgbangalore cgbeijing cgboston cgsanfrancisco cgsanjose cgtelaviv ctbangalore ctbeijing ctboston ctsanfrancisco ctsanjose cttelaviv i.year 
outreg2 using  `imagedir'nonlocalexternal.tex, title(Effect of inventor resident regions on normalized nonlocal-external flows \label{nonlocalexternal}) drop (_*) tex(pretty frag) label dec(2) append

save `destdir'summer_upd.dta, replace
log close
