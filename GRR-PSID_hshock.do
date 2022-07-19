capture log close
log using GRR-PSID_hshock, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm GRR-PSID_hshock
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 infix individuals
note:	`tag'	#1 infix individuals

capture log close
log using GRR-PSID_ehistory, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm GRR-PSID_ehistory
local dte 2019-11-25
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 infix individuals
note:	`tag'	#1 infix individuals

#delimit ;

infix 
ER30001         2 - 5
ER30002         6 - 8
ER32006      2063 - 2063

ER33801      3187 - 3191      
ER33802      3192 - 3193 
ER33803      3194 - 3195

ER33901      3486 - 3490 
ER33902      3491 - 3492      
ER33903      3493 - 3494
ER33919      3525 - 3526 

ER34001      3764 - 3768 
ER34002      3769 - 3770      
ER34003      3771 - 3772
ER34022      3809 - 3810 

ER34101      3986 - 3990      
ER34102      3991 - 3992      
ER34103      3993 - 3994
ER34121      4030 - 4031 

using IND15.txt, clear 											 ;

label variable ER30001    "1968 INTERVIEW NUMBER"                    ;
label variable ER30002    "PERSON NUMBER                         68" ;
label variable ER32006    "WHETHER SAMPLE OR NONSAMPLE" 			 ;  

label variable ER33801    "2005 INTERVIEW NUMBER" 					 ;                        
label variable ER33802    "SEQUENCE NUMBER                       05" ;        
label variable ER33803    "RELATION TO HEAD                      05" ;  

label variable ER33901    "2007 INTERVIEW NUMBER"                    ;
label variable ER33902    "SEQUENCE NUMBER                       07" ;
label variable ER33903    "RELATION TO HEAD                      07" ;
label variable ER33919    "H61 TYPE HEALTH INSURANCE MENTION 1   07" ;        

label variable ER34001    "2009 INTERVIEW NUMBER"                    ;
label variable ER34002    "SEQUENCE NUMBER                       09" ;
label variable ER34003    "RELATION TO HEAD                      09" ;
label variable ER34022    "H61 TYPE HEALTH INSURANCE MENTION 1   09" ;        


label variable ER34101	  "2011 INTERVIEW NUMBER" 					 ;                         
label variable ER34102    "SEQUENCE NUMBER                       11" ;  
label variable ER34103    "RELATION TO HEAD                      11" ; 
label variable ER34121    "H61 TYPE HEALTH INSURANCE MENTION 1   11" ;        

#delimit cr

//  			#2 Create whether insurance	
note:	`tag'	#2 Create whether insurance	

gen insure07 = .
gen insure09 = .
gen insure11 = .

replace insure07 = 1 if ER33919 != 0
replace insure09 = 1 if ER34022 != 0 
replace insure11 = 1 if ER34121 != 0

replace insure07 = 0 if ER33919 == 0
replace insure09 = 0 if ER34022 == 0
replace insure11 = 0 if ER34121 == 0

replace insure07 = . if ER33919 == 98
replace insure09 = . if ER34022 == 98
replace insure11 = . if ER34121 == 98

replace insure07 = . if ER33919 == 99
replace insure09 = . if ER34022 == 99
replace insure11 = . if ER34121 == 99

tab1 insure07 insure09 insure11, m

drop if insure07 == .
drop if insure09 == .
drop if insure11 == .

//  			#2 Create whether lost insurance	
note:	`tag'	#2 Create whether lost insurance	

gen Linsurei = 0

replace Linsurei = 1 if insure07 == 1 & insure09 == 0
replace Linsurei = 1 if insure07 == 1 & insure11 == 0

tab Linsurei, m

//  			#2 aggregate to family identifier
note:	`tag'	#2 aggregate to family identifier

gen ID68 = ER30001 + ER30002 * 10000 

drop if ER33901 == 0

save "GRR-PSID_hshock_bcollapse", replace

collapse (max) Linsurei, by(ER33901)
rename Linsurei  Linsure

save "GRR-PSID_hshock_acollapse", replace

*	bring back bcollapse and merge aggregate criterion
clear

use GRR-PSID_hshock_bcollapse

merge m:1 ER33901 using "GRR-PSID_hshock_acollapse", keep(using matched) nogen

label 	variable 	Linsure "whether anyone in R's 2007 family lost insurance"
note				Linsure: Missing dropped `tag'
codebook Linsure, m



/*	
detail aggregation

Using 2007 family composition
*/

merge 1:1 ID68 using "GRR-PSID_ehistory", keep(using matched) nogen


//		#7	Save and Close Log
note:	`tag'	#7	Save and Close Log 

save 	"GRR-PSID_hshock", replace 
clear
log close
exit