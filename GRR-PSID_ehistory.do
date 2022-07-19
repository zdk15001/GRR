capture log close
log using GRR-PSID_ehistory, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm GRR-PSID_ehistory
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 infix individuals
note:	`tag'	#1 infix individuals

#delimit ;

infix
ER30000              1 - 1           
ER30001              2 - 5
ER30002              6 - 8     

ER30283              9 - 12          
ER30284             13 - 14          
ER30285             15 - 15    
ER30293             16 - 16          

ER30313             17 - 20          
ER30314             21 - 22    
ER30315             23 - 23          
ER30323             24 - 24          

ER30343             25 - 28    
ER30344             29 - 30          
ER30345             31 - 31          
ER30353             32 - 32    

ER30373             33 - 36          
ER30374             37 - 38          
ER30375             39 - 39    
ER30382             40 - 40          

ER30399             41 - 44          
ER30400             45 - 46    
ER30401             47 - 48          
ER30411             49 - 49          

ER30429             50 - 53    
ER30430             54 - 55          
ER30431             56 - 57          
ER30441             58 - 58    

ER30463             59 - 62          
ER30464             63 - 64          
ER30465             65 - 66    
ER30474             67 - 67          

ER30498             68 - 71          
ER30499             72 - 73    
ER30500             74 - 75          
ER30509             76 - 76          

ER30535             77 - 80    
ER30536             81 - 82          
ER30537             83 - 84          
ER30545             85 - 85    

ER30570             86 - 89          
ER30571             90 - 91          
ER30572             92 - 93    
ER30580             94 - 94          

ER30606             95 - 98          
ER30607             99 - 100   
ER30608            101 - 102         
ER30616            103 - 103         

ER30642            104 - 108   
ER30643            109 - 110         
ER30644            111 - 112         
ER30653            113 - 113   

ER30689            114 - 117         
ER30690            118 - 119         
ER30691            120 - 121   
ER30699            122 - 122         

ER30733            123 - 126         
ER30734            127 - 128   
ER30735            129 - 130         
ER30744            131 - 131         

ER30806            132 - 136   
ER30807            137 - 138         
ER30808            139 - 140         
ER30816            141 - 141   

ER33101            142 - 146         
ER33102            147 - 148         
ER33103            149 - 150   
ER33111            151 - 151         

ER33201            152 - 156         
ER33202            157 - 158   
ER33203            159 - 160         
ER33211            161 - 161         

ER33301            162 - 165   
ER33302            166 - 167         
ER33303            168 - 169         
ER33311            170 - 170   

ER33401            171 - 175         
ER33402            176 - 177         
ER33403            178 - 179   
ER33411            180 - 180         

ER33501            181 - 185         
ER33502            186 - 187   
ER33503            188 - 189         
ER33512            190 - 190         

ER33601            191 - 194   
ER33602            195 - 196         
ER33603            197 - 198         
ER33612            199 - 199   

ER33701            200 - 204         
ER33702            205 - 206         
ER33703            207 - 208   
ER33712            209 - 209            

using ehistory.txt, clear 
;

//  			#2 Apply Labels ;
note:	`tag'	#2 Apply Labels ;

label variable ER30000       "RELEASE NUMBER"                           ;
label variable ER30001       "1968 INTERVIEW NUMBER"                    ;
label variable ER30002       "PERSON NUMBER                         68" ;

label variable ER30283       "1979 INTERVIEW NUMBER"                    ;
label variable ER30284       "SEQUENCE NUMBER                       79" ;
label variable ER30285       "RELATIONSHIP TO HEAD                  79" ;
label variable ER30293       "EMPL STATUS                           79" ;

label variable ER30313       "1980 INTERVIEW NUMBER"                    ;
label variable ER30314       "SEQUENCE NUMBER                       80" ;
label variable ER30315       "RELATIONSHIP TO HEAD                  80" ;
label variable ER30323       "1980 EMPL STATUS                      80" ;

label variable ER30343       "1981 INTERVIEW NUMBER"                    ;
label variable ER30344       "SEQUENCE NUMBER                       81" ;
label variable ER30345       "RELATIONSHIP TO HEAD                  81" ;
label variable ER30353       "EMPLOYMENT STAT                       81" ;

label variable ER30373       "1982 INTERVIEW NUMBER"                    ;
label variable ER30374       "SEQUENCE NUMBER                       82" ;
label variable ER30375       "RELATIONSHIP TO HEAD                  82" ;
label variable ER30382       "EMPLOYMENT STATUS                     82" ;

label variable ER30399       "1983 INTERVIEW NUMBER"                    ;
label variable ER30400       "SEQUENCE NUMBER                       83" ;
label variable ER30401       "RELATIONSHIP TO HEAD                  83" ;
label variable ER30411       "EMPLOYMENT STATUS                     83" ;

