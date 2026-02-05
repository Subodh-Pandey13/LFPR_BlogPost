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

