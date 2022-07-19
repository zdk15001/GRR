capture log close
log using GRR-PSID_demo, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Demographic Factors
local pgm GRR-PSID_demo
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//				#1 	Load Data and Settings	
use GRR-PSID_econ
note:	`tag'	#1	Load Data and Settings

//  			#2	Family Formation and gender
note:	`tag' 	#2	Family Formation and gender

*	Couple
tab ER41039, m
recode ER41039 (1=1) (else=0), gen(couplex)
tab couplex, m

*	Female
tab ER36018, m
gen femalex = ER36018-1
tab femalex, m

*	Marital
gen maritalx = couplex + femalex*10
tab maritalx
recode maritalx (1=1 couple) (11=1) ///
(0=2 mhead) (10=3 fhead), gen(marital)
tab marital, m

*	Children in FU
tab ER36020, m
gen child = ER36020
tab child, m

*	Family Composition
gen familyx = child + marital*10
tab familyx, m
recode familyx (10 = 1 couple) (11/17 = 2 couplek) ///
(20 = 3 single) (21/25 = 4 singlek) ///
(30 = 3 ) (31/38 = 4), gen(family)
tab family, m

label 	variable 	family "Family Formation"
note				family: Missing in reference `tag'

*	Gender
gen female = .
replace female = femalex if ER33903 == 10
replace female = 1 if ER33903 == 20
replace female = 1 if ER33903 == 22
tab female, m

label 	variable 	female "R is female"
note				family: Missing in reference `tag'

//  			#3	Non-Hispanic white
note:	`tag' 	#3	Non-Hispanic white 

*	Head
codebook ER40564 ER40565 ER40566 ER40567 ER40568, m

tab1 ER40564 ER40565

recode ER40564 ///
(0=1) ///
(else=0), gen(nolatH)

recode ER40565 ///
(1=1) ///
(else=0), gen(whiteH)

replace whiteH = 0 if ER40566 == 2 
replace whiteH = 0 if ER40567 == 2
replace whiteH = 0 if ER40568 == 2

replace whiteH = 0 if ER40566 == 3 
replace whiteH = 0 if ER40567 == 3
replace whiteH = 0 if ER40568 == 3

replace whiteH = 0 if ER40566 == 4 
replace whiteH = 0 if ER40567 == 4
replace whiteH = 0 if ER40568 == 4

replace whiteH = 0 if ER40566 == 5 
replace whiteH = 0 if ER40567 == 5
replace whiteH = 0 if ER40568 == 5

replace whiteH = 0 if ER40566 == 6 
replace whiteH = 0 if ER40567 == 6
replace whiteH = 0 if ER40568 == 6

replace whiteH = 0 if ER40566 == 7 
replace whiteH = 0 if ER40567 == 7
replace whiteH = 0 if ER40568 == 7

tab whiteH, m

gen nhwhiteH = nolatH+whiteH-1
recode nhwhiteH (-1=0)
tab1 nhwhiteH, m

*	Spouse
codebook ER40471 ER40472 ER40473 ER40474 ER40475, m

tab1 ER40471 ER40472, m

recode ER40471 ///
(0=1) ///
(else=0), gen(nolatS)

recode ER40472 ///
(1=1) ///
(else=0), gen(whiteS)

replace whiteS = 0 if ER40473 == 2 
replace whiteS = 0 if ER40474 == 2
replace whiteS = 0 if ER40475 == 2

replace whiteS = 0 if ER40473 == 3 
replace whiteS = 0 if ER40474 == 3
replace whiteS = 0 if ER40475 == 3

replace whiteS = 0 if ER40473 == 4 
replace whiteS = 0 if ER40474 == 4
replace whiteS = 0 if ER40475 == 4

replace whiteS = 0 if ER40473 == 5 
replace whiteS = 0 if ER40474 == 5
replace whiteS = 0 if ER40475 == 5

replace whiteS = 0 if ER40473 == 6 
replace whiteS = 0 if ER40474 == 6
replace whiteS = 0 if ER40475 == 6

replace whiteS = 0 if ER40473 == 7 
replace whiteS = 0 if ER40474 == 7
replace whiteS = 0 if ER40475 == 7

tab whiteS, m

gen nhwhiteS = nolatS+whiteS-1
recode nhwhiteS (-1=0)
tab1 nhwhiteS, m


*	Final variable
gen nhwhite = .
replace nhwhite = nhwhiteH if ER33903 == 10
replace nhwhite = nhwhiteS if ER33903 == 20
replace nhwhite = nhwhiteS if ER33903 == 22
tab nhwhite, m

label 	variable 	nhwhite "is non-Hispanic white"
note				nhwhite: Missing in reference `tag'

//  			#4	Region
note:	`tag' 	#4	Region

tab ER41032, m

drop if ER41032 == 6

recode ER41032					 ///
	(1=1 NE) (2=2 MW) (3=3 S) 	 ///
	(4=4 W)  (5=1), gen (region)
tab region, m

label 	variable 	region "region of country"
note				region: dropped foreign residents `tag'
note				region: Alaska/Hawaii -> NE `tag'

//				#5 	Retired or at retirement age
note:	`tag'	#5 	Retired or at retirement age

*	head
codebook ER36017 ER36109 ER36110 ER36111, m
gen retireH = 0
replace retireH = 1 if ER36109 == 4
replace retireH = 1 if ER36110 == 4
replace retireH = 1 if ER36111 == 4
replace retireH = 1 if ER36017 > 53
tab retireH, m

*	spouse
codebook ER36019 ER36367 ER36368 ER36369, m
gen retireS = 0
replace retireS = 1 if ER36367 == 4
replace retireS = 1 if ER36368 == 4
replace retireS = 1 if ER36369 == 4
replace retireS = 1 if ER36019 > 53
tab retireS, m

*	final
gen retireR = .
replace retireR = retireH if ER33903 == 10
replace retireR = retireS if ER33903 == 20
replace retireR = retireS if ER33903 == 22
tab retireR, m

gen retire = 0
replace retire = 1 if retireH == 1
replace retire = 1 if retireS == 1
tab retire, m

tab retire retireR

label 	variable	retire  "retired or at retirement age (54+)"
note				retire: `tag'

* drop if RESPONDENT or spouse! is retired
drop if retire == 1

//  			#6	Cohort
note:	`tag' 	#6	Cohort

tab ER36017, m
gen cohort10H = (2007 - ER36017)
tab cohort10H, m

tab ER36019, m
gen cohort10S = (2007 - ER36019)
tab cohort10S, m

gen cohort10 = .
replace cohort10 = cohort10H if ER33903 == 10
replace cohort10 = cohort10S if ER33903 == 20
replace cohort10 = cohort10S if ER33903 == 22
tab cohort10, m

label 	variable 	cohort10 "continuous age cohort"
note				cohort10: no missing `tag'
			
//  			#7	Save Data and Close Log
note:	`tag' 	#7	Save Data and Close Log

save	 "GRR-PSID_demo", replace 
clear
capture log close
exit








