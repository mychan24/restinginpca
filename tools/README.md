This folder stores functions we wrote for this project.

>Edited by JCY, 08/07/2019

---

### Functions

* *cube2gt*:
---Take paths to correlation cube (z matrix) & community labels to output grand table 
* *label_edge*:
---Take a community label vector and output a vector of label for edges
* *SScomm*:
---For each table along the third dimension of an array, compute sums of squares of each category according to a design matrix and output as an array
* *tp_to_rz*:
---Load TP (node x timepoint matrix) and ouptut correlation matrix (z or r matrix)
* *vec2sqmat*:
---Load a vector (e.g., factor scores) and map it back into a symmetrical square matrix
* *getVoxDes*:
---Generate the design matrix for regions and color matrix from the parcellation of each subject's correlation matrix
---

### Script:

* *animation_script*:
---Create .gif for animation that shows 10 session of one subject

* *gt_allsubs*:
---Get grand tables (reshaped correlation cubes) for all subject

* *gt_bignetworks_allsubs*:
---Get the grand data table that only have the common networks across subjects