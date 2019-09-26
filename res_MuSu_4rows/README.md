## Summary

+ MuSu vs. DoubleCent:
	
	+ Session factor scores: not much difference

	+ Edge factor scores (sub--w/b): double-centering the correlation matrix deemphasizes the sleeping subject (sub08) 

> We prefer double-centering.
 
 + MFA_sub vs. HMFA (for both with and without double-centering):

 	+ Sessions factor scores: sessions with the simulated effect are closer in the factor scores map

 	+ Edge factor scores (sub--w/b): 

 		+ MFA_sub deemphasizes the sleeping subject (sub08), but HMFA gives a more homogeneous results

 		+ For MFA_sub, as opposed to HMFA, most factor sores for between-network edges are close to the center with components driven by the within edges.

 > This difference in the patterns of edge factor scores is possibly due to the inflation of between-network connectivities during the first level of MFA-normalization.

 > Because the between-network connectivities were low in the raw data, when they got inflated, the differentiation between sessions becomes weaker.

 > MFA_sub is essential.

 > Can we leverage how HMFA should be done based on research questions (e.g., blocked by important edge 1, important edge 2, important edge 3, and not important ones) or how researchers think the edges should be normalized (e.g., by edge type)?

 ## Next step

 1. HMFA with edge type > subject

 2. HMFA with hypothesized networks
 