label variable ER30429       "1984 INTERVIEW NUMBER"                    ;
label variable ER30430       "SEQUENCE NUMBER                       84" ;
label variable ER30431       "RELATIONSHIP TO HEAD                  84" ;
label variable ER30441       "EMPLOYMENT STAT                       84" ;

label variable ER30463       "1985 INTERVIEW NUMBER"                    ;
label variable ER30464       "SEQUENCE NUMBER                       85" ;
label variable ER30465       "RELATIONSHIP TO HEAD                  85" ;
label variable ER30474       "EMPLOYMENT STAT                       85" ;

label variable ER30498       "1986 INTERVIEW NUMBER"                    ;
label variable ER30499       "SEQUENCE NUMBER                       86" ;
label variable ER30500       "RELATIONSHIP TO HEAD                  86" ;
label variable ER30509       "EMPLOYMENT STAT                       86" ;

label variable ER30535       "1987 INTERVIEW NUMBER"                    ;
label variable ER30536       "SEQUENCE NUMBER                       87" ;
label variable ER30537       "RELATIONSHIP TO HEAD                  87" ;
label variable ER30545       "EMPLOYMENT STAT                       87" ;

label variable ER30570       "1988 INTERVIEW NUMBER"                    ;
label variable ER30571       "SEQUENCE NUMBER                       88" ;
label variable ER30572       "RELATION TO HEAD                      88" ;
label variable ER30580       "EMPLOYMENT STAT-IND                   88" ;

label variable ER30606       "1989 INTERVIEW NUMBER"                    ;
label variable ER30607       "SEQUENCE NUMBER                       89" ;
label variable ER30608       "RELATION TO HEAD                      89" ;
label variable ER30616       "EMPLOYMENT STAT-IND                   89" ;

label variable ER30642       "1990 INTERVIEW NUMBER"                    ;
label variable ER30643       "SEQUENCE NUMBER                       90" ;
label variable ER30644       "RELATION TO HEAD                      90" ;
label variable ER30653       "EMPLOYMENT STAT-IND                   90" ;

label variable ER30689       "1991 INTERVIEW NUMBER"                    ;
label variable ER30690       "SEQUENCE NUMBER                       91" ;
label variable ER30691       "RELATION TO HEAD                      91" ;
label variable ER30699       "EMPLOYMENT STAT-IND                   91" ;

label variable ER30733       "1992 INTERVIEW NUMBER"                    ;
label variable ER30734       "SEQUENCE NUMBER                       92" ;
label variable ER30735       "RELATION TO HEAD                      92" ;
label variable ER30744       "EMPLOYMENT STAT                       92" ;

label variable ER30806       "1993 INTERVIEW NUMBER"                    ;
label variable ER30807       "SEQUENCE NUMBER                       93" ;
label variable ER30808       "RELATION TO HEAD                      93" ;
label variable ER30816       "EMPLOYMENT STATUS                     93" ;

label variable ER33101       "1994 INTERVIEW NUMBER"                    ;
label variable ER33102       "SEQUENCE NUMBER                       94" ;
label variable ER33103       "RELATION TO HEAD                      94" ;
label variable ER33111       "EMPLOYMENT STATUS                     94" ;

label variable ER33201       "1995 INTERVIEW NUMBER"                    ;
label variable ER33202       "SEQUENCE NUMBER                       95" ;
label variable ER33203       "RELATION TO HEAD                      95" ;
label variable ER33211       "EMPLOYMENT STATUS                     95" ;

label variable ER33301       "1996 INTERVIEW NUMBER"                    ;
label variable ER33302       "SEQUENCE NUMBER                       96" ;
label variable ER33303       "RELATION TO HEAD                      96" ;
label variable ER33311       "EMPLOYMENT STATUS                     96" ;

label variable ER33401       "1997 INTERVIEW NUMBER"                    ;
label variable ER33402       "SEQUENCE NUMBER                       97" ;
label variable ER33403       "RELATION TO HEAD                      97" ;
label variable ER33411       "EMPLOYMENT STATUS                     97" ;

label variable ER33501       "1999 INTERVIEW NUMBER"                    ;
label variable ER33502       "SEQUENCE NUMBER                       99" ;
label variable ER33503       "RELATION TO HEAD                      99" ;
label variable ER33512       "EMPLOYMENT STATUS                     99" ;

label variable ER33601       "2001 INTERVIEW NUMBER"                    ;
label variable ER33602       "SEQUENCE NUMBER                       01" ;
label variable ER33603       "RELATION TO HEAD                      01" ;
label variable ER33612       "EMPLOYMENT STATUS                     01" ;

