This folder stores all attempts of different normalizations.
---
Updated: 01/17/2019 by Ju-Chi
---
1. Demo_STATISnorm4r\*: 
	- Use FakeData: Big5 questionnaire responses that give blocks of correlations
	- STATIS-like normalization (double-centered the correlation matrix and divided by the 1st eigenvalue)
2. Demo_DiSTATIS\*:
	- Use data in zmat\: Ten resting-state session data of one participant from a public data set
	- The original data is ROI\*ROI\*10 sessions correlation data
	- Only the positive correlations are kept
	- Analyze with DiSTATIS (sessions as tables) 
