*Numerisation des industries
*1 pour "road and rail"; 2 pour "marine transportation" 3 pour "transportation infrastructure"
replace INDUSTRY="1" if INDUSTRY=="Road & Rail Transport"
replace INDUSTRY="2" if INDUSTRY=="Marine Transport"
replace INDUSTRY="3" if INDUSTRY=="Transportation Infrastructure"
*On remarque qu'il a des éléments qui sont considérés comme des mots
encode INDUSTRY, gen (Industry)
encode LEV, gen(Lev)
encode DEBT, gen (Debt)
encode ASSETS, gen (Assets)
encode INCOME, gen (Income)
encode EMPLOYEES, gen (Employees)
encode SDG3, gen (Sdg3)
encode SSCORE, gen (Sscore)
encode ESCORE, gen (Escore)
encode CERTIF, gen (Certif)
encode CO2, gen (Co2)
encode GSCORE, gen (Gscore)

*On va supprimer les anciennes variables*
drop INDUSTRY
drop LEV
drop DEBT
drop ASSETS
drop INCOME
drop EMPLOYEES
drop SDG3
drop SSCORE
drop ESCORE
drop CERTIF
drop CO2
drop GSCORE
*on va visualiser*
summarize

*Renommer les variables covid*
*Creer une valeur présence avec 0 et 1 --> 0 pour le sans COVID et 1 pour le covid*
gen COVID=Presence=="1"
gen SCOVID=Presence=="0"



