# restinginpca

> A powerful distraction from real work.

### GOAL
Develop a technique that could analyze resting-state data and allow different participant to have different number of voxels/nodes.

### Solution to test for
If, instead of using the square correlation (or distance) matrix, we arrange data as condition x (regions x participants). In this case, we can concatenate data of different participants on the columns (we think).
##### Problem
But how do we know what the svd of this gives us, and how is this different from a DiSTATIS on distance matrices? 

### DATA WE WISH TO ANALYZE
condition x (region x participants)

### DATA WE USED TO TEST
+ Big5 FakeData: for STATIS-like normalization
+ Midnight Scan Club (MSC) publice online resting state data: for testing the normalization with multi-condition/multi-subject data

### HOW
##### New normalization that we come up with (Big5)
+ STATIS-like normalization

⋅⋅⋅So we test this first on one correlation matrix

##### Starts from data with same number of nodes (MSC)
+ Run DiSTATIS on an examplar sample and use this results as a sample of what we want to replicate
+ Try different normalization with subjects 1:

⋅⋅⋅1. No normalization -> plain SVD

⋅⋅⋅2. SVD after the columns are centered (center across rows)

⋅⋅⋅3. SVD on STATIS-like preprocessed rectangular matrix

⋅⋅⋅4. Subject(table)-centered, block (network) MFA-normalized rectangular matrix

+ Try different normalization with multiple subjects (1-3):

