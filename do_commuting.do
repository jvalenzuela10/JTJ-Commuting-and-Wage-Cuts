use "C:\Users\jpvaa\Desktop\Research\Commuting and JTJ transitions\base_commuting_master.dta"

xtset id date

gen delta_dist = distancia-L.distancia if JTJ==1

gen l_wage = log(wage)

// 1ST DEFINITION OF WAGE CUT:

gen wage_cut = 1 if (JTJ==1 & L2.l_wage>F1.l_wage)
replace wage_cut = 0 if (JTJ==1 & L2.l_wage<=F1.l_wage)


// 2ND DEFINITION OF WAGE CUT:

gen L2_l_wage = L2.l_wage
gen L3_l_wage = L3.l_wage
gen L4_l_wage = L4.l_wage


egen wage_l234 = rowmean(L2_l_wage L3_l_wage L4_l_wage)

gen wage_cut2 = .
replace wage_cut2 = 1 if (JTJ==1 & wage_l234 > F1.l_wage)
replace wage_cut2 = 0 if (JTJ==1 & wage_l234 <= F1.l_wage)

hist distancia if distancia<200 & distancia>0

binscatter l_wage distancia if distancia>0 & distancia<200 & year>=2010, nq(100)

********************************************************************************

 **** GRAFICO PERCENTILES
 
 bys id: egen N = count(_n)
 bys id: egen count_jtj = total(JTJ)
 bys id: gen prob_jtj = count_jtj/N

xtile ptile_jtj = prob_jtj if prob_jtj>0, nq(100)

preserve

collapse (mean) distancia if year>=2007 by(ptile_jtj)

twoway (bar distancia ptile_jtj) // plot

restore

********************************************************************************

// REGION METROPOLITANA

gen rm = 1 if (comuna>13000 & comuna<14000) & (comuna_emp>13000 & comuna_emp<14000)
replace rm = 0 if rm==.

// REGRESSIONS:

** JTJ PROB AND DISTANCE TO WORK:

xtreg JTJ L2.l_wage L.distancia if year>=2007, fe r

xtreg delta_dist wage_cut2 if year>=2007 & (id_firma==F1.id_firma & F1.id_firma==F2.id_firma & F2.id_firma==F3.id_firma), fe r

xtreg delta_dist wage_cut if year>=2007 & (id_firma==F1.id_firma & F1.id_firma==F2.id_firma & F2.id_firma==F3.id_firma), fe r

xtreg delta_dist wage_cut2 if year>=2007 & (id_firma==F1.id_firma & F1.id_firma==F2.id_firma & F2.id_firma==F3.id_firma & F3.id_firma==F4.id_firma & F4.id_firma==F5.id_firma & F5.id_firma==F6.id_firma & F6.id_firma==F7.id_firma & F7.id_firma==F8.id_firma & F8.id_firma==F9.id_firma & F9.id_firma==F10.id_firma), fe r

xtreg delta_dist wage_cut if year>=2007 & (id_firma==F1.id_firma & F1.id_firma==F2.id_firma & F2.id_firma==F3.id_firma & F3.id_firma==F4.id_firma & F4.id_firma==F5.id_firma & F5.id_firma==F6.id_firma & F6.id_firma==F7.id_firma & F7.id_firma==F8.id_firma & F8.id_firma==F9.id_firma & F9.id_firma==F10.id_firma), fe r

***********************
***********************
// SOLO REGION METROPOLITANA

xtreg delta_dist wage_cut2 if year>=2007 & (id_firma==F1.id_firma & F1.id_firma==F2.id_firma & F2.id_firma==F3.id_firma) & rm==1, fe r


