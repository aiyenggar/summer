cap log close
log using knowledge-flows.log, append

set more off
local destdir /Users/aiyenggar/datafiles/patents/
local imagedir /Users/aiyenggar/OneDrive/code/articles/knowledge-flows-images/
cd `destdir'

use `destdir'summer_upd.dta, clear
drop cg_patent_id ct_patent_id ct_inventor_region ass_sim loc_sim ct* l*
bysort year cg_inventor_region: gen index=_n
keep if index==1
drop index

xi: reg nl cgbangalore cgbeijing cgboston cgsanfrancisco cgaustin cgtelaviv i.year 
outreg2 using  `imagedir'small.tex, drop (_*) tex(pretty frag) label dec(2) replace

xi: reg na cgbangalore cgbeijing cgboston cgsanfrancisco cgaustin cgtelaviv i.year
outreg2 using  `imagedir'small.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: reg nla cgbangalore cgbeijing cgboston cgsanfrancisco cgaustin cgtelaviv i.year
outreg2 using  `imagedir'small.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: reg nlap cgbangalore cgbeijing cgboston cgsanfrancisco cgaustin cgtelaviv i.year
outreg2 using  `imagedir'small.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: reg nlpa cgbangalore cgbeijing cgboston cgsanfrancisco cgaustin cgtelaviv i.year
outreg2 using  `imagedir'small.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: reg nlpap cgbangalore cgbeijing cgboston cgsanfrancisco cgaustin cgtelaviv i.year
outreg2 using  `imagedir'small.tex, title(Effect of inventor resident regions on normalized flows, Reference Category: San Jose \label{small}) drop (_*) tex(pretty frag) label dec(2) append

/* Alternate */
/* The following makes no sense 
set more off
xi: logistic cgbangalore nla nlap nlpa nlpap i.year 
outreg2 using  `imagedir'reverse.tex, drop (_*) tex(pretty frag) label dec(2) replace

xi: logistic cgbeijing nla nlap nlpa nlpap i.year
outreg2 using  `imagedir'reverse.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: logistic cgboston nla nlap nlpa nlpap i.year
outreg2 using  `imagedir'reverse.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: logistic cgsanfrancisco nla nlap nlpa nlpap i.year
outreg2 using  `imagedir'reverse.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: logistic cgaustin nla nlap nlpa nlpap i.year
outreg2 using  `imagedir'reverse.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: logistic cgsanjose nla nlap nlpa nlpap i.year
outreg2 using  `imagedir'reverse.tex, drop (_*) tex(pretty frag) label dec(2) append

xi: logistic cgtelaviv nla nlap nlpa nlpap i.year
outreg2 using  `imagedir'reverse.tex, title(Effect of inventor resident regions on normalized flows, Reference Category: San Jose \label{reverse}) drop (_*) tex(pretty frag) label dec(2) append
*/

log close
