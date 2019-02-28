********************************************************************************
*		Table 4: Summary Statistics by Race: Reviewer Characteristics
********************************************************************************

/*sum rev_race_res if rev_race_res == 1 | rev_race_res == 2 | rev_race_res == 3 | rev_race_res == 4
sum race_res if race_res == 1 | race_res == 2 | race_res == 3 | race_res == 4
tab rev_race_res race_res

tab  rev_race_res if rev_race_res == 1 | rev_race_res == 2 | rev_race_res == 3 | rev_race_res == 4
tab race_res if race_res == 1 | race_res == 2 | race_res == 3 | race_res == 4
*/

// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_reviewer_char.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Race: Reviewer Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c c c c c}" _n ///

// write column headers
file write f " \cmidrule(r){1-6}" _n ///
" & (1) & (2) & (3) & (4) & (5)" _n ///
"\\" _n ///
" & \multicolumn{1}{c}{Full sample} & White & Black & Hispanic & Asian" _n ///
"\\" _n ///
"\hline\hline\noalign{\smallskip} " _n 

********************************************************************************
********************************************************************************
		
local cat1 rev_race_res		

	foreach i in `cat1'{ //loops over Reviewer race
		sum `i' //Full Data
		local full_N = `r(N)' //
		local full_prop = `r(N)' / `full_N'
		
		levelsof rev_race_res
		foreach r in `r(levels)'{
			sum `i' if rev_race_res == `r'
			local `r'_race_N = `r(N)' // reviewer race count
			local `r'_race_prop = ``r'_race_N' / `full_N'
			
		}

		file write f " Reviewer race & " %4.2f (`full_prop') " & " %4.2f (`1_race_prop') " & " %4.2f (`2_race_prop') " & " %4.2f (`3_race_prop') " & " %4.2f (`4_race_prop') " \\"
		file write f "\\" _n
}

local cat2 race_res		

	foreach i in `cat2'{ //loops over Reviewer race
		sum `i' //Full Data
		local full_N = `r(N)' //
		local full_prop = `r(N)' / `full_N'
		
		levelsof race_res
		foreach r in `r(levels)'{
			sum `i' if race_res == `r'
			local `r'_race_N = `r(N)' // reviewer race count
			local `r'_race_prop = ``r'_race_N' / `full_N'
			
		}

		file write f " Host race & " %4.2f (`full_prop') " & " %4.2f (`1_race_prop') " & " %4.2f (`2_race_prop') " & " %4.2f (`3_race_prop') " & " %4.2f (`4_race_prop') " \\"
		file write f "\\" _n
}


local ncat sentiment_mean sentiment_listing		

	foreach i in `ncat'{ //loops over outcome variable
			sum `i' //Full data column
			local full_observations = `r(N)' //saves full data N
			local full_mean_`i' = `r(mean)'
			local full_sd_`i' = `r(sd)'
			preserve
			// keep if sample == 1 //restricts regression sample
			sum `i' //All column
			local all_observations = `r(N)' //saves all N 
			local all_mean_`i' = `r(mean)'
			local all_sd_`i' = `r(sd)'
			local var_label : variable label `i'
			
			levelsof race_res
			foreach f in `r(levels)'{
				sum `i' if race_res == `f'
				local `f'_race_observations = `r(N)' //saves race N
				local `f'_mean_`i' = `r(mean)'
				local `f'_sd_`i' = `r(sd)'
			}
			restore
			//write means
			//write label
			file write f " `: var label `i'' & " %4.2f (`full_mean_`i'') " & " %4.2f (`1_mean_`i'') " & " %4.2f (`2_mean_`i'') " & " %4.2f (`3_mean_`i'') " & " %4.2f (`4_mean_`i'') " "
			file write f "\\" _n
			file write f " & " "(" %4.2f (`full_sd_`i'') ")" " & " "(" %4.2f (`1_sd_`i'') ")" " & " "(" %4.2f (`2_sd_`i'') ")" " & " "(" %4.2f (`3_sd_`i'') ")" " & " "(" %4.2f (`4_sd_`i'') ")" " "
			file write f "\\" _n
			
	}


********************************************************************************
********************************************************************************


// number of observations
file write f "\hline" _n ///
"Observations & `full_observations' & `1_race_observations' & `2_race_observations' & `3_race_observations' & `4_race_observations'" _n ///
"\\" _n

// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} The values in the table are means and standard deviations" ///
	" of reviewer-level data who left reviews for a randomly chosen set of hosts in Chicago." ///
	" The review sentiment is the sentiment of each review, the listing sentiment is the average" ///
	" sentiment per listing. Observations in columns 2 - 5 do not add up to 17,050 because multiracial or" ///
	" unidentifiable reviewer pictures are excluded. White refers only to non-Hispanic whites." _n ///
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f

/*
local cat2 race_res
	foreach i in `cat2'{ //loops over Host race
		sum `i' //Full Data
		local full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
		
		levelsof `i'
			foreach k in `r(levels)'{
				sum `i' if `i' == `k' //Full Data
				local `k'_full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
				local `k'_full_mean_`i' = ``k'_full_N_`i''/`full_N_`i''
				preserve
				keep if sample == 1 //restricts regression sample

				levelsof rev_race_res
					foreach r in `r(levels)' {
						sum `i' if rev_race_res == `r' 
						local `r'_race_N_`i' = `r(N)'
							sum `i' if `i' == `k' & rev_race_res == `r'
							local `r'_`k'_race_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
							local `r'_`k'_race_mean_`i' = ``r'_`k'_race_N_`i''/``r'_race_N_`i''
						
						}
				restore
					
					}

		file write f " \hspace{10bp}White & " %4.2f (`1_full_mean_`i'') " & " %4.2f (`1_1_race_mean_`i'') " & " %4.2f (`2_1_race_mean_`i'') " & " %4.2f (`3_1_race_mean_`i'') " & " %4.2f (`4_1_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Black & " %4.2f (`2_full_mean_`i'') " & " %4.2f (`1_2_race_mean_`i'') " & " %4.2f (`2_2_race_mean_`i'') " & " %4.2f (`3_2_race_mean_`i'') " & " %4.2f (`4_2_race_mean_`i'') " \\"		
		file write f " \hspace{10bp}Hispanic & " %4.2f (`3_full_mean_`i'') " & " %4.2f (`1_3_race_mean_`i'') " & " %4.2f (`2_3_race_mean_`i'') " & " %4.2f (`3_3_race_mean_`i'') " & " %4.2f (`4_3_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Asian & " %4.2f (`2_full_mean_`i'') " & " %4.2f (`1_2_race_mean_`i'') " & " %4.2f (`2_2_race_mean_`i'') " & " %4.2f (`3_2_race_mean_`i'') " & " %4.2f (`4_2_race_mean_`i'') " \\"		




		
}








// local cat  
// rev_race_res
	
		file write f " \textit{Reviewer characteristics} & & & & & \\"
		file write f " \hline \\"		


local cat1 rev_race_res	race_res
	
	foreach i in `cat1'{ //loops over Reviewer race
		sum `i' //Full Data
		local full_N_`i' = `r(N)' //
		local full_prop_`i' = `r(N)' / `full_N'
		
		levelsof `i'
		foreach r in `r(levels)'{
			sum `i' if rev_race_res == `r'
			local `r'_race_N_`i' = `r(N)' // reviewer race count
			local `r'_race_prop_`i' = ``r'_race_N' / `full_N_`i''
			
		}
		local var_label : variable label `i'
		
		file write f " Reviewer race & " %4.2f (`full_prop_rev_race_res') " &&&& " \\"
		file write f "\\" _n
}		
