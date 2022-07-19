# GRR

These syntax were used to create results for paper titled, "Social Stratification and Choice-Based Policy Programs: The Case of Early Withdrawal of Retirement Savings during the Great Recession." 

Citation: Kline, Zachary and Jeremy Pais. 2021. "Social Stratification and Choice-Based Policy Programs: The Case of Early Withdrawal of Retirement Savings during the Great Recession." Social Forces 99(3): 947-978.

https://academic.oup.com/sf/article-abstract/99/3/947/5858251

Acknowledgement: The collection of data used in this study was partly supported by the National Institutes of Health under grant number R01 HD069609 and R01 AG040213, and the National Science Foundation under award numbers SES 1157698 and 1623684.

To create data set, download csv files for individual and family data directly from PSID data center.

_______________________________________________________

A summary of do files are as follows:

GRR-master : Master do file used to create data set and run all analyses. See for notes

________________________________________________________________________

These do files create the Stata environment used at the time this replication package was created

GRR-profile : Sets prefered visual settings for Stata, credit Dr. Scott Long

GRR-setup : Downloads and loads neccesary STATA packages using dated version of stata, credit Dr. Scott Long

______________________________________________________________________

These do files create the data set used in the analyses

GRR-PSID_source : Imports and merges data from CSV files downloaded from PSID data center.

GRR-PSID_ehistory: Cleans economic history variables

GRR-PSID_hshock : Cleans health shock variables

GRR-PSID_rplans : Cleans retirement plan data

GRR-PSID_econ : Cleans other economic variables

GRR-PSID_demo : Cleans demographic variables

GRR-PSID_SES : Creates SES scale composed of income, wealth, and education

At this stage, the final data set used for analyses is created

________________________________________________________________________________

GRR-SF : Creates results presented in published paper
