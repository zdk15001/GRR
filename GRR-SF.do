capture log close
log using GRR-SF, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: task description
local pgm GRR-SF
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  			#1 Load Data and Settings
use GRR-PSID
note:	`tag'	#1 Load Data and Settings


//  			#2 Descriptive Statistics; table 1
note:	`tag'	#2 Descriptive Statistics; table 1

*	Descriptive Statistics for table 1

sum 													///
rent 		unemp2	Hloss 		chealthk	hardship 	/// GR shocks
chealthk	cunemp	LinsureE							///	GR continuous
BHinsure 	own 	ceduk		bHown					///	Other triggers
Rplan 		retire 	cashout 							/// RPlans and decision
SES	 		cedu12 	Bincome 	Bwealth					///	SES
nhwhite 	cohort10 			female					///	Demographic 
tenure 		workedFT									/// Employment history
union 		self 	gov 								/// Exclusion restrictions
[aw=ER28078]

tab1 formula family region [aw=ER28078],  m 

sum  													///
rent 		unemp2	Hloss 		chealthk	hardship 	/// GR shocks
chealthk	cunemp	LinsureE							///	GR continuous
BHinsure 	own 	ceduk		bHown					///	Other triggers
Rplan 		retire 	cashout 							/// RPlans and decision
SES	 		cedu12 	Bincome 	Bwealth					///	SES
nhwhite 	cohort10 			female					///	Demographic 
tenure 		workedFT									/// Employment history
union 		self 	gov 								/// Exclusion restrictions
if Rplan == 1 [aw=ER28078]

tab1 formula family region if Rplan == 1 [aw=ER28078], m 

sum  													///
rent 		unemp2	Hloss 		chealthk	hardship 	/// GR shocks
chealthk	cunemp	LinsureE							///	GR continuous
BHinsure 	own 	ceduk		bHown					///	Other triggers
Rplan 		retire 	cashout 							/// RPlans and decision
SES	 		cedu12 	Bincome 	Bwealth					///	SES
nhwhite 	cohort10 			female					///	Demographic 
tenure 		workedFT									/// Employment history
union 		self 	gov 								/// Exclusion restrictions
if Rplan == 0 [aw=ER28078]

tab1 formula family region if Rplan == 0 [aw=ER28078], m 

//	tests for group differences
//	tests for group differences

foreach continuous in 	 								///
chealthk 	ceduk 	 									///
cedu12		Bincome	Bwealth		SES						///
cohort10												///
tenure workedFT											///
{						
ttest `continuous', by(Rplan)
} 

foreach categorical in 	 								///
Hloss	own	rent	unemp2	LinsureE hardship			///
family	region nhwhite 		female						///
self union gov											///
{						
tab `categorical' Rplan, chi2
} 

//  			#3 formula and withdrawal - figure 1
note:	`tag'	#3 formula and withdrawal - figure 1


graph bar cashout if formula != 1, over(formula,					/// 	
	relabel (1 "Defined Benefit"		2 "Defined Contribution" 	///
			 3 "Individual Market Fund" 4 "Hybrid"))				///
	ytitle	(  "Probability of Early Withdrawal")			
graph export "Figure1.pdf", replace

logit cashout i.formula
listcoef

tab cashout formula, chi2 column


//  			#4 rplan - table 2
note:	`tag'	#4 rplan - table 2

*	presence of retirement plan
probit Rplan	 								///
i.self i.union i.gov 							///		
c.SESiw c.cedu12								///
c.tenure c.workedFT 							///
ib2.family female i.nhwhite i.region c.cohort10 

* predicted probabilities

margins, at(SES=(-2(1)2) cedu12 = (0(4)4)) 
mlincom (3-8)
mlincom (1-10)

* 	retirement plan formula
mprobit formula 								///
i.self i.union i.gov 							///		
c.SESiw c.cedu12								///
c.tenure c.workedFT								///
ib2.family female i.nhwhite i.region c.cohort10 if Rplan == 1, base(2)

* predicted probabilities
margins, at(SES=(0(1)1))  predict(outcome(IDC))
margins, at(SES=(0(1)1))  predict(outcome(Hybrid))

margins, at(SES=(-2(4)2) cedu12 = (0(4)4))  predict(outcome(DB))
margins, at(SES=(-2(4)2) cedu12 = (0(4)4))  predict(outcome(Hybrid))

margins, at(SES=(0) cedu12 = (0(4)4))  predict(outcome(Hybrid)) post 
test _b[1._at] = _b[2._at]


//  			#5 hardships - table 3
note:	`tag'	#5 hardships - table 3

probit LinsureE									///
	c.SESiw c.cedu12 							///
	c.tenure c.workedFT 						///
	ib2.family i.nhwhite i.female i.region c.cohort10 if BHinsure == 1
margins, at(SES=(-1(2)1) cedu12 = (0(4)4)) 
mlincom (1-4)

probit rent										///
	c.SESiw c.cedu12 							///
	c.tenure c.workedFT							///
	ib2.family i.nhwhite i.female i.region c.cohort10 if bHown 	 == 1
margins, at(SES=(-1(2)1) cedu12 = (0(4)4))
mlincom (1-4)

probit unemp2									///
	c.SESiw c.cedu12							///
	c.tenure c.workedFT							///
	ib2.family i.nhwhite i.female i.region c.cohort10 if Blf 	 == 1
margins, at(SES=(-1(2)1) cedu12 = (0(4)4)) 
mlincom (1-4)

//  			#6 early withdrawal - table 4
note:	`tag'	#6 early withdrawal - table 4

*	partial correlation coefficeint

