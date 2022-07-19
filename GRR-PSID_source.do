capture log close
log using GRR-PSID_source, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  	GRR: Infix Source Data
local pgm GRR-PSID_source
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//		#1	Adjust Settings
note:	`tag'	#1	Adjust Settings

set more off, permanently 

//		#2	Infix Individuals
note:	`tag'	#2	Infix Individuals (05,07,09,11) 

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

ER34001      3764 - 3768 
ER34002      3769 - 3770      
ER34003      3771 - 3772

ER34101      3986 - 3990      
ER34102      3991 - 3992      
ER34103      3993 - 3994

using IND15.txt, clear 											 	 ;

label variable ER30001    "1968 INTERVIEW NUMBER"                    ;
label variable ER30002    "PERSON NUMBER                         68" ;
label variable ER32006    "WHETHER SAMPLE OR NONSAMPLE" 			 ;  

label variable ER33801    "2005 INTERVIEW NUMBER" 					 ;                        
label variable ER33802    "SEQUENCE NUMBER                       05" ;        
label variable ER33803    "RELATION TO HEAD                      05" ;  

label variable ER33901    "2007 INTERVIEW NUMBER"                    ;
label variable ER33902    "SEQUENCE NUMBER                       07" ;
label variable ER33903    "RELATION TO HEAD                      07" ;

label variable ER34001    "2009 INTERVIEW NUMBER"                    ;
label variable ER34002    "SEQUENCE NUMBER                       09" ;
label variable ER34003    "RELATION TO HEAD                      09" ;

label variable ER34101	  "2011 INTERVIEW NUMBER" 					 ;                         
label variable ER34102    "SEQUENCE NUMBER                       11" ;  
label variable ER34103    "RELATION TO HEAD                      11" ; 

rename ER33801 ID05 ;
rename ER33901 ID07 ;
rename ER34001 ID09 ;
rename ER34101 ID11 ;

*	Add notes 			;
foreach ind0511 in 	 
	 ER30001 ER30002 
	 ER32006
ID05 ER33802 ER33803 
ID07 ER33902 ER33903 
ID09 ER34002 ER34003 
ID11 ER34102 ER34103 
{						;
note `ind0511': `tag'	;
} 						;
 
*	Select individual heads and spouses who were;
*	PRESENT (sequence==1) and PARTICIPATING across all waves;

keep if (
	(inrange (ER33802,1,20) & inrange (ER33803,10,22))&
	(inrange (ER33902,1,20) & inrange (ER33903,10,22))&
	(inrange (ER34002,1,20) & inrange (ER34003,10,22))&
	(inrange (ER34102,1,20) & inrange (ER34103,10,22))
	) ;
		
*	Drop non-followable individuals* ;
*MAY NEED TO DROP DUPLICATE FAMILIES?;	
	
tab ER32006, m						;
drop if ER32006 == 0 				;

*	Randomly drop family duplicates ;
*	NOTE: while the N for family ID is consistant, the final sample;
*		used for analysis may vary due to split-offs with different;
*		missingness (e.g. families with 2 followable respondents);

set seed 339487731					;

bys ID05  : gen rnd05 = runiform()  ;
bys ID05 (rnd05) : keep if _n == 1 	;

set seed 339487731					;
bys ID07  : gen rnd07 = uniform()  	;
bys ID07 (rnd07) : keep if _n == 1 	;

set seed 339487731					;
bys ID09  : gen rnd09 = uniform()  	;
bys ID09 (rnd09) : keep if _n == 1 	;

set seed 339487731					;
bys ID11  : gen rnd11 = uniform()  	;
bys ID11 (rnd11) : keep if _n == 1  ;

*	Sort by 1968 interview and person number;
sort ER30001 ER30002 				;

*	make unique idenfier ;
gen ID68 = ER30001 + ER30002 * 10000 ;

*	Save IND0511 					;
save "IND0511", replace 			;

clear  								;


