capture log close
log using GRR-PSID_econ, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Socio-Economic factors
local pgm GRR-PSID_econ
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//				#1 	Load Data and Settings	
use GRR-PSID_rplans
note:	`tag'	#1	Load Data and Settings

//  			#2	Selection: Self Employed
note:	`tag' 	#2	Selection: Self Employed

tab 	ER36134, m
recode	ER36134 (3=1) (else=0), gen(Hself)
tab 	Hself, m

tab 	ER36392, m
recode	ER36392 (3=1) (else=0), gen(Sself)
tab 	Sself, m

gen self = .
replace self = Hself if ER33903 == 10
replace self = Sself if ER33903 == 20
replace self = Sself if ER33903 == 22
tab self, m

label 	variable 	self "is self employed"
label 	define		self 1 "yes" 0 "no"
note				self: Missing in reference `tag'

//  			#3	Selection: Government Employee
note:	`tag' 	#3	Selection: Government Employee

tab 	ER36136, m
recode 	ER36136 (1/3=1) (else=0), gen(Hgov)
tab 	Hgov, m 

tab 	ER36394, m
recode 	ER36394 (1/3=1) (else=0), gen(Sgov)
tab 	Sgov, m 

gen gov = .
replace gov = Hgov if ER33903 == 10
replace gov = Sgov if ER33903 == 20
replace gov = Sgov if ER33903 == 22
tab gov, m

label 	variable 	gov "works for government"
label 	define		gov 1 "yes" 0 "no"
note				gov: Missing in reference `tag'

//  			#4	Selection: Union
note:	`tag' 	#4	Selection: Union

tab 	ER36144, m
recode 	ER36144 (1=1) (else=0), gen(Hunion)
tab 	Hunion, m

tab 	ER36402, m
recode 	ER36402 (1=1) (else=0), gen(Sunion)
tab 	Sunion, m

gen union = .
replace union = Hunion if ER33903 == 10
replace union = Sunion if ER33903 == 20
replace union = Sunion if ER33903 == 22
tab union, m

label 	variable	union "member of union"
label 	define		union 1 "yes" 0 "no"
note				union: Missing in reference `tag'

//  			#5	SES: Income
note:	`tag' 	#5	SES: Income

codebook ER28037 ER41027, m

gen income04 = ER28037*CPI04
gen income06 = ER41027*CPI06

sum income04 income06 

*	Income before the Recession

gen 		Bincome = ((income04+income06)/2)
codebook	Bincome, m

label 	variable	Bincome "average income before Recession (05+07)"
note				Bincome: No missing `tag'

*	Income before the Recession (standardized)

egen 	 BSincome = std(Bincome)
codebook BSincome, m

label 	variable	BSincome 	///
					"Standardized average income before Recession (05+07)"
note				BSincome: No missing `tag'

*	Income before the Recession (natural log) min 1
gen 		lnBincome = Bincome
replace 	lnBincome = 1 if lnBincome < 1
replace 	lnBincome = log(lnBincome)

codebook 	lnBincome, m

label 	variable	lnBincome 	///
					"ln average income before Recession (05+07), min of 1"
note				lnBincome: No missing `tag'

//  			#6	SES: Education
note:	`tag' 	#6	SES: Education

*	Head
tab ER41037, m
sum ER41037 if ER41037 < 20

recode ER41037 ///
(0/11=1 lessHS) ///
(12=2 HS) ///
(13/15=3 somecoll) ///
(16/17=4 Graduate) ///
(99=.) , gen (Hedu)
tab Hedu, m

*	Spouse
tab ER41038, m
sum ER41038 if ER41038 < 20

*	NOTE: a 0 value for ER41038 could be due to no wife OR no education
*			This shouldn't be a proble because of selection process by follow 

recode ER41038 ///
(0/11=1 lessHS) ///
(12=2 HS) ///
(13/15=3 somecoll) ///
(16/17=4 Graduate) ///
(99=.) , gen (Sedu)
tab Sedu, m

*	Final

gen edu = .
replace edu = Hedu if ER33903 == 10
replace edu = Sedu if ER33903 == 20
replace edu = Sedu if ER33903 == 22
tab edu, m
drop if edu == .

label 	variable	edu "education in categories"
note				edu: Missing dropped - need imputation? `tag'

codebook ER41037 ER41038, m
gen cedu12H = ER41037 - 12
gen cedu12S = ER41038 - 12
gen cedu12 = .
replace cedu12 = cedu12H if ER33903 == 10
replace cedu12 = cedu12S if ER33903 == 20
replace cedu12 = cedu12S if ER33903 == 22
tab cedu12, m

tab cedu12, m
label 	variable	cedu "education in years, centered 12"
note				cedu: Missing dropped - need imputation? `tag'

//  			#7	SES: Wealth
note:	`tag' 	#7	SES: Wealth

codebook S717 S817, m
gen wealth05_all = S717*CPI05
gen wealth07_all = S817*CPI07
gen Bwealth_all = ((wealth05_all+wealth07_all)/2)

label 	variable	Bwealth_all "average wealth before Recession (05+07), including IRA"
note				Bwealth_all: `tag'

*	IRA
codebook S819 S719, m
gen IRA05 = S819*CPI05
gen IRA07 = S819*CPI07
gen BIRA  = ((IRA05+IRA07)/2)

codebook BIRA, m

label 	variable	BIRA "average IRA wealth before Recession (05+07)"
note				BIRA: `tag'

*** temporary 2019_12_13

codebook ER48905 ER43580, m

drop if ER48905 == 999999998
drop if ER48905 == 999999999

drop if ER43580 == 999999998
drop if ER43580 == 999999999

gen IRA09 = ER48905*CPI09
gen IRA11 = IRA07*CPI11
gen AIRA = ((IRA09+IRA11)/2)

codebook AIRA, m

label 	variable	AIRA "average IRA wealth after Recession (09+11)"
note				AIRA: `tag'

* change

gen cIRA = BIRA-AIRA
codebook cIRA, m

label 	variable	cIRA "change in average IRA wealth before/after Recession"
note				AIRA: missing dropped `tag'

***	 TEMPORARY OVER

*	wealth before the Recession 
gen Bwealth = Bwealth_all - BIRA

label 	variable	Bwealth "average wealth before Recession (05+07), excluding IRA"
note				Bwealth: `tag'

*	Standardize
egen 		BSwealth = std(Bincome)
codebook 	BSwealth, m

label 	variable	BSwealth 	///
					"Standardized average wealth before Recession (05+07)"
note				BSwealth: No missing `tag'

*	wealth before the Recession (natural log, min of 1)

gen 		lnBwealth = Bwealth
replace 	lnBwealth = 1 if lnBwealth < 1
replace 	lnBwealth = ln(lnBwealth)

codebook 	lnBwealth, m

label 	variable	lnBwealth	///
					"ln average wealth before Recession (05+07), min 1 excluding IRA"
note				lnBwealth: No missing `tag'

//  			#8	Save Data and Close Log
note:	`tag' 	#8	Save Data and Close Log

save	 "GRR-PSID_econ", replace 
clear
capture log close
exit
