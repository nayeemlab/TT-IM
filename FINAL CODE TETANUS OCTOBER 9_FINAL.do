use "C:\Users\Administrator\Desktop\Tetnus Major revision fixed files\DATA pls dont dilit\Tetanus toxoid dataset Original.dta",clear

******************************************************************
*WEIGHT, STRATA, CLUSTER VARIABLE FOR THE APPENDED DATA
******************************************************************
gen wgt=rweight
svyset [pw=wgt],psu(HH1) 
*strata(stratum)


*-------------------------*
*##### cut down data to include only 5 year prior births#####*
*-------------------------*
rename Dead Death

keep if colper == 0
by agegrp, sort : inspect Death

*___remove comment for the following for only neonatal___*

gen neonatal=Death
by agegrp, sort : inspect neonatal
keep if agegrp<1
*recode neonatal 0=1
*recode neonatal -1=2
label define neonatal2  1 "dead" 0 "alive"
label values neonatal neonatal2
svy: tab neonatal

*-------------------------*
*variables
*-------------------------*


*add non_vaccinated in MN9

mvencode MN9 if MN8==2, mv(.=0)
tab MN9


*tetanus doses in units__*how many taken*

svy: tab MN9
tab MN9
gen tt1=MN9
*recode tt1 1=1
*recode tt1 2=2
recode tt1 3/7=3
recode tt1 8=.
label define ttl1 0 "none" 1 "1inj" 2 "2inj" 3 "adequate"
label values tt1 ttl1
tab tt1 neonatal,chi2
svy: tab tt1
svy: tab tt1 neonatal, row
svy: tab tt1 neonatal


*tt dose taken or not

gen tt_dose_taken=MN9
recode tt_dose_taken 1/8=1
tab tt_dose_taken
svy: tab tt_dose_taken neonatal
tab tt_dose_taken neonatal, chi2


*-------------------------*
*other variables
*-------------------------*

*instrument sanitized
svy: tab MN29
gen in_s=MN29
recode in_s 1=1
recode in_s 2=2
recode in_s 8=3
recode in_s 9=.
label define in_sl 1 "yes" 2 "no" 3 "don't know'"
label values in_s in_sl
tab in_s Death
svy: tab in_s
svy: tab in_s Death, row
tab in_s Death, chi2

*C-section (NW).
svy: tab MN21
gen C_Section1=MN21
recode C_Section1 1=1
recode C_Section1 2=2
recode C_Section1 9=.
label define C_Section1 1 "Yes" 2 "No"
label values C_Section C_Section1
svy: tab C_Section
tab C_Section1 Death, chi2
svy: tab C_Section1 Death, row


*child sex.
svy: tab BH3
tab BH3 Death, row
svy: tab BH3 Death, row
tab BH3 Death, chi2

*ANC (NW).
svy: tab MN5
gen ANC2=MN5
recode ANC2 1/3=1
recode ANC2 4/15=2
recode ANC2 98=.
label define ANC2l 1 "less4" 2 "4above"
label values ANC2 ANC2l
svy: tab ANC2
tab ANC2 Death, chi2
svy: tab ANC2 Death, row



*ANC (NW).
svy: tab MN5
gen ANC3=MN5
recode ANC3 0/3=1 4/8=2 8/16=3
recode ANC3 98=.
label define ANC2l1 1 "less4" 2 "4above"
label values ANC3 ANC2l
svy: tab ANC3
tab ANC3 Death, chi2
svy: tab ANC3 Death, row


*water treatment
svy: tab WS9
gen treated_water=WS9
recode treated_water 1=1
recode treated_water 2=2
recode treated_water 8=3
recode treated_water 9=.
recode treated_water 3=.
label define treatl 1 "yes" 2 "no" 3 "don't know'"
label values treated_water treatl
tab treated_water
svy: tab treated_water
svy: tab treated_water Death, row
tab treated_water neonatal,chi2

*Residence.
svy: tab HH6
gen area=HH6
*recode area1 1=1
*recode area1 2/4=2
*recode area1 5=3
label define area1  1 "Rural" 2 "Urban" 3 "Tribal"
label values area area1
svy: tab area
tab area Death, row
svy: tab area Death, row
tab area Death, chi2


