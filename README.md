# restinginpca

> Short descriptions about the objectives

+ Maybe we can add descriptions about where to find things in this repository?

## Analysis in this repo requires the some R packages not on CRAN
MexPosition did not update to be on the current CRAN, but can still be downloaded from Github. 
PTCA4CATA with parallelized bootstrap is on JY's github. 
superheat that enables reversing of axis when plotting suqare matrices are on MC's github

> devtools::install_github("cran/MexPosition")
> devtools::install_github("juchiyu/PTCA4CATA")
> devtools::install_github("mychan24/superheat")

## Notes:

- 2019.9.23: HMFA-normalization fixed.
	
	- This was only fixed for the 4rows analysis, not for the original MuSu.

	- The original version extracted both levels of singular values from the original data table. However, these two levels of singular values should be extracted hierarchically: extract delta for edges -> weight the edge tables -> extract delta for subject -> weight the subject tables


