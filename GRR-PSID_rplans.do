capture log close
log using GRR-PSID_rplans, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: clean retirement plans
local pgm GRR-PSID_rplans
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

// 		#1	Load data and settings
use GRR-PSID_shock
note:	`tag'	 #1 Load Data and Settings
set matsize 800

//		#2	 Formula
note:	`tag'	#2  Formula

***	Pension plan: DB, DC, iDC, hybrid, none, misc
*	Current employer provided formula (head)
*	R questions ONLY ASKED of people who said YES, have plan
tab ER37755, m
recode ER37755 ///
(1=1 DB) ///
(5=2 DC) ///
(3=3 Both) ///
(8=4 Misc) ///
(9=4) ///
(0=0 neither), gen (formulah)
tab formulah, m

*	Current employer provided formula (spouse)
tab ER37987, m
recode ER37987 ///
(1=1 DB) ///
(5=2 DC) ///
(3=3 Both) ///
(8=4 Misc) ///
(9=4 Misc) ///
(0=0 neither), gen (formulas)
tab formulas, m

*	Private annuity/IRA = iDC retirement plan
*	Note: Includes those who rolled over from past employer (adjusted below)

tab 	ER37587, m
recode 	ER37587 ///
(1=1)(else=0), gen(DC2)

*	Combine employer and individual for rplan

tab1	formulah 	formulas DC2, m
gen 	formula2 = 	formulah + formulas*10 + DC2*100
tab 	formula2, m
recode 	formula2 														///
(0 			= 1 none)							 						///
(1 			= 2 B) 	 (2 		= 3 C) 	(3 		= 5 Hybrid) 			///
(4 			= 6 Misc)(14 		= 6) 	(24 	= 6)  		(34  = 6) 	///
(40/44 		= 6) 	 (104 		= 5) 	(114 	= 5) 		(124 = 5) 	///
(134 		= 5)	 (140/144 	= 5) 									///
(10 		= 2) 	 (11 		= 2) 	(12 	= 5)  		(13  = 5) 	///
(20 		= 3)	 (21 		= 5) 	(22 	= 3)  		(23  = 5) 	///
(30/33 		= 5) 														///
(100 		= 4 IDC) 													///
(101/133 	= 5) 														///
(else 		= .), gen (c_formula)
tab c_formula, m

*	Adjust for past employer pension

codebook ER37814 ER38046 ER37895 ER38127, m
codebook ER37874 ER38106 ER37955 ER38187, m

gen p_formula = 0

#delimit ;
foreach p_formula1 in 	 	
ER37814 ER38046 ER37895 ER38127
ER37874 ER38106 ER37955 ER38187 		
{												;
replace p_formula = 30 if `p_formula1' == 2		;
replace p_formula = 30 if `p_formula1' == 3		;
} 												;
#delimit cr

codebook ER37827 ER37828 ER37829 ER37830 ER37831 ER37832 , m
codebook ER38059 ER38060 ER38061 ER38062 ER38063 ER38064 , m
codebook ER37908 ER37909 ER37910 ER37911 ER37912 ER37913 , m
codebook ER38140 ER38141 ER38142 ER38143 ER38144 ER38145 , m

#delimit ;
foreach p_formula2 in 	 	
ER37827 ER37828 ER37829 ER37830 ER37831 ER37832 
ER38059 ER38060 ER38061 ER38062 ER38063 ER38064 
ER37908 ER37909 ER37910 ER37911 ER37912 ER37913 
ER38140 ER38141 ER38142 ER38143 ER38144 ER38145 
{												;
replace p_formula = 30 if `p_formula2' == 4		;
replace p_formula = 20 if `p_formula2' == 1		;
} 												;
#delimit cr

codebook ER37808 ER38040 ER37889 ER38121, m

#delimit ;
foreach p_formula3 in 	 	
ER37808 ER38040 ER37889 ER38121
{												;
replace p_formula = 60 if `p_formula3' == 8		;
} 												;
#delimit cr

*	combine current and past

tab1 c_formula p_formula, m
gen formulax = c_formula + p_formula
tab formulax, m

#delimit ; 
recode formulax 
	(1 		= 1 none)
	(2 		= 2 DB)
	(3 		= 3 DC)
	(4 		= 4 IDC)
	(5 		= 5 Hybrid)
	(6 		= 6 misc)
	(21 	= 2)
	(22 	= 2)
	(23/25 	= 5)
	(26		= 2)
	(31		= 3)
	(32		= 5)
	(33		= 3)
	(34		= 5)
	(35		= 5)
	(36 	= 3)
	(61		= 6)
	(62		= 2)
	(63		= 3)
	(64		= 5)
	(65		= 5)
	(66		= 6)
 	(else	= .)
	, gen(formula)	;
#delimit cr
tab  formula, m

/* What to do when family composition changes?
* any family composition could mean that we don't know who is cashing out

tab1 ER36007 ER47307 ER42007, m
tab  ER36007 formula
tab  ER47307 formula
tab  ER47307 formula

drop if ER36007 > 0
drop if ER47307 > 0
drop if ER47307 > 0
tab formula, m
*/

*	Drop missing formula
drop if formula == 6

*	Final label and note
label variable 	formula "Type of retirement plan"
note 			formula: Includes current and past employer; see diary `tag'
note 			formula: drops those with unknown plans `tag'
note 			formula: those who don't know if they have a plan, 0 `tag'

*	Create Rplan (has retirement plan beyond SS)
recode 	formula (2/5=1) (1=0), gen (Rplan)
tab 	Rplan, m

label variable  Rplan "has any retirement plan"
label define 	Rplan 1 "yes" 0 "no", replace
note 			Rplan: `tag'

//				#3 Cash Out
note:	`tag'	#3 Cash Out

tab1 ER43621 ER48966, m
drop if ER43621 == 8 
drop if ER43621 == 9
drop if ER48966 == 8
drop if ER48966 == 9
tab1 ER43621 ER48966, m

sum ER43621 ER48966
gen cashout = 0
replace cashout = 1 if ER43621 == 1 | ER48966 == 1
sum cashout

label variable	cashout "cashed out of a retirement plan"
label define	cashout 1 "yes" 0 "no", replace
note			cashout:  All missing dropped `tag'

tab formula cashout, m
drop if formula == 1 & cashout == 1
tab formula cashout, m

note cashout: Family level! `tag'

replace cashout = . if Rplan == 0
tab formula cashout, m

note cashout: cash out missing when rplan = 0 `tag'


*** TEMPORARY 2019_12_13
*	Ammount cashed out

codebook ER43622 ER48967, m

drop if ER48905 == 999999998
drop if ER48905 == 999999999

drop if ER43580 == 999999998
drop if ER43580 == 999999999

gen usd_cashout = ER43622*CPI09 + ER48967*CPI11

replace usd_cashout = . if Rplan == 0

codebook usd_cashout, m

label 	variable	usd_cashout "ammount withdrew"
note				usd_cashout: missing dropped `tag'

note usd_cashout: ammount withdrew, 2000 dollars `tag'

*** TEMPORARY OVER



//  			#5	Save Data and Close Log 
note:	`tag' 	#5	Save Data and Close Log

save	 "GRR-PSID_rplans", replace 
clear
capture log close
exit





