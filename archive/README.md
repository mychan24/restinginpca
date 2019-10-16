This folder stores the archived attempts of normalization and analysis, but they are not used anymore.

>Updated: 03/05/2019 by Ju-Chi

1. Demo_STATISnorm4r\*: 
	- Use FakeData: Big5 questionnaire responses that give blocks of correlations
	- STATIS-like normalization (double-centered the correlation matrix and divided by the 1st eigenvalue)
	- Test what this normalization does

2. Demo_DiSTATIS\*:
	- Use data in zmat\: Ten resting-state session data of one participant from a public data set
	- The original data is ROI\*ROI\*10 sessions correlation data (r)
	- Only the positive correlations are kept
	- Analyze with DiSTATIS (sessions as tables) 
	- Get the DiSTATIS results with these 10 sessions of one participant
	- Use this result as the standard results (of multivariate analysis on resting-state data) to be compared with other normalizations later

3. MuSu_nonpreproc\*:
	- Use data in zmat\: Ten resting-state session data of one participant from a public data set
	- The original data is ROI\*ROI\*10 sessions correlation data (r)
	- Only the positive correlations are kept
	- Analyze with SVD without centering and normalizing rows and/or coloumns

4. MuSu_preliminaryCode:
	- First pass of MuSu analysis
	- A preliminary version of the code

5. res_MuSu:
	- The results of 12 combinations of preprocessing steps
	- The preprocessed version of MuSu_nonpreproc
	- The original data is ROI\*ROI\*10 sessions correlation data (r)
	- Use data in zmat\: Ten resting-state session data of ten participant from a public data set
	- Only the positive correlations are kept
	- These are the attempts of all combinations before we narrowed them down to those that make more sense