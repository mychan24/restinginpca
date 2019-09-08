# Data for this project

* *./cifti* contains CIFTI files of MSC subjects
	+ networks.dscalar.nii = subject specific community assignment (functional systems)
	+ parcel_networks.dscalar.nii = parcels labeled by their network assignment
	+ parcels.dtseries.nii = subject specific parcellation

* *./parcel_community* contains community assignment files (.txt) 
* *./tp*  contains the parcel x tp matrix for each subject (.txt files)
* *./zmat* contains z-matrix
	+ These files are not uploaded to github, but can be created using `../tools/cube_allsubs.R`


## Data that are referred to in other scripts but no in this folder? 
Grandtables contains repeated information thus are not synced through github. 

Use `../tools/gt_allsubs.R` and `../tools/gt_bignetworks_allsubs.R` to create the grandtables needed for analysis shown in the `../res_MuSu` or `../res_MuSu_4rows`.


