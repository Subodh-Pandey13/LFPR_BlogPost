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


* Graph for Labor Force Participation Rate for white, black and hispanic from BLS data using seasonally adjusted data

import delimited "/Users/subodh/Documents/LFPR_BlogPost/LFPR_BlogPost/GITHUB_LFPR/data_lfpr_race.csv", numericcols(5) clear 


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

