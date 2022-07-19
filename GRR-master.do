
capture log close
log using GRR-master, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Master Do-File for SF Replication
//		Social Stratification and Choice-Based Policy Programs: 
//			The Case of Early Withdrawal of Retirement Savings 
//			during the Great Recession
//	Before Running: Download txt and do files to working directory
//	Required texts are the following:
//		family data for 2005, 2007, 2009, and 2011 and
//			family wealth data from 2005 and 2007 
//			are merged with individual data from 2015
//		The text used for the final product was downloaded 2019-2-20 ;
local pgm GRR-master
local dte 2020-06-01
local who Zachary D. Kline; working paper with Jeremy Pais
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//  #1	Adjust Settings
*	NOTE: These do files will temporarily CHANGE your stata settings and
*			permanently INSTALL packages to your working directory!!!
*				Credit to Dr. Scott Long
do GRR-profile
do GRR-setup

//  #2	Data Cleaning 
do GRR-PSID_source 
do GRR-PSID_ehistory
do GRR-PSID_hshock
do GRR-PSID_shock
do GRR-PSID_rplans
do GRR-PSID_econ
do GRR-PSID_demo
do GRR-PSID_SES // results attached in replication

//	#3	Social Forces Analyses 
do GRR-SF						

//	#4	Close Log and Exit 
capture log close
exit