*Division.
svy: tab HH7
tab HH7 Death, row
svy: tab HH7 Death, row
tab HH7 Death, chi2


* Mother's Education.
svy: tab welevel
recode welevel 1=2
recode welevel 9=.
svy: tab welevel
tab welevel Death, row
svy: tab welevel Death, row
tab welevel Death, chi2



*Wealth Status.
svy: tab windex5
recode windex5 0=.
recode windex5 2 = 1
recode windex5 4 = 3
svy:tab windex5
tab windex5 Death, row
svy: tab windex5 Death, row
tab windex5 Death, chi2

*Religion.
svy: tab HC1A
gen Religion1=HC1A
recode Religion1 1=1
recode Religion1 2/7=2
recode Religion1 9=.
label define Religion1 1 "Islam" 2 "Others"
label values Religion1 Religion1
svy: tab Religion1
tab Religion Death, row
svy: tab Religion Death, row
tab Religion Death, chi2


*household head sex.
svy: tab HHSEX
tab HHSEX Death, row
svy: tab HHSEX Death, row
tab HHSEX Death, chi2

*ethnicity.
svy: tab ethnicity
tab ethnicity Death, row
svy: tab ethnicity Death, row
tab ethnicity Death, chi2

*Mother Age.
svy: tab WAGE
gen WA2=WAGE
recode WA2 1=1
recode WA2 2/4=2
recode WA2 5/7=3
label define WA2l 1 "15-19" 2 "20-34" 3 "35+"
label values WA2 WA2l
svy: tab WA2
tab WA2 Death, row
svy: tab WA2 Death, row
tab WA2 Death, chi2


*-------------------------------*
*_________unimportant__________*

*-------------------------------*


*Birth order. -------------(p value 0.5571)------------
svy: tab brthord
gen BO1=brthord
label values BO BO1
svy: tab BO
tab BO Death, row
svy: tab BO Death, row
tab BO Death, chi2

*Birth Weight (NW).-----------(p value 0.862)------------
svy: tab MN34
gen BW2=MN34
recode BW2 0/2.499=1
recode BW2 2.500/4.000=2
recode BW2 4.001/6.000=3
recode BW2 9.998=.
recode BW2 9.999=.
label define BW2l 1 "LBW" 2 "NBW" 3 "HBW"
label values BW2 BW2l
svy: tab BW2
tab BW2 Death, chi2 
svy: tab BW2 Death, row

*Place of delivery (NW). ---------(P value 0.730)--------
svy: tab MN20
gen Place_delivery1=MN20
recode Place_delivery1 11/12=1
recode Place_delivery1 21/26=2
recode Place_delivery1 31/36=3
recode Place_delivery1 96=.
recode Place_delivery1 76=.
recode Place_delivery1 99=.
label define Place_delivery1 1 "Home" 2 "Public" 3 "Private"
label values Place_delivery Place_delivery1
svy: tab Place_delivery
tab Place_delivery Death, chi2
svy: tab Place_delivery Death, row



*Place of delivery (NW). ---------(P value 0.730)--------
svy: tab MN20
gen Place_delivery2=MN20
recode Place_delivery2 11/12=1
recode Place_delivery2 21/26=2
recode Place_delivery2 31/36=3
recode Place_delivery2 96=.
recode Place_delivery2 76=.
recode Place_delivery2 99=.
// recode Place_delivery2 2/3=2
label define Place_deliveryl 1 "Home" 2 "Public" 3 "Private"
// label define Place_deliveryl1 1 "Home" 2 "Not_home" 3 "Private"
label values Place_delivery2 Place_deliveryl
// label values Place_delivery2 Place_deliveryl1
svy: tab Place_delivery2
tab Place_delivery2 Death, chi2
svy: tab Place_delivery2 Death, row



*women education level
gen welevel_1 = welevel
recode welevel_1 0/2=1 3=2


*recode birth order
recode BO1 3/4=3

*-------------------------------*
*analysis
*-------------------------------*
tab C_Section1 tt_dose_taken, chi2
cor C_Section1 Death
cor tt_dose_taken neonatal