//				#3 	Infix and Merge Fam05 	;
note:	`tag'	#3 	Infix and Merge Fam05 	;

#delimit ;

*	Infix 05w ;

infix
S701            2 - 6
S717          121 - 129
S719           91 - 99

using FAM05w.txt, clear ;

label variable  S701       "2005 FAMILY ID" ; 
label variable  S717       "IMP WEALTH W/ EQUITY (WEALTH2) 05"  ;    
label variable  S719       "IMP VALUE ANNUITY/IRA (W22) 05" 	; 

rename S701 ID05 ;

*	Sort by 1968 interview and person number;
sort ID05 ;

*	Add notes ;
foreach FAM05W in 	 
ID05 S717			 
{						;
note `FAM05W': `tag'	;
} 						;

*	Save FAM05W ;
save "FAM05W", replace ;
clear ;


*	Infix 05 ;
#delimit ;
infix
ER25001         1 - 1         
ER25002         2 - 6
ER28078      6717 - 6723

ER28037      6225 - 6231

ER28037D1    6502 - 6511
ER28037D3    6522 - 6531
ER28037D7    6562 - 6571

using FAM05.txt, clear;

*	Label fam05;
*	Identifiers;
label variable  ER25001      "RELEASE NUMBER" 							;                                  
label variable  ER25002      "2005 FAMILY INTERVIEW (ID) NUMBER" 		; 
label variable  ER28078      "2005 CORE/IMMIGRANT FAM WEIGHT NUMBER 1" 	;   

*	Social Class;
label variable  ER28037      "TOTAL FAMILY INCOME-2004" 				;             

*	Expenditures
label variable  ER28037D1    "EDUCATION EXPENDITURE 2004" 				;
label variable  ER28037D3    "HEALTH CARE EXPENDITURE 2005" 			;
label variable  ER28037D7    "HEALTH INSURANCE EXPENDITURE 2005" 		;


*	Rename ID05 ;
rename ER25002 ID05 	;

*	Add notes ;
foreach FAM05 in 	 	
ID05 	ER25001 	ER28078 			
ER28037 ER28037D1	ER28037D3	ER28037D7		
{						;
note `FAM05': `tag'		;
} 						;

*	Sort and save;

sort ID05 ;
save "FAM05C", replace ;

*	Merge fam05 ;
merge 1:1 ID05 using "FAM05W", keep(using matched) 	; 
drop _merge 										; 
save "FAM05", replace 								; 

*	Merge fam05 with ind0511 by id05 				;
merge 1:1 ID05 using "IND0511", keep(using matched) ;
drop _merge 										;
save "GRR-PSID_source", replace 					;

clear												; 

//				#4 Infix and Merge Fam07 ;
note:	`tag'	#4 Infix and Merge Fam07 ;

*	Infix 07w ;

infix
S801            2 - 6

S817          121 - 129
S819           91 - 99

using FAM07w.txt, clear;

*	Label fam07w													;
*	Identifiers														;                                
label variable  S801       "2007 FAMILY ID" ;  

*	Health Care														;
label variable S817       "IMP WEALTH W/ EQUITY (WEALTH2) 07"       ;
label variable  S819       "IMP VALUE ANNUITY/IRA (W22) 07" 		;    

*	Rename ID07 ;
rename S801 ID07 ;

*	Add notes ;
foreach FAM07w in 	 	
ID07 S817	
{							;
note `FAM07w': `tag'		;
} 							;

*	Sort and save;
sort ID07 			   ;
save "FAM07w", replace ;
clear                  ; 

*	Infix and merge 07 ;
infix 
ER36001         1 - 1         
ER36002         2 - 6

ER37587      2887 - 2887
ER37755      3270 - 3270
ER37987      3768 - 3768

ER37808      3405 - 3405
ER37814      3418 - 3418
ER37827      3445 - 3445 
ER37828      3446 - 3446      
ER37829      3447 - 3447      
ER37830      3448 - 3448 
ER37831      3449 - 3449     
ER37832      3450 - 3450
ER37874      3536 - 3536
 
ER38040      3903 - 3903
ER38046      3916 - 3916
ER38059      3943 - 3943      
ER38060      3944 - 3944      
ER38061      3945 - 3945 
ER38062      3946 - 3946      
ER38063      3947 - 3947      
ER38064      3948 - 3948
ER38106      4034 - 4034
 
