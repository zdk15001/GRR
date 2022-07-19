capture log close
log using GRR-setup, replace text
set linesize 80
version 13.1
clear all
macro drop _all
set scheme s1manual

//  GRR: Setup
//		From Scott Long, "Setting up Stata in Soc 650 / Stat 503 / 2017-08-02"
//  	File name: cda17-initial-setup.do

local pgm GRR-profile
local dte 2020-6-1
local who Zachary D. Kline
local run $S_DATE $S_TIME
local tag `pgm'.do `who' `dte' `run'
di _new "`tag'" _new "Run on `run'"

//	#1 Install Packages spost13 and estout
*Note--In order to install these packages you must have access to internet

* spost13 install
net install spost13_ado, from (https://jslsoc.sitehost.iu.edu/stata/) replace

* estout install
net install estout, from(http://fmwww.bc.edu/RePEc/bocode/e) replace

ado
log close
exit
