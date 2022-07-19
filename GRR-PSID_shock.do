capture log close
log using GRR-PSID_shock, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Clean PSID data about Recession Shocks
local pgm GRR-PSID_shock
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  				#1	Load Data and Settings
use GRR-PSID_hshock
note:	`tag'	 	#1 Load Data and Settings
set matsize 800

//				#2	CPI for Inflation
note: 	`tag'	#2 Create CPI for Inflation, 2000 dollars

gen CPI04 = (172.2/188.9)
gen CPI05 = (172.2/195.3)
gen CPI06 = (172.2/201.6)
gen CPI07 = (172.2/207.342)
gen CPI08 = (172.2/215.303)
gen CPI09 = (172.2/214.537)
gen CPI10 = (172.2/218.056)
gen CPI11 = (172.2/224.939)

//				#3	chealth5k
note:	`tag' 	#3 Create chealth5k

codebook ER28037D3 ER28037D7 , m
codebook ER41027D3 ER41027D7 , m
codebook ER46971D3 ER46971D7 , m
codebook ER52395D3 ER52395D7 , m

gen health05e = ER28037D3 - ER28037D7 
gen health07e = ER41027D3 - ER41027D7 
gen health09e = ER46971D3 - ER46971D7 
gen health11e = ER52395D3 - ER52395D7 

gen chealth = ((health09e*CPI09 + health11e*CPI11) / 2) ///
			 -((health05e*CPI05 + health07e*CPI07) / 2) 
codebook chealth, m

label 	variable 	chealth "Change in average out-of-pocket HC expenses"
note 	chealth: 	Missing values are imputed; 2000 dollars `tag'

gen 	chealthk = 	chealth / 1000
label 	variable 	chealthk "total change in out-of-pocket HC expenses, 1k"
note 	chealthk: 	Missing values are imputed `tag'

//				#4 Create Rent
note:	`tag'	#4 Create Rent

**	Before homeowner
*	07
tab ER36028, m
drop if ER36028 == 9
recode ER36028 ///
(1=1) (else=0), gen(bHown)
tab bHown, m

** During renter
*	09
tab ER42029, m
recode ER42029 ///
(5=1) (8=1) (else=0), gen(rent09)
tab rent09, m

*	11
tab ER47329, m
recode ER47329 ///
(5=1) (8=1) (else=0), gen(rent11)
tab rent11, m

*	rent
gen rent1 = rent09 + rent11
tab rent1, m
recode rent1 (1/2=1) (else = 0)
tab rent1, m

tab rent1 bHown

*	Rent = 0 when bHown = 1
	*NOTE: Problem in the reference 
	*	- includes those who do and don't own homes before R

gen rent = rent1
replace rent = 0 if bHown == 0

tab rent, m

label variable 	rent "Became a renter"
label define 	rent 1 "yes" 0 "no", replace
note 			rent: Missing in the reference `tag'

**	Become owner
recode bHown (0=1) (1=0), gen(own)
replace own = 0 if rent1 == 1
tab own, m

label variable 	own "Became a home owner"
label define 	own 1 "yes" 0 "no", replace
note 			own: Missing in the reference `tag'

//				#5	Create Unemp + Bemp
note:	`tag' 	#5  Create Unemp + BBemp

*	Bemp head
codebook ER36109 ER36110 ER36111, m
recode ER36109 (1/3=1) (else = 0), gen(HBlf1)
recode ER36110 (1/3=1) (else = 0), gen(HBlf2)
recode ER36111 (1/3=1) (else = 0), gen(HBlf3)
gen HBlf = 0
replace HBlf = 1 if HBlf1 == 1
replace HBlf = 1 if HBlf2 == 1
replace HBlf = 1 if HBlf3 == 1
tab HBlf, m

*	Bemp spouse
codebook ER36367 ER36368 ER36369, m
recode ER36367 (1/3=1) (else = 0), gen(SBlf1)
recode ER36368 (1/3=1) (else = 0), gen(SBlf2)
recode ER36369 (1/3=1) (else = 0), gen(SBlf3)
gen SBlf = 0
replace SBlf = 1 if SBlf1 == 1
replace SBlf = 1 if SBlf2 == 1
replace SBlf = 1 if SBlf3 == 1
tab SBlf, m

*	Final Bemp
gen Blf = .
replace Blf = HBlf if ER33903 == 10
replace Blf = SBlf if ER33903 == 20
replace Blf = SBlf if ER33903 == 22
tab Blf, m

label variable 	Blf "In the labor force 2007"
label define 	Blf 1 "yes" 0 "no", replace
note 			Blf: Missing (99) in the reference `tag'

