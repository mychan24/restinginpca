# How is our method better?
---
*FINAL: HMFA with subject first then edgetype (within/between network) next.*
	
	- Justification: subject has to be normalized. This step would be especially essential for a more inhomogeneous group (e.g., aging, lesion, developmental population).

	- Connectivity in within and between have different characteristics. For example, the between network connectivity are always weaker than within network connectivity. Therefore, these two types should be normalized to ensure that the between network connectivity was not under-represented in the factor space.
---

## Step one --

Compared to DiSTATIS:

- (1) DiSTATIS with Gorden's parcellation

- (2) DiSTATIS with mean connectivity based on Gordon's parcellation

- (3) DiSTATIS with mean connectivity based on individual parcellation

- *Our method: HMFA with subject first and edgetype (between vs. within) then*

- *Expectation*:

	+ Compared to (1), (2) will miss some effect because the pattern within each edge is smoothed and the some effect will be missed.

	+ Compared to (3), (2) will be less likely to detect effects in small networks 
	> need another simulation in small network

	+ Compare to our SVD, (3) will miss the effect of patterns