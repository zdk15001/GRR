capture log close
log using GRR-PSID_SES, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: SES Scale
local pgm GRR-PSID_SES
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1	Load Data and Settings
use GRR-PSID_demo
note:	`tag'	#1 Load Data and Settings

//				#2 SES: Factor analysis (qbincome, wealth, qbedu)
note: 	`tag'	#2 SES: Factor analysis (qbincome, qbwealth, qbedu)
		
*	Quintile income
codebook Bincome, m
xtile qbincome = Bincome, nq(4)

label 	variable	qbincome "income quartile"
note				qbincome: `tag'
		
*	Quintile wealth
codebook Bwealth, m
xtile qbwealth = Bwealth, nq(4)

label 	variable	qbwealth "wealth quartile"
note				qbwealth: `tag'	
	
	
*	Factor	
factor  edu qbincome qbwealth, pcf
rotate, v
predict SES

codebook SES, m
sum      SES

label 	variable 	SES "SES scale"
note				SES: factor analysis from edu, qbincome, and qbwealth `tag'

alpha edu qbincome qbwealth

note SES: 	Find Eigenvalue, loadings, and alpha here `tag'

*	check range for ordered groups 
sum Bwealth if qbwealth == 1
sum Bwealth if qbwealth == 2
sum Bwealth if qbwealth == 3
sum Bwealth if qbwealth == 4

sum Bincome if qbincome == 1
sum Bincome if qbincome == 2
sum Bincome if qbincome == 3
sum Bincome if qbincome == 4

*	median
sum Bwealth, detail
sum Bincome, detail


//				#2 SESiw: Factor analysis (qbincome, wealth, qbedu)
note: 	`tag'	#2 SESiw: Factor analysis (qbincome, qbwealth, qbedu)

factor qbincome qbwealth, pcf
rotate, v
predict SESiw

codebook SES, m
sum      SES

label 	variable 	SESiw "SES scale income wealth"
note				SES: factor analysis from qbincome, and qbwealth `tag'

alpha qbincome qbwealth

note SESiw: 	Find Eigenvalue, loadings, and alpha here `tag'

//  			#3	Save Data and Close Log 
note:	`tag' 	#3	Save Data and Close Log

save	 "GRR-PSID", replace 
clear
capture log close
exit

