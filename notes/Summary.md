# Summary of MuSu (analyses 1-8)

### GOAL
Develop a technique that could analyze resting-state data and allow different participant to have different number of voxels/nodes.

### Solution to test for
If, instead of using the square correlation (or distance) matrix, we arrange data as condition x (regions x participants). In this case, we can concatenate data of different participants on the columns (we think).

With the two by two design of the condition, we can maybe try an analysis similar to the ANOVA approach.

#### Problem
But how do we know what the svd of this gives us, and how is this different from a DiSTATIS on distance matrices?

_We cannot compare the two sets of results because they don't have the same observations/variables_

+ What Normalization should we use?

+ How do we bootstrap? (All random factors need to be bootstrapped.)
+ How can we do an ANOVA-like comparison for the sessions

### DATA WE WISH TO ANALYZE
condition x (region x participants)

### DATA WE USED TO TEST
+ Big5 FakeData: for STATIS-like normalization (in _archive_)
+ Midnight Scan Club (MSC) publice online resting state data: for testing the normalization with multi-condition/multi-subject data

### HOW
##### Use MSC data where each subject has different numbers of regions (sometimes networks):

+ Try different normalization with multi-subjects data:

  Rectangular data structure: 10 sessions x (region-region edges x 10 subjects)

  1. SVD after the columns are centered (center across rows)

  2. SVD after the columns are centered and normalized (center and normalize across rows)

  3. MFA-normalized  (or _sumPCA_) rectangular matrix by subjects without normalizing across rows

  4. MFA-normalized rectangular matrix by subjects after normalizing across rows

  5. MFA-normalized rectangular matrix by networks without normalizing across rows

  6. MFA-normalized rectangular matrix by networks after normalizing across rows

  7. HMFA-normalized rectangular matrix by networks and subject without normalizing across rows

  8. HMFA-normalized rectangular matrix by networks and subject after normalizing across rows

### Conclusion

> Analysis no. 3, 7, and 8 are more meaningful.

The analyses that do not normalize (or equalize the contribution of) each subject do not make that much sense, because the subject with more edges will end up dominating the components. Conceptually, the networks should be MFA-normalized as well so that all networks contribute the same amount of variance. However, when no subject contributes differently to the analysis, it would also make sense if the result of a subject is dominated by his or her larger networks. So, we keep the 3rd analysis, in which the edges are centered across sessions and the subjects are MFA-normalized. The 4th analysis, which also normalized across sessions, is not considered because the normalizing session could exaggerate the variance when the patterns across sessions are uniformly flat. In the end, we pick three analyses that we think are most informative:

1. Analysis 3: MFA-normalized subjects _without_ normalizing across sessions

	+ This analysis keep the effects of network sizes for each subject. As a result, the result of a subject will be dominated by the pattern within his or her largest network. In addition, because the subjects are MFA-normalized, the number of edges won't affect the contribution of each subject.

2. Analysis 7: HMFA-normalized network edges then subjects _without_ normalizing across sessions

	+ This analysis equalize the contribution of each network to each subject and the contribution of each subject to the analysis. Because the edges are _not_ normalized across sessions, the subject with the most varied pattern will dominate the component and the result.

3. Analysis 8: HMFA-normalized network edges then subjects after normalizing across sessions

	+ This analysis equalize the contribution of each network to each subject and the contribution of each subject to the analysis. When the edges are normalized across sessions, the variance of a flat pattern across sessions might be exaggerated. However, this result would identify the subjects that have a very different pattern compared to others.

> Before showing the results, here are the raw connectivity matrices of all three subjects.

+ Subject 1:

	![Heatmap sub1](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/5_%5BNA%2C%20c%2C%20MFA_NetEdge%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_NetEdge__files/figure-markdown_github/plot_all_sub_session_hmap-1.png)

+ Subject 2:
	
	![Heatmap sub1](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/5_%5BNA%2C%20c%2C%20MFA_NetEdge%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_NetEdge__files/figure-markdown_github/plot_all_sub_session_hmap-2.png)

