# Justification of each step

> This note explains how each step changes the data. From these explanations, we justify why we are analyzing the data with specific steps.

### Fisher's Z-transforming the correlations:

+ How-- 

	The Pearson's correlation matrix (parcel x parcel) is transformed using the Fisher's z-transform formula: 0.5 * log((1+r)./(1-r))

+ Why-- 

	The typical reasoning is that the Fisher's z transformation shifts the distribution to become "normal-like" (approximately normal), which plays better with common statistical analysis being apply to the matrices (i.e., "common methods assuming the range from -Inf to Inf instead of bounding between -1 to 1" - Abdi meeting 2019).
	
### Removing negative edges
+ How-- 
	
	Setting negative edges in correlation matrix to 0. 
	
+ Why--

	The difference/change in netork connectivity cause by decreasing negative edge (increase slope in change) or increasing in positive edge (increase slope in change) are problematic if conflated together. It is possible to further analyze the data with negative edges included or analyzed separatly. 

### Reshape correlation matrix as rectangular matrix:

+ How--

	i) The upper-triangle of each subject's correlation matrix is reshaped as a vector (not including the diagonal, which has a correlation of 1, or Inf after Fisher's z-transoform). 
	ii) The vector of each session within a subject is stacked together, where each row is a session, and each column is a cell  extracted from the correlation matrix (i.e., an edge of a network). 
	iii) Each subject forms a sub-table, which is organized adjacent to each other in the column's dimesion. 
	iv) The resulting grandtable is a session by edge matrix, with sub-table (across columns) of subjects.
	v) The column of the grand table is labeled to identify its subject, within-btween, and edge-typ. 
		- Within-between represents whether the edge connects two nodes of the same brain systems (Within) or across different systems (Between).
		- Edge-type represents which exact brain systems is it connecting between (e.g., "3" = edge connecting two nodes from system #3; "3_12" = edge connecting a node from system #3 and #12).

+ Why--

	Since each subject uses a subject-specific parcellation as their node set, the resulting correlation matrix differs in dimension across subjects. In order to compare across subjects, there needs to be a way to organize the subjects and sessions within a single grand table. 

### For preprocessing:

1. double-centering the correlation matrix:

	+ How--

		For each symmetric correlation matrix, before being reshaped to a vector, the rows are first centered (i.e., each row has a mean of 0) and then the columns are too.

	+ Why--

		This step eliminates the offset of all (both between- and within-network) correlations of each region (i.e., each row and each column). This procedure could prevent the components from being dominated by a region with a strong average correlation.

2. centering the rows of the rectangular matrix:

	+ How--

		In the rectangular matrix of each subject (the rows correspond to the sessions whereas the columns correspond to the edges), each row is centered to have a mean of 0. This row-centered rectangular matrix of all subjects are then concatenated along the columns to generate the grand data table for the SVD.

	+ Why _not_--

		This procedure eliminates the difference in offsets across sesssions and only keep, within each session, the relative pattern accross edges. We do _NOT_ implement this procedure because, for the data we planned to apply this analysis, the rows will have different conditions instead, and we are interested in the magnitude difference between these conditions. Note that this step was chosen to be skipped only because it did not suit the data that motivated us to develop this technique.

3. centering the columns of the rectangular matrix:

	+ How--

		In the grand rectangular matrix where each sub-table corresponds to a subject (or an edge of a subject), each column is centered to have a mean of 0 before the SVD.

	+ Why-- 

		This procedure eliminates the difference in the offset of each edge (the offset of each edge across sessions) of each subject. In this case, for each edge of each subject, we analyze the difference between a connectivity and its average across sessions.

		This procedure also prevents the data from being unidimensional where the first dimension is dominated by the magnitude of the mean of the grand data table.

4. normalizing the rows of the rectangular matrix:

	+ How--

		In the rectangular matrix of each subject (the rows correspond to the sessions whereas the columns correspond to the edges), each row is normalized to have a sum of squares of 1. This row-normalized rectangular matrix of all subjects are then concatenated along the columns to generate the grand data table for the SVD.

	+ Why _not_--

		This procedure eliminates the difference in variance across sesssions and keep, within each session, the magnitude. We do _NOT_ implement this procedure because if the original data have a flat pattern (small variance), this step might enlarge noise.

		Also, these rows are not centered or normalized because these steps will make it hard to compare between rows. When both their magnitudes (centered) and variances (normalized) are equalized, we are only comparing the changes in relative patterns across sessions and subjects. Again, note that this step was chosen to be skipped only because it did not suit the data that motivated us to develop this technique.

5. normalizing the columns of the rectangular matrix:

	+ How--

		

	+ Why--

6. MFA-normalize sub-tables by subjects:

	+ How--
	
		Since each subject is a sub-table (like a grouping of variables), MFA-style noramlization was used to normalize the effect of subject. Each subject's sub-table is divided by the first singular value (sqrt(first eigvenvalue)matrix _equivalent_ of standard deviation) of that sub-table (do a PCA on the sub-table to get it).

	+ Why--
	
		Prevent outlier subject from dominating the space (??? MC is not sure...)

7. MFA-normalize sub-tables by network edges:

	+ How--

	+ Why--

### Filtering factor scores based on their contributions:

+ How--

+ Why--
