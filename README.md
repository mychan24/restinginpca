# restinginpca

> A powerful distraction from real work.

### GOAL
Develop a technique that could analyze resting-state data and allow different participant to have different number of voxels/nodes.

### Solution to test for
If, instead of using the square correlation (or distance) matrix, we arrange data as condition x (regions x participants). In this case, we can concatenate data of different participants on the columns (we think).
#### Problem
But how do we know what the svd of this gives us, and how is this different from a DiSTATIS on distance matrices?

_We cannot compare the two sets of results because they don't have the same observations/variables

__What Normalization should we use?

__How do we bootstrap? (All random factors need to be bootstrapped.)

__How can we do an ANOVA-like comparison for the sessions

### DATA WE WISH TO ANALYZE
condition x (region x participants)

### DATA WE USED TO TEST
+ Big5 FakeData: for STATIS-like normalization (in _archive_)
+ Midnight Scan Club (MSC) publice online resting state data: for testing the normalization with multi-condition/multi-subject data

### HOW
##### Use MSC data where each subject has different numbers of regions (sometimes networks):

+ Try different normalization with multi-subjects data:

  Rectangular data structure: 5 sessions x (region-region edges x 2 subjects)

  1. SVD after the columns are centered (center across rows)

  2. SVD after the columns are centered and normalized (center and normalize across rows)

  3. MFA-normalized  (or _sumPCA_) rectangular matrix by subjects without normalizing across rows

  4. MFA-normalized rectangular matrix by subjects after normalizing across rows

  5. MFA-normalized rectangular matrix by networks without normalizing across rows

  6. MFA-normalized rectangular matrix by networks after normalizing across rows

  7. HMFA-normalized rectangular matrix by networks and subject without normalizing across rows

  8. HMFA-normalized rectangular matrix by networks and subject after normalizing across rows