ER37889      3566 - 3566
ER37895      3579 - 3579
ER37908      3606 - 3606 
ER37909      3607 - 3607     
ER37910      3608 - 3608     
ER37911      3609 - 3609 
ER37912      3610 - 3610      
ER37913      3611 - 3611
ER37955      3697 - 3697

ER38121      4064 - 4064
ER38127      4077 - 4077
ER38140      4104 - 4104      
ER38141      4105 - 4105      
ER38142      4106 - 4106 
ER38143      4107 - 4107      
ER38144      4108 - 4108      
ER38145      4109 - 4109
ER38187      4195 - 4195	  
	  
ER36144       284 - 284
ER36134       266 - 266
ER36136       268 - 268  
ER36402       766 - 766 
ER36392       748 - 748
ER36394       750 - 750
	  
ER36165       358 - 359	  
ER40616      7108 - 7109      
ER40617      7110 - 7111	  
ER36423       840 - 841	
ER40523      6938 - 6939      
ER40524      6940 - 6941	
		  
ER41027      8205 - 8211	  
ER41037      8630 - 8631  
ER41038      8632 - 8633  

ER41032      8622 - 8622	  
ER36017        41 - 43   
ER36019        45 - 47      
ER36018        44 - 44
ER40564      7006 - 7006      
ER40565      7007 - 7007
ER40566      7008 - 7008 
ER40567      7009 - 7009        
ER40568      7010 - 7010
ER40569      7011 - 7011
ER41039      8634 - 8634
ER36020        48 - 49	  
ER40471      6836 - 6836        
ER40472      6837 - 6837        
ER40473      6838 - 6838 
ER40474      6839 - 6839        
ER40475      6840 - 6840
	  
ER36028        61 - 61
ER36109       223 - 224
ER36110       225 - 226         
ER36111       227 - 228
ER36367       705 - 706         
ER36368       707 - 708         
ER36369       709 - 710
ER40409      6727 - 6727
ER41027D3    8502 - 8511
ER41027D7    8542 - 8551
ER41027D1    8482 - 8491 

using FAM07.txt, clear 
;

*	Label FAM07;
*	Identifiers;
label variable ER36001    "RELEASE NUMBER"                           	;
label variable ER36002    "2007 FAMILY INTERVIEW (ID) NUMBER"        	;

*	Retirement, current;
label variable ER37587    "W21 WTR IRA/PRIVATE ANNUITY"              	;
label variable ER37755    "P16 HOW BENEFIT FIGURED"                  	;
label variable ER37987    "P86 HOW BENEFIT FIGURED"                  	;

*	Retirement, current;
label variable ER37808    "P46 TYPE PREV PENSION-#1"                 	;
label variable ER37814    "P48 WHAT DID W/PREV PNSN-#1"              	;
label variable ER37827    "P52 STATUS PREV PNSN MEN1-#1"             	;
label variable ER37828    "P52 STATUS PREV PNSN MEN2-#1"             	;
label variable ER37829    "P52 STATUS PREV PNSN MEN3-#1"             	;
label variable ER37830    "P52 STATUS PREV PNSN MEN4-#1"             	;
label variable ER37831    "P52 STATUS PREV PNSN MEN5-#1"             	;
label variable ER37832    "P52 STATUS PREV PNSN MEN6-#1"             	;
label variable ER37874    "P64 WHAT DID W/PREV PNSN-#1"              	;

label variable ER38040    "P116 TYPE PREV PENSION-#1"                	;
label variable ER38046    "P118 WHAT DID W/PREV PNSN-#1"             	;
label variable ER38059    "P122 STATUS PREV PNSN MEN1-#1"            	;
label variable ER38060    "P122 STATUS PREV PNSN MEN2-#1"            	;
label variable ER38061    "P122 STATUS PREV PNSN MEN3-#1"            	;
label variable ER38062    "P122 STATUS PREV PNSN MEN4-#1"            	;
label variable ER38063    "P122 STATUS PREV PNSN MEN5-#1"            	;
label variable ER38064    "P122 STATUS PREV PNSN MEN6-#1"            	;
label variable ER38106    "P134 WHAT DID W/PREV PNSN-#1"             	;

