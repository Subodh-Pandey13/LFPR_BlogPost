*Graph for Labor Force participation Rate from BLS data using both seasonally adjusted and not-adjusted.

import delimited "/Users/subodh/Documents/LFPR_Blogpost/LFPR/data_LFPR.csv", numericcols(5) clear 

* I use the data from the BLS which contains both seasonally adjusted and not-adjusted. First I tried with the seasonally adjusted data
keep if seriesid == "LNS11300000"

* generates the variable which is month and real indicates that it must be numeric, then substring indicates, from the string variable period, extract from the second period to the last.
gen month = real(substr(period,2,.))

* ym is the stata function for year month
gen ym = ym(year, month)

* display ym as 1995m1, 1995m2 etc.
format ym %tm

*setting as time series
tsset ym

*making line graph
tsline value

* Using seasonally not adjusted data_LFPR
import delimited "/Users/subodh/Documents/LFPR_Blogpost/LFPR/data_LFPR.csv", numericcols(5) clear 


keep if seriesid == "LNU01300000"
gen month = real(substr(period,2,.))
gen ym = ym(year, month)
format ym %tm
tsset ym
tsline value

*Graph for Labor Force participation Rate for male and female from BLS data using both seasonally adjusted and not-adjusted.


 import delimited "/Users/subodh/Documents/LFPR_Blogpost/LFPR/data_LFPR_gender.csv", numericcols(4) clear 
 
 * OR
 
 import delimited "/Users/subodh/Documents/LFPR_BlogPost/LFPR_BlogPost/GITHUB_LFPR/data_lfpr_gender.csv", numericcols(5) clear

gen month = real(substr(period,2,.))
gen ym = ym(year, month)
format ym %tm

replace value = "." if value == "-"
destring value, replace
reshape wide value, i(ym) j(seriesid) string
rename valueLNS11300000 lfprs
rename valueLNS11300001 lfprs_men
rename valueLNS11300002 lfprs_women
rename valueLNU01300000 lfpru
rename valueLNU01300001 lfpru_men
rename valueLNU01300002 lfpru_women

label variable lfprs "Labor Force Participation Rate"
label variable lfprs_men "Labor Force Participation Rate for Male"
label variable lfprs_women "Labor Force Participation Rate for Female"

tsset ym
tsline lfprs lfprs_men lfprs_women

tsline lfprs lfprs_men lfprs_women if ym > tm(1999m12)

* Adding grey area for major economic events in the line graph
* Creating the dataset for economic downturn indicator

set fredkey ......
describe daten
gen ym = mofd(daten)
format ym %tm
drop if ym < tm(1948m1)
save "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_recession_nber.dta"
file /Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_recession_nber.dta saved

* Graph for Labor Force Participation Rate for white, black and hispanic from BLS data using seasonally adjusted data

import delimited "/Users/subodh/Documents/LFPR_BlogPost/LFPR_BlogPost/GITHUB_LFPR/data_lfpr_race.csv", numericcols(5) clear 

import delimited "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_lfpr_race.csv", numericcols(5) clear 

gen month = real(substr(period,2,.))
gen ym = ym(year, month)
format ym %tm

reshape wide value, i(ym) j(seriesid) string

rename valueLNS11300000 lfprs
rename valueLNS11300003 lfprs_white
rename valueLNS11300006 lfprs_black
rename valueLNS11300009 lfprs_hispanic_latino

label variable lfprs "Labor Force Participation Rate"
label variable lfprs_white "Labor Force Participation Rate for White"
label variable lfprs_black "Labor Force Participation Rate for Black"
label variable lfprs_hispanic_latino "Labor Force Participation Rate for Hispanic or Latino"

tsset ym

tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino

tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino if ym > tm(1999m12)

tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino if ym > tm(2013m12)

merge 1:1 ym using "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_recession_nber.dta"

drop if ym == tm(2026m1)

 use "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_merged_race_recession.dta"

tsset ym, monthly
label variable USRECM "Recession"

twoway area USRECM ym
replace USRECM = 72*USRECM
replace USRECM=55 if USRECM==0

twoway  (area USRECM ym) (tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino)

twoway (area USRECM ym) (tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino), legend(position(6) ring(1))

set scheme s1color

twoway (area USRECM ym, color(gs14))(tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino), ytitle("Labor Force Participation Rate") xtitle("") tlabel(, format(%tmCCYY)) legend(order(2 3 4 5) position(6) ring(1) col(4)label(2 "Overall") label(3 "White") label(4 "Black") label(5 "Hispanic/Latino"))

twoway (area USRECM ym if ym > tm(1999m12), color(gs14)) ///
    (tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino if ym > tm(1999m12)), ///
    ytitle("Labor Force Participation Rate") ///
    xtitle("") ///
    tlabel(, format(%tmCCYY)) ///
    legend(order(2 3 4 5) position(6) ring(1) col(4) ///
           label(2 "Overall") ///
           label(3 "White") ///
           label(4 "Black") ///
           label(5 "Hispanic/Latino"))

twoway (area USRECM ym if ym > tm(2013m12), color(gs14)) ///
    (tsline lfprs lfprs_white lfprs_black lfprs_hispanic_latino if ym > tm(2013m12)), ///
    ytitle("Labor Force Participation Rate") ///
    xtitle("") ///
    tlabel(, format(%tmCCYY)) ///
    legend(order(2 3 4 5) position(6) ring(1) col(4) ///
           label(2 "Overall") ///
           label(3 "White") ///
           label(4 "Black") ///
           label(5 "Hispanic/Latino"))

* Graph for Labor Force Participation Rate for male and female from BLS data using seasonally adjusted data
use "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_lfpr_gender.dta"

merge 1:1 ym using "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_recession_nber.dta"


drop if ym == tm(2026m1)

 use "/Users/subodh/Documents/LFPR_Blogpost/GITHUB_LFPR_BlogPost/Data_Codes_LFPR/data_merged_lfpr_gender_rec.dta"

replace USRECM = 90*USRECM
replace USRECM=20 if USRECM==0

twoway (area USRECM ym, color(gs14)) ///
    (tsline lfprs lfprs_men lfprs_women), ///
    ytitle("Labor Force Participation Rate") ///
    xtitle("") ///
    tlabel(, format(%tmCCYY)) ///
    legend(order(2 3 4 5) position(6) ring(1) col(4) ///
           label(2 "Overall") ///
           label(3 "Male") ///
           label(4 "Female"))


*Adjusting the axis of the recession line wrt minimum and maximum value		   
sum lfprs lfprs_men lfprs_women if ym > tm(1999m12)
replace USRECM=80 if USRECM==90
replace USRECM=50 if USRECM==20
		   
twoway (area USRECM ym if ym > tm(1999m12), color(gs14)) ///
    (tsline lfprs lfprs_men lfprs_women if ym > tm(1999m12)), ///
    ytitle("Labor Force Participation Rate") ///
    xtitle("") ///
    tlabel(, format(%tmCCYY)) ///
    legend(order(2 3 4 5) position(6) ring(1) col(4) ///
           label(2 "Overall") ///
           label(3 "Male") ///
           label(4 "Female"))