label variable ER33701       "2003 INTERVIEW NUMBER"                    ;
label variable ER33702       "SEQUENCE NUMBER                       03" ;
label variable ER33703       "RELATION TO HEAD                      03" ;
label variable ER33712       "EMPLOYMENT STATUS                     03" ;

//  			#3 create unemployment count ;
note:	`tag'	#3 create unemployment count ;

egen unemp97 = 
anycount(
ER30293
ER30323
ER30353
ER30382
ER30411
ER30441
ER30474
ER30509
ER30545
ER30580
ER30616
ER30653
ER30699
ER30744
ER30816
ER33111
ER33211
ER33311
ER33411), 
values(2 3)  ;


egen unemp05c = 
anycount(
ER33512
ER33612
ER33712
), 
values(2 3)  ;

*	each unemployment after 97 counts twice	;
gen unemp05 = unemp05c*2	;

gen unemp = unemp97 + unemp05 	;

label 	variable 	unemp "count of unemployed observations, weighted for biannual sampling"	;
note 	unemp: 	Missing values are included as 0 `tag'	;


***	As a proportion ;

egen emp97 = 
anycount(
ER30293
ER30323
ER30353
ER30382
ER30411
ER30441
ER30474
ER30509
ER30545
ER30580
ER30616
ER30653
ER30699
ER30744
ER30816
ER33111
ER33211
ER33311
ER33411), 
values(1 2 3 4 5 6 7)  ;

egen emp05c = 
anycount(
ER33512
ER33612
ER33712
), 
values(1 2 3 4 5 6 7)  ;

*	each employment after 97 counts twice	;
gen emp05 = emp05c*2	;

gen emp = emp97 + emp05 	;

label 	variable 	emp "count of employment status observations, weighted for biannual sampling"	;
note 	emp: 	no missing `tag'	;

*	unemp as proportion ;
gen unempP = unemp / emp  ;

replace unempP = 0 if unempP == . ;

label 	variable 	unempP "proportion of observations where unemployed, weighted for biannual sampling"	;
note 	unempP: 	Missing in reference `tag'	;

//  			#4 make unique identifier, keep neccesary, save and merge	;
note:	`tag'	#4 make unique identifier, keep neccesary, save and merge	;


gen ID68 = ER30001 + ER30002 * 10000 ;

keep ID68 unemp unempP	;

save "GRR-PSID_ehistory_unmerged", replace	;

merge 1:1 ID68 using "GRR-PSID_source", keep(using matched) ;

#delimit cr

//  			#5 Clean Employment Tenure
note:	`tag'	#5 Clean Employment Tenure

tab1 ER36165 ER36423, m

recode ER36165 (98 = .) (99 = .), gen(Htenure)
recode ER36423 (98 = .) (99 = .), gen(Stenure)

tab1 Htenure Stenure

gen tenure = .
replace tenure = Htenure if ER33903 == 10
replace tenure = Stenure if ER33903 == 20
replace tenure = Stenure if ER33903 == 22
tab tenure, m

drop if tenure == .

label 	variable 	tenure "years R has worked with current employer"
note				tenure: Missing dropped `tag'
codebook tenure, m


//  			#6 Clean Years Worked since 18
note:	`tag'	#6 Clean Years Worked since 18


tab1 ER40616 ER40523, m

recode ER40616  (99 = .), gen(Hworked)
recode ER40523  (99 = .), gen(Sworked)

tab1 Hworked Sworked

gen worked = .
replace worked = Hworked if ER33903 == 10
replace worked = Sworked if ER33903 == 20
replace worked = Sworked if ER33903 == 22
tab worked, m

drop if worked == .

label 	variable 	worked "years worked since 18"
note				worked: Missing dropped; perhaps should impute `tag'
codebook worked, m


//  			#7 Clean Years Worked FT since 18
note:	`tag'	#7 Clean Years Worked FT since 18


tab1 ER40617 ER40524, m

recode ER40617  (99 = .), gen(HworkedFT)
recode ER40524  (99 = .), gen(SworkedFT)

tab1 HworkedFT SworkedFT

gen workedFT = .
replace workedFT = HworkedFT if ER33903 == 10
replace workedFT = SworkedFT if ER33903 == 20
replace workedFT = SworkedFT if ER33903 == 22
tab workedFT, m

drop if workedFT == .

label 	variable 	worked "years worked since 18"
note				worked: Missing dropped; perhaps should impute `tag'
codebook workedFT, m

//  			#8 Save Data and Close Log
note:	`tag'	#8 Save Data and Close Log


save	 "GRR-PSID_ehistory", replace 

log close
exit