tab tt1 neonatal,chi2
tab tt_dose_taken neonatal, chi2
tab in_s Death, chi2
tab C_Section1 Death, chi2 cell
tab BH3 Death, chi2
tab ANC2 neonatal, chi2
tab ANC3 neonatal, chi2
tab treated_water neonatal,chi2
tab area Death, chi2 col
tab HH7 Death, chi2
tab welevel Death, chi2
tab welevel_1 Death, chi2
tab windex5 Death, chi2
tab Religion Death, chi2
tab HHSEX Death, chi2
tab ethnicity Death, chi2
tab WAGE Death, chi2 col
tab WA2 Death, chi2
tab BO Death, chi2 cell
tab BW2 Death, chi2 
tab Place_delivery2 neonatal, chi2
tab Place_delivery2 C_Section1, chi2


codebook HH7
codebook welevel_1

svy: poisson neonatal ib1.tt_dose_taken i.C_Section1 ib2.BH3 i.ANC3 ib55.HH7 ib2.welevel_1 ib5.windex5 ib2.BO ib4.WAGE,irr

poisson neonatal i.tt_dose_taken i.C_Section1 i.BH3 i.ANC3 i.HH7 i.welevel_1 i.windex5 i.BO i.WAGE,irr

*estat vif
vif,uncentered
estat vce,corr



svy: poisson neonatal ib2.BO , irr
svy: poisson neonatal ib4.WAGE , irr
svy: poisson neonatal ib5.windex5 , irr
svy: poisson neonatal ib2.welevel_1 , irr
svy: poisson neonatal ib30.HH7 , irr
svy: poisson neonatal i.ANC3 , irr
svy: poisson neonatal ib2.BH3 , irr
svy: poisson neonatal i.C_Section1 , irr
svy: poisson neonatal ib1.tt_dose_taken , irr




tab neonatal
tab tt_dose_taken
tab tt1




svy: tab MN9
tab MN9
gen tt3=MN9
recode tt3 1=1
recode tt3 2=1
recode tt3 3/7=2
recode tt3 8=.





svy: poisson neonatal ib0.tt3 i.C_Section1 i.ANC3 ib2.BH3 ib2.welevel_1 ib55.HH7 ib5.windex5 ib2.BO ib4.WAGE,irr
svy: poisson neonatal ib0.tt3,irr




**# Bookmark #1
order wgt neonatal tt1 tt_dose_taken in_s C_Section1 ANC2 ANC3 treated_water area Religion1 WA2 BO1 BW2 Place_delivery1 Place_delivery2 welevel_1 tt3







rename neonatal (death)
rename wgt (s_wt)
rename tt1 (dose_cat_1)
rename C_Section1 (c_sec)
rename ANC3 (ANC)
rename BH3 (sex_child)
rename welevel_1 (mother_edu)
rename HH7 (division)
rename BO1 (Br_Order)
rename WAGE (mother_age)
rename tt3 (dose_cat_2)


order death dose_cat_1 tt_dose_taken c_sec sex_child ANC area Religion1 Br_Order mother_edu division


keep HH1 s_wt death tt_dose_taken dose_cat_1 dose_cat_2 ANC division c_sec sex_child mother_edu mother_age windex5 Br_Order

save "C:\Users\Administrator\Desktop\Tetnus Major revision fixed files\DATA pls dont dilit\FINAL DATA TETANUS2.dta",replace


order HH1 s_wt death tt_dose_taken dose_cat_1 dose_cat_2 ANC division c_sec sex_child mother_edu mother_age windex5 Br_Order


la var HH1 ""
label variable s_wt "data weights"
label variable death "child mortality status"
label variable tt_dose_taken "vaccination status"
label variable dose_cat_1 "Doses taken (main)"
label variable dose_cat_2 "Doses taken (aggregated)"
label variable ANC "Anc count"
label variable division "Division"
label variable c_sec "c_section done"
label variable sex_child "Sex of child"
label variable mother_edu "Mother's education status"
label variable mother_age "Mother's age group"
label variable windex5 "Wealth index quintile"
label variable Br_Order "Birth order"

save "C:\Users\Administrator\Desktop\Tetnus Major revision fixed files\DATA pls dont dilit\FINAL DATA TETANUS lab.dta",replace