label variable ER37889    "P46 TYPE PREV PENSION-#2"                 	;
label variable ER37895    "P48 WHAT DID W/PREV PNSN-#2"              	;
label variable ER37908    "P52 STATUS PREV PNSN MEN1-#2"             	;
label variable ER37909    "P52 STATUS PREV PNSN MEN2-#2"             	;
label variable ER37910    "P52 STATUS PREV PNSN MEN3-#2"             	;
label variable ER37911    "P52 STATUS PREV PNSN MEN4-#2"             	;
label variable ER37912    "P52 STATUS PREV PNSN MEN5-#2"             	;
label variable ER37913    "P52 STATUS PREV PNSN MEN6-#2"             	;
label variable ER37955    "P64 WHAT DID W/PREV PNSN-#2"              	;

label variable ER38121    "P116 TYPE PREV PENSION-#2"                	;
label variable ER38127    "P118 WHAT DID W/PREV PNSN-#2"             	;
label variable ER38140    "P122 STATUS PREV PNSN MEN1-#2"            	;
label variable ER38141    "P122 STATUS PREV PNSN MEN2-#2"            	;
label variable ER38142    "P122 STATUS PREV PNSN MEN3-#2"            	;
label variable ER38143    "P122 STATUS PREV PNSN MEN4-#2"            	;
label variable ER38144    "P122 STATUS PREV PNSN MEN5-#2"            	;
label variable ER38145    "P122 STATUS PREV PNSN MEN6-#2"            	;
label variable ER38187    "P134 WHAT DID W/PREV PNSN-#2"             	;

*	Labor Market;
label variable ER36144    "BC27 BELONG UNION? (HD-E)"                	;
label variable ER36134    "BC22 WORK SELF/OTR?--JOB 1"               	;
label variable ER36136    "BC24 WORK FOR GOVT?--JOB 1"               	;
label variable ER36402    "DE27 BELONG UNION? (WF-E)"               	;
label variable ER36392    "DE22 WORK SELF/OTR?--JOB 1"             	  	;
label variable ER36394    "DE24 WORK FOR GOVT?--JOB 1"              	;

*	Labor Market History;
label variable  ER36165      "BC41 YRS PRES EMP (H-E)" 					;  
label variable  ER40616      "L70 #YRS WRKD SINCE 18-HD" 				;                       
label variable  ER40617      "L71 #YR WRKED FULLTIME-HD" 				; 
label variable  ER36423      "DE41 YRS PRES EMP (W-E)" 					;   
label variable  ER40523      "K70 #YRS WRKD SINCE 18-WF" 				;                       
label variable  ER40524      "K71 #YR WRKED FULLTIME-WF" 				;  

*	Social Class;
label variable ER41027    "TOTAL FAMILY INCOME-2006"                 	;
label variable ER41037    "COMPLETED ED-HD"                          	;
label variable ER41038    "COMPLETED ED-WF"   	                        ;

*	Demographic;
label variable ER41032    "CURRENT REGION"                           ;
label variable ER36017    "AGE OF HEAD"                              ;
label variable ER36019    "AGE OF WIFE"                              ;
label variable ER36018    "SEX OF HEAD"                              ;
label variable ER40564    "L39 SPANISH DESCENT-HEAD"           		 ;
label variable ER40565    "L40 RACE OF HEAD-MENTION 1"               ;
label variable ER40566    "L40 RACE OF HEAD-MENTION 2"               ;
label variable ER40567    "L40 RACE OF HEAD-MENTION 3"               ;
label variable ER40568    "L40 RACE OF HEAD-MENTION 4"               ;
label variable ER40569    "L41 ETHNIC GROUP-HD"                      ;
label variable ER41039    "MARITAL STATUS-GENERATED"   	    	     ;
label variable ER36020    "# CHILDREN IN FU"           		         ;
label variable ER40471    "K39 SPANISH DESCENT-WIFE"                 ;
label variable ER40472    "K40 RACE OF WIFE-MENTION 1"               ;
label variable ER40473    "K40 RACE OF WIFE-MENTION 2"               ;
label variable ER40474    "K40 RACE OF WIFE-MENTION 3"               ;
label variable ER40475    "K40 RACE OF WIFE-MENTION 4"               ;