+ Subject 8:
	
	![Heatmap sub1](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/5_%5BNA%2C%20c%2C%20MFA_NetEdge%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_NetEdge__files/figure-markdown_github/plot_all_sub_session_hmap-3.png)

> Here, we show the results from the three analyses and summarize what each of them highlights.

1. MFA-normalized subjects _without_ normalizing across sessions

	+ Subject 8 for session 5 and subject 2 for session 1 are driving the pattern, but not too strong. Subject 8 has strong effect compared to Analysis 7 might because of his or her larger amount of edges compared to the other two subjects.

	![Factor map 3](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/3_%5BNA%2C%20c%2C%20MFA_subs%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_subs__files/figure-markdown_github/grid_f_netedgeCI_plot-1.png)

	![Session with pF 3](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/3_%5BNA%2C%20c%2C%20MFA_subs%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_subs__files/figure-markdown_github/plot_pf_sess-1.png)

	![Factor heatmaps 3 cp1](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/3_%5BNA%2C%20c%2C%20MFA_subs%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_subs__files/figure-markdown_github/grid_smheat_sigfj1-1.png)

	![Factor heatmaps 3 cp2](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/3_%5BNA%2C%20c%2C%20MFA_subs%5D/MSC_010208/MuSu__NA%2C_c%2C_MFA_subs__files/figure-markdown_github/grid_smheat_sigfj2-1.png)

2. HMFA-normalized network edges then subjects _without_ normalizing across sessions

	+ Subject 8 has a flat pattern within sessions so does not drive the component (see the second figure).

	![Factor map 7](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/7_%5BNA%2C%20c%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_c%2C_HMFA__files/figure-markdown_github/grid_f_netedgeCI_plot-1.png)

	![Session with pF 7](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/7_%5BNA%2C%20c%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_c%2C_HMFA__files/figure-markdown_github/plot_pf_sess-1.png)

	![Factor heatmaps 7 cp1](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/7_%5BNA%2C%20c%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_c%2C_HMFA__files/figure-markdown_github/grid_smheat_sigfj1-1.png)

	![Factor heatmaps 7 cp2](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/7_%5BNA%2C%20c%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_c%2C_HMFA__files/figure-markdown_github/grid_smheat_sigfj2-1.png)

3. HMFA-normalized network edges then subjects after normalizing across sessions

	+ The pattern is driven by subject 8 in session 5 and subject 2 in session 1. However, for session 5, subject 2 and 8 go in the same direction, which could be due to the exaggeration of subject 8's pattern.

	![Factor map 8](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/8_%5BNA%2C%20n%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_n%2C_HMFA__files/figure-markdown_github/grid_f_netedgeCI_plot-1.png)

	![Session with pF 8](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/8_%5BNA%2C%20n%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_n%2C_HMFA__files/figure-markdown_github/plot_pf_sess-1.png)

	![Factor heatmaps 8 cp1](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/8_%5BNA%2C%20n%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_n%2C_HMFA__files/figure-markdown_github/grid_smheat_sigfj1-1.png)

	![Factor heatmaps 8 cp2](https://github.com/mychan24/restinginpca/blob/master/res_MuSu/8_%5BNA%2C%20n%2C%20HMFA%5D/MSC010208/MuSu__NA%2C_n%2C_HMFA__files/figure-markdown_github/grid_smheat_sigfj2-1.png)

### Comments

+ [JY]

	+ I think think the results that are more meaningful are those from Analysis 3 and 7. Analysis 3 showed the general pattern difference across subjects and sessions with the contributions of each network determined by their size. Analysis 7 showed how the _common_ connectivity patterns among networks.

	+ As a result, Analysis 3 shows pattern across subjects and Analysis 7 shows pattern among network connectivities.

	+ Analysis 8 is more like a combination of both Analyses 3 and 7.
