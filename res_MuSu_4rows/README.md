## Summary

+ MuSu vs. DoubleCent:
	
	+ Session factor scores: not much difference

	+ Edge factor scores (sub--w/b): double-centering the correlation matrix deemphasizes the sleeping subject (sub08) 

	+ Double-centering put the center between within- and between-network edges (i.e., for decreased activities in a within- and a between-network edges, they will be on the opposite side of one dimension)

 > Although double-centering deemphasizes the outlier subject, the interpretation of factor scores will be confusing without a-priori knowledge of the ground truth (which is unrealistic)

 > In comparison, the analysis results without the double-centering process, although does not deemphasize the outlier subject as much as the ones with the process, does not have the component dominating by the outlier. In general, the factor scores for the outlier are still close to the center as compared to other participants.
 
 + MFA_sub vs. HMFA (for both with and without double-centering):

 	+ Sessions factor scores: sessions with the simulated effect are closer in the factor scores map

 	+ Edge factor scores (sub--w/b): 

 		+ MFA_sub deemphasizes the sleeping subject (sub08), but HMFA gives a more homogeneous results

 		+ For MFA_sub, as opposed to HMFA, most factor sores for between-network edges are close to the center with components driven by the within edges.

 > This difference in the patterns of edge factor scores is possibly due to the inflation of between-network connectivities during the first level of MFA-normalization.

 > Because the between-network connectivities were low in the raw data, when they got inflated, the differentiation between sessions becomes weaker.

 > MFA_sub is essential.

 > Can we leverage how HMFA should be done based on research questions (e.g., blocked by important edge 1, important edge 2, important edge 3, and not important ones) or how researchers think the edges should be normalized (e.g., by edge type)?

 + HMFA with edge type > subject

 	+ Smaller simulated between-network edges are filtered out due to smaller contribution.

 	+ The factor scores make more sense compared to the HMFA_edge, and the results are not very far from the MFA_sub one but with the between-network edges contributing more to the components.


 > + HMFA with a-priori hypothesized networks
 > + HMFA with wrong a-priori hypothesized networks
 > 	+ These would be difficult to justify given the possiblity of double-dipping. Also, with an a-priori networks of interest, it might be better to select them at the very beginning of the analysis (just as the standard ROI analysis), instead of actively weighting them more to generate the component space.

### Next steps:

+ What is the data that we put into SVD look like after HMFA?

+ How do we examine the network edges that are small? 

	+ They tend to be excluded from the factor map, because they contribute less inertia overall (with less edges in total compared to other networks). This doesn't necessarily mean that they are not important and should be excluded from the results. 	
 