*	Decision Conditions;
label variable ER36028    	 "A19 OWN/RENT OR WHAT"                     ;
label variable ER36109   	 "BC1 EMPLOYMENT STATUS-1ST MENTION"        ;
label variable ER36110       "BC1 EMPLOYMENT STATUS-2ND MENTION"        ;
label variable ER36111       "BC1 EMPLOYMENT STATUS-3RD MENTION"        ;
label variable ER36367       "DE1 EMPLOYMENT STATUS-1ST MENTION"        ;
label variable ER36368       "DE1 EMPLOYMENT STATUS-2ND MENTION"        ;
label variable ER36369       "DE1 EMPLOYMENT STATUS-3RD MENTION"        ;
label variable ER40409    	 "H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS" 	;
label variable  ER41027D3    "HEALTH CARE EXPENDITURE 2007" 		 	;    
label variable  ER41027D7    "HEALTH INSURANCE EXPENDITURE 2007" 		;   
label variable  ER41027D1    "EDUCATION EXPENDITURE 2006" 				; 

rename ER36002 ID07 ;

*	Add notes ;
foreach FAM07c in 	 	
ID07  			
ER36001			

ER37987 ER37755 ER37587 

ER37808 ER37814 ER37827
ER37828 ER37829 ER37830
ER37831 ER37832 ER37874
ER38040 ER38046 ER38059
ER38060 ER38061 ER38062
ER38064 ER38063 ER38106
ER37889 ER37895 ER37908
ER37909 ER37910 ER37911
ER37912 ER37913 ER37955
ER38121 ER38127 ER38140
ER38141 ER38142 ER38143
ER38144 ER38145 ER38187 

ER36144 ER36134 ER36136 	
ER36402 ER36392	ER36394		

ER41027 ER41037	

ER41032 ER36017 ER36018 
ER40564 ER40565 ER40569 
ER41039 ER36020			

ER36028 ER36109	ER40409
ER41027D1		ER41027D7		
ER41027D3				
{							;
note `FAM07c': `tag'		;
} 							;

*	Sort, merge and save;
sort ID07 													;
merge 1:1 ID07 using "FAM07w", keep(using matched)  		;
	drop _merge 											; 
	save "FAM07", replace 									;

*	Merge fam07 with ind0511 by id07 						;
merge 1:1 ID07 using "GRR-PSID_source", keep(using matched) ;
drop _merge 												;

save "GRR-PSID_source", replace 							;

clear 														;

//		#5	Infix and Merge Fam09 							;
note:	`tag'	#5 	Infix and Merge Fam09 					;

*	Infix FAM09 											;
infix 
ER42001         1 - 1           
ER42002         2 - 6

ER43621      2951 - 2951
ER43580      2865 - 2873
ER43622      2952 - 2960

ER42029        62 - 62
ER46382      6680 - 6680
ER46971D1    8400 - 8409
ER46971D3    8420 - 8429 
ER46971D7    8460 - 8469

ER46778      7438 - 7441
ER46799      7491 - 7494
ER46666      7193 - 7194
ER46677      7256 - 7257

using FAM09.txt, clear										;
															

*	Label FAM09;
*	Identifiers;
label variable ER42001    "RELEASE NUMBER"                          	 ;
label variable ER42002    "2009 FAMILY INTERVIEW (ID) NUMBER"       	 ;
	
*	Retirement;
label variable ER43621    	 "W48 WTR CASHED PNSN/ANNTY/IRA"        	;
label variable  ER43580      "W22 VALUE OF IRA/ANNUITY" 				; 
label variable  ER43622      "W49 VALUE withdrew PENSION/ANNUITY/IRA" 	;     

*	Decision Conditions;
label variable ER42029   	"A19 OWN/RENT OR WHAT"                  	;
label variable ER46382   	"H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS"   ;
label variable ER46971D1    "EDUCATION EXPENDITURE 2008" 				; 
label variable ER46971D3    "HEALTH CARE EXPENDITURE 2009" 				;                    
label variable ER46971D7    "HEALTH INSURANCE EXPENDITURE 2009" 		;     

label variable ER46778    "HEAD UNEMPLOYMENT WEEKS-2008"             ;
label variable ER46799    "WIFE UNEMPLOYMENT WEEKS-2008"             ;
label variable ER46666    "BC8 WEEKS UNEMPLOYED IN 2007 (HD)"        ;
label variable ER46677    "DE8 WEEKS UNEMPLOYED IN 2007 (WF)"        ;

rename ER42002 ID09		;
sort ID09 				;

*	Add notes 			;
foreach FAM09 in 	 	
ID09 		ER42001				

ER43621 ER43580	ER43622		

ER42029		ER46382	
ER46971D1	ER46971D3
ER46971D7	

ER46778     ER46799
ER46666		ER46677
		
{						;
note `FAM09': `tag'		;
} 						;