*	Weeks unemployed head

foreach wunempH in ER46778 ER46666 ER52186 ER52067	{			
codebook `wunempH', m
drop if  `wunempH' == 99
drop if  `wunempH' == 98
}

gen Hcunemp0710 = (ER46778 + ER46666 + ER52186 + ER52067)/4
tab Hcunemp0710, m
sum Hcunemp0710

*	Weeks unemployed spouse
foreach wunempS in ER46799 ER46677 ER52207 ER52078  	{			
codebook `wunempS', m
drop if  `wunempS' == 99
drop if  `wunempS' == 98
}

gen Scunemp0710 = (ER46799 + ER46677 + ER52207 + ER52078)/4
tab Scunemp0710, m
sum Scunemp0710

*	Final cunemp0710
gen cunemp0710 = .
replace cunemp0710 = Hcunemp0710 if ER33903 == 10
replace cunemp0710 = Scunemp0710 if ER33903 == 20
replace cunemp0710 = Scunemp0710 if ER33903 == 22
tab cunemp0710, m

label variable 	cunemp0710 "Months of Head Unemployment 2007-10"
note 			cunemp0710: No Missing; includes those not in LF `tag'

*	Final unemp2

gen 	unemp2 = 0
replace unemp2 = 1 if cunemp0710 > 2


*replace unemp2 = 1 if Hcunemp0710 > 2
*replace unemp2 = 1 if Scunemp0710 > 2

tab 	unemp2, m

label variable 	unemp2 "Experienced more than 2 months unemp"
note 			unemp2: No Missing; includes those not in LF `tag'

//				#6 	Education Changes
note:	`tag'	#6  Education Changes

codebook ER28037D1 ER41027D1 ER46971D1 ER52395D1, m

gen Bedu = (ER28037D1*CPI05 + ER41027D1*CPI07) / 2
gen Aedu = (ER46971D1*CPI09 + ER52395D1*CPI11) / 2
gen cedu = Aedu - Bedu

tab cedu, m

label variable 	cedu "Change in average educational expenditures b+a; $2000"
note 			cedu: Missing is imputed by PSID `tag'

gen ceduk = cedu / 1000
codebook ceduk, m

label variable 	ceduk "cedu / 1000"
note 			ceduk: Missing is imputed by PSID `tag'

//				#7 	Health Insurance Loss and increase expenditurue
note:	`tag'	#7  Health Insurance Loss and increase expenditure

codebook ER40409 ER46382 ER51743, m

*	drop missing
foreach hinsure in ER40409 ER46382 ER51743	{							
drop if  `hinsure' == 0		
drop if  `hinsure' == 8		
drop if  `hinsure' == 9	
codebook `hinsure' , m					
} 		 

*	create Hloss
*		Someone in the household had insurance in 2007 and no one 
*			in the family had insurance in 2009 or 2011

gen 	Hloss = .
replace Hloss = 0 if ER40409 == 1 
replace Hloss = 0 if ER40409 == 5
tab 	Hloss, m // ensure no missing
replace Hloss = 1 if ER40409 == 1 & ER46382 == 5
replace Hloss = 1 if ER40409 == 1 & ER51743 == 5
tab 	Hloss, m

label variable 	Hloss "wtr lost insurance coverage"
note 			Hloss: Missing are dropped`tag'

tab		ER40409, m
recode 	ER40409 (1=1) (5=0) (.=.) (else=.), gen (BHinsure)

label variable 	BHinsure "wtr had insurance coverage"
note 			BHinsure: Missing are dropped`tag'

tab BHinsure, m

gen HlossE 		= 0
replace HlossE 	= 1 if Hloss == 1 & chealth > 0
tab Hloss HlossE, m


*	with ANY loss health insurance
gen LinsureE = 0
replace LinsureE = 1 if Linsure == 1 & chealth > 0
tab LinsureE Linsure, m

//				#8	Create hardship, continuous 
note:	`tag'	#8  Create hardship, continuous

gen chardship = unemp2 + rent + LinsureE
tab chardship, m

label variable 	chardship "wtr experienced hardship"
note 			chardship: composed of rent, unemp, and LinsureE `tag'

//				#9	Create hardship, binary 
note:	`tag'	#9  Create hardship, binary

recode chardship (0=0) (1/3=1) (.=.) (else=.) , gen(hardship)

label variable 	hardship "wtr experienced hardship"
note 			hardship: composed of rent, unemp, and LinsureE `tag'

//  			#10	Save Data and Close Log 
note:	`tag'	#10 Save Data and Close Log

save	 "GRR-PSID_shock", replace 
clear
capture log close
exit
