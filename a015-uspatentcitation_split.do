set more off
local datadir /Users/aiyenggar/OneDrive/PatentsView/
cd `datadir'

use `datadir'uspatentcitation.dta
preserve
keep if category == "cited by applicant"
save uspatentcitation.applicant.dta, replace


restore
preserve
keep if category == "cited by examiner"
save uspatentcitation.examiner.dta, replace


restore
preserve
keep if category == "cited by other"
save uspatentcitation.other.dta, replace


restore
preserve
keep if category == "cited by third party"
save uspatentcitation.thirdparty.dta, replace

restore
keep if category == ""
save uspatentcitation.blank.dta, replace

clear
//gen year=year(date(date,"YMD"))

