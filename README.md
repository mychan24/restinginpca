# restinginpca

> A powerful distraction from real work.

### GOAL
Develop a technique that could analyze resting-state data and allow different participant to have different number of voxels/nodes.

### DATA WE WISH TO ANALYZE
condition x (voxel x participants)

### DATA WE USED TO TEST
+ Big5 FakeData: for STATIS-like normalization
+ Midnight Scan Club (MSC) publice online resting state data: for testing the normalization with multi-condition/multi-subject data

### HOW
###### New normalization that we come up with (Big5)
+ STATIS-like normalization
...So we test this first on one correlation matrix

###### Starts from data with same number of nodes (MSC)
+ Run DiSTATIS on an examplar sample and use this results as a sample of what we want to replicate
+ Try different normalization with subject 1:
...1. No normalization -> plain SVD
...2. SVD on STATIS-like preprocessed rectangular matrix
...3. Subject(table)-centered, block (network) MFA-normalized rectangular matrix
+ Try different normalization with multiple subjects (1-3):