save "FAM09", replace ;

*	Merge fam09 with ind0511 by id09 						;
merge 1:1 ID09 using "GRR-PSID_source", keep(using matched) ;
drop _merge 												;

save "GRR-PSID_source", replace 							;

clear			; 

*	Infix FAM11 ;
infix
ER47301         1 - 1         
ER47302         2 - 6

ER48966      3030 - 3030
ER48905      2902 - 2910
ER48967      3031 - 3039

ER47329        62 - 62
ER51743      6701 - 6701
ER52395D1    8516 - 8525
ER52395D3    8536 - 8545      
ER52395D7    8576 - 8585

ER52186      7516 - 7519 
ER52207      7569 - 7572
ER52067      7264 - 7265
ER52078      7327 - 7328 

using FAM11.txt, clear
;

*	Label FAM11;
*	Identifiers;
label variable  ER47301      "RELEASE NUMBER" 							;                                  
label variable  ER47302      "2011 FAMILY INTERVIEW (ID) NUMBER" 		; 

*	Retirement;
label variable  ER48966      "W48 WTR CASHED PNSN/ANNTY/IRA" 			;                     
label variable  ER48905      "W22 VALUE OF IRA/ANNUITY" 				;    
label variable  ER48967      "W49 VALUE withdrew PENSION/ANNUITY/IRA" 	;   

*	Decision Conditions
label variable  ER47329      "A19 OWN/RENT OR WHAT" 					;              
label variable  ER51743      "H60 WTR FU MEMBER W/HLTH INS LAST 2 YRS" 	;     
label variable  ER52395D1    "EDUCATION EXPENDITURE 2010"				;  
label variable  ER52395D3    "HEALTH CARE EXPENDITURE 2011" 			;                    
label variable  ER52395D7    "HEALTH INSURANCE EXPENDITURE 2011" 		;   


label variable  ER52186      "HEAD UNEMPLOYMENT WEEKS-2010" 			;         
label variable  ER52207      "WIFE UNEMPLOYMENT WEEKS-2010" 			;     
label variable  ER52067      "BC8 WEEKS UNEMPLOYED IN 2009 (HD)" 		;      
label variable  ER52078      "DE8 WEEKS UNEMPLOYED IN 2009 (WF)" 		; 

rename ER47302 ID11	;
sort ID11 			;

*	Add notes 		;
foreach FAM11 in 	 	
ID11 ER47301				

ER48966 ER48905	ER48967  			

ER47329 	ER51743		ER52395D1	
ER52395D3	ER52395D7	

ER52186		ER52207
ER52067		ER52078

{						;
note `FAM11': `tag'		;
}						;

save "FAM11", replace 	;

*	Merge fam11 with ind0511 by id11 ;
merge 1:1 ID11 using "GRR-PSID_source", keep(using matched) ;
drop _merge ;

#delimit cr

//		#7	Save and Close Log
note:	`tag'	#7	Save and Close Log 

save 	"GRR-PSID_source", replace 
clear
log close
exit
