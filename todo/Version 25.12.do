****Avec Josué***
*Reprend à 0*
clear all
set more off, permanently

*Import de la base de données*
import excel "C:\Users\Anna\Desktop\HEC Lausanne\semestre 3\Travail de mémoire\Base de données\Stata\DERNIERE VERSION.xlsx", sheet("Sheet1") firstrow

*Changer de format
destring LEVERAGE, replace
destring TOTAL_ASSETS, replace
destring SDG8, replace
destring SSCORE, replace
destring ISO14000_EMS, replace
destring ESCORE, replace
destring CARBON_EMISSION_SCOPE1_2, replace
destring CARBON_EMISSION_SCOPE_3, replace
destring CARBON_EMISSION, replace
destring GSCORE, replace
destring EMPLOYEE_ACCIDENT, replace
destring OPERATING_INCOME, replace
destring ROA, replace
destring ROE, replace
bro
* mettre de manière numérique les industries / créer une nouvelle valeur à la fin *
gen ROAD_RAIL=1 if INDUSTRY=="Road & Rail Transport"
recode ROAD_RAIL (.=0)
gen MARINE=1 if INDUSTRY=="Marine Transport"
recode MARINE (.=0)
gen INFRASTRUCTURE=1 if INDUSTRY=="Transportation Infrastructure"
recode INFRASTRUCTURE(.=0)
*1 = année sans covid (2017,2018) et 0= avec covid.
gen YEAR17_18= 1 if YEAR<2019
recode YEAR17_18 (.=0)
*Année pendant Covid
gen YEAR19_20= 1 if YEAR==2019|YEAR==2020
recode YEAR19_20 (.=0)
*Année après le covid 
gen YEAR21=1 if YEAR==2021
recode YEAR21(.=0)

*Mettre de manière numérique les condinents
gen Asia= 1 if COUNTRY=="Asia"
recode Asia (.=0)
gen Europe= 1 if COUNTRY=="Europe"
recode Asia (.=0)
gen South_America= 1 if COUNTRY=="South of America"
recode South_America (.=0)
gen Africa= 1 if COUNTRY=="Africa"
recode Africa (.=0)
gen North_America= 1 if COUNTRY=="North of America"
recode North_America (.=0)
gen Oceania= 1 if COUNTRY=="Oceania"
recode Oceania (.=0)
**Création d'une variable d'interaction
*Covid + industrie
gen COVID_ROAD_RAIL = YEAR19_20 * ROAD_RAIL
gen COVID_MARINE = YEAR19_20 * MARINE


*Taille des entreprises 
gen SIZE= ln(TOTAL_ASSETS)

**Choix du modèle**
*Gérer les Id parce qu'on travaille avec des données de panel et donc il nous faut T +
egen ID = group(COMPANY)
sort ID
xtset ID YEAR


***************************OLS / RANDOM EFFECT************************** 
xtreg SSCORE ROA ROE SIZE  LEVERAGE GSCORE SDG8 ROAD_RAIL MARINE YEAR19_20 COVID_MARINE COVID_ROAD_RAIL, vce (cluster ID)
outreg2 using perfomance_sociale, replace excel dec (3)
*xtreg SSCORE SIZE  LEVERAGE SDG8 ROAD_RAIL MARINE GSCORE YEAR19_20 YEAR21 , fe
*estimates store fixed
*outreg2 using perfomance_sociale, append excel dec (3)
xtreg SSCORE ROA ROE SIZE  LEVERAGE GSCORE SDG8 ROAD_RAIL MARINE YEAR19_20 COVID_MARINE COVID_ROAD_RAIL, re
estimate store random
outreg2 using perfomance_sociale, append excel dec (3)
     
***tEST DE HauSSMAN*
*xtreg SSCORE SIZE  LEVERAGE SDG3 ROAD_RAIL MARINE GSCORE YEAR19_20 YEAR21, fe
*estimates store fixed
*xtreg SSCORE SIZE  LEVERAGE SDG3 GSCORE ROAD_RAIL MARINE YEAR19_20 YEAR21, re
*estimate store random	 
*hausman fixed random
	 
	 
*2ème model (performance environnemntale)
xtreg ESCORE ROA ROE SIZE LEVERAGE GSCORE ISO14000_EMS CARBON_EMISSION ROAD_RAIL MARINE YEAR19_20 COVID_MARINE COVID_ROAD_RAIL, vce (cluster ID)
outreg2 using perfomance_environnementale, replace excel dec (3)
*xtreg SSCORE SIZE  LEVERAGE SDG8 ROAD_RAIL MARINE GSCORE YEAR19_20 YEAR21 , fe
*estimates store fixed
*outreg2 using perfomance_sociale, append excel dec (3)
xtreg ESCORE ROA ROE SIZE LEVERAGE GSCORE ISO14000_EMS CARBON_EMISSION ROAD_RAIL MARINE YEAR19_20 COVID_MARINE COVID_ROAD_RAIL, re
estimate store random
outreg2 using perfomance_environnementale, append excel dec (3)

********************************ROBUST TEST*************************************
*MODEL 1
xtreg SSCORE OPERATING_INCOME  LEVERAGE GSCORE EMPLOYEE_ACCIDENT ROAD_RAIL MARINE YEAR19_20 YEAR21, vce (cluster ID)
outreg2 using ROBUST_TEST_MODEL1, replace excel dec (3)
*xtreg SSCORE SIZE  LEVERAGE SDG8 ROAD_RAIL MARINE GSCORE YEAR19_20 YEAR21 , fe
*estimates store fixed
*outreg2 using perfomance_sociale, append excel dec (3)
xtreg SSCORE OPERATING_INCOME  LEVERAGE GSCORE EMPLOYEE_ACCIDENT ROAD_RAIL MARINE YEAR19_20 YEAR21, re
estimate store random
outreg2 using ROBUST_TEST_MODEL1, append excel dec (3)

*MODEL 2

xtreg ESCORE OPERATING_INCOME LEVERAGE GSCORE ISO14000_EMS CARBON_EMISSION ROAD_RAIL MARINE  YEAR19_20 YEAR21, vce (cluster ID)
outreg2 using ROBUST_TEST_MODEL2, replace excel dec (3)
*xtreg ESCORE SIZE LEVERAGE ISO14000_EMS ROAD_RAIL MARINE GSCORE YEAR19_20 YEAR21 , fe
*estimates store fixed
*outreg2 using performance_environnementale, append excel dec (3)
xtreg ESCORE OPERATING_INCOME LEVERAGE GSCORE ISO14000_EMS CARBON_EMISSION ROAD_RAIL MARINE  YEAR19_20 YEAR21, re
estimate store random
outreg2 using ROBUST_TEST_MODEL2, append excel dec (3)
