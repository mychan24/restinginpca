# Justification of each step

> This note explains how each step changes the data. From these explanations, we justify why we are analyzing the data with specific steps.

### Z-transforming the correlations:

+ How--

+ Why--

### Reshape correlation matrix as rectangular matrix:
	
+ How--

+ Why--

### For preprocessing:

1. double-centering the correlation matrix:

	+ How--

		For each symmetric correlation matrix, before being reshaped to a vector, the rows are first centered (i.e., each row has a mean of 0) and then the columns are too.

	+ Why--

		This step eliminates the offset of all (both between- and within-network) correlations of each region (i.e., each row and each column). This procedure could prevent the components from being dominated by a region with a strong average correlation.

2. centering the rows of the rectangular matrix:

	+ How--

		For the rectangular matrix of each subject (the rows correspond to the sessions whereas the columns correspond to the edges), each row is centered to have a mean of 0. This row-centered rectangular matrix of all subjects are then concatenated along the columns to generate the grand data table for the SVD.

	+ Why _not_--

		This procedure eliminates the difference in offsets across sesssions and only keep, within each session, the relative pattern accross edges. We do _NOT_ implement this procedure because, for the data we planned to apply this analysis, the rows will have different conditions instead, and we are interested in the magnitude difference between these conditions. Note that this step was chosen to be skipped only because it did not suit the data that motivated us to develop this technique.

3. centering the columns of the rectangular matrix:

	+ How--

	+ Why--

4. normalizing the rows of the rectangular matrix:

	+ How--

	+ Why--

5. normalizing the columns of the rectangular matrix:

	+ How--

	+ Why--

6. MFA-normalize subtables by subjects:

	+ How--

	+ Why--

7. MFA-normalize subtables by network edges:

	+ How--

	+ Why--

### Filtering factor scores based on their contributions:

+ How--

+ Why--