foreach instrument in 	 									///
self union gov												///
{						
pcorr `instrument' 											///
cashout 													///
i.formula 													///*Architecture*/
i.rent 		c.HlossE 	i.unemp2							///*Hardship*/
c.ceduk		i.own											///*OTriggers*/
c.cedu12 	c.SESiw											///*SES*/	
c.tenure c.workedFT											///*E History*/ 	
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	//*Demo*/	
} 


*	wald test for instruments

#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 
i.formula	
i.LinsureE i.rent i.unemp2									/*hardship*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw	 c.cedu12											/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr

test 1.self 1.union 1.gov


*	model 1
#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 
i.formula	
i.LinsureE i.rent i.unemp2									/*hardship*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw	 c.cedu12											/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr

margins, at(cedu12=(0(4)4))


predict p1, xb
generate phi = (1/sqrt(2*_pi))*exp(-(p1^2/2)) /*standardize it*/
generate capphi = norm(p1)
generate invmills = phi/capphi
regress depvar indepvar invmills

*	model 2
#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 
i.formula	
i.hardship													/*hardship*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw		c.cedu12										/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr

*	model 3
#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 
i.formula	
i.hardship##c.cedu12										/*Interaction*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw														/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr


*	probit model 2 for interpretation in results
#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 
i.hardship													/*hardship*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw		c.cedu12										/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr

margins, at(cedu12=(0(4)4))
margins, at(hardship=(0(1)1))
mlincom (1-2)


*	probit model 1 for interpretation in results
#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 	
i.LinsureE i.rent i.unemp2									/*hardship*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw		c.cedu12										/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr

margins, at(unemp2=(0(1)1)) post
test _b[1._at] = _b[2._at]

#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 	
i.LinsureE i.rent i.unemp2									/*hardship*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw		c.cedu12										/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr

margins, at(cedu12=(0(4)4)) post
test _b[1._at] = _b[2._at]

*	AMEs for interpretation in results
margins, at(hardship=(0(1)1) cedu12 = (0(4)4))  post

test _b[1._at] = _b[3._at]
test _b[2._at] = _b[4._at]
test (_b[4._at]-_b[2._at]) = (_b[3._at]-_b[1._at])


*	probit model 3 for interpretation in results
#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 	
i.hardship##c.cedu12										/*Interaction*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw														/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.union 	i.gov
c.SESiw c.cedu12  	
c.tenure c.workedFT		
ib2.family 	i.nhwhite 	i.region 	c.cohort10)  ;
#delimit cr


*	AMEs for interpretation in results
margins, at(hardship=(0(1)1) cedu12 = (0(4)4))  post

test _b[1._at] = _b[3._at]
test _b[2._at] = _b[4._at]
test (_b[4._at]-_b[2._at]) = (_b[3._at]-_b[1._at])

//  			#7   multicollinearity and correlations
note:	`tag'	#7   multicollinearity and correlations

*	multicollinearity with composite

#delimit ;
probit cashout 	
i.hardship##c.cedu12										/*Interaction*/
c.ceduk		i.own											/*OTriggers*/
c.SESiw														/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	;
#delimit cr

vif, uncentered //	ONLY cohort above 10

*	multicollinearity with components

#delimit ;
probit cashout 	
i.hardship##c.cedu12										/*Interaction*/
c.ceduk		i.own											/*OTriggers*/
c.lnBincome c.lnBwealth										/*SES*/		
c.tenure c.workedFT											/*E History*/ 				
ib2.family 	i.nhwhite	i.female	i.region 	c.cohort10 	/*Demo*/	;
#delimit cr

vif, uncentered // Income and cohort have VIFs over 400

****	corr for SES components 
corr lnBincome lnBwealth cedu12 SESiw SES

****	corr for all continuous vars used in analyses
corr  self union gov 			///
SESiw cedu12 					///
tenure workedFT 				///
female nhwhite cohort10			///
Rplan cashout

****	corr for cohort and SES components
corr SES SESiw lnBincome lnBwealth cedu12 cohort10

//  			#8 figure
note:	`tag'	#8 figure 

*	Logit for figure 2

#delimit ;
bootstrap, reps(1000) seed(173991):heckprobit cashout 	
i.hardship##c.cedu12										/*Interaction*/
c.ceduk		i.own											/*OTriggers*/
c.lnBincome	c.lnBwealth										/*SES*/		
ib2.family 	i.nhwhite	i.female 	i.region 	c.cohort10 	/*Demo*/	
,select(	i.self 		i.gov 		i.union
c.SES  			
ib2.family 	i.nhwhite 	i.region 	c.cohort10)   ;
#delimit cr

margins hardship, at(cedu12=(-4(1)5))

mgen, 		at(cedu12=(-4(1)5) hardship = 0) stub(peduP)
gen PeduP  = peduPcedu12 + 12 // de-centersgen 

mgen, 		at(cedu12=(-4(1)5) hardship = 1) stub(peduhP)
gen PeduhP = peduhPcedu12 + 12 // de-centers

*	predicted probabilities from probit model

#delimit ;
twoway 	rcap peduPll peduPul PeduP 		||
		rcap peduhPll peduhPul PeduP 		||
		connected peduPpr peduhPpr PeduP ,
	ytitle(Probability of Early Withdrawal)
	ylab(0(.1).3, grid)
	xlab(8(1)17)
	graphregion(margin(2 2 2 2)) plotregion(margin(0 0 0 0));
graph export "figure2.pdf", replace ;
graph print							;
#delimit cr

//  			#6	 Close log and exit
note:	`tag'	#6   Close log and exit

log close
exit

























