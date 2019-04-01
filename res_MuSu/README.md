This directory contains all results using MuSu (different preprocessing)

> Updated 04/01/2019 by JY

*1_[NA,c,NA]*:

+ Center each column

*2_[NA,c-ss1,NA]*:

+ Center and scale (to SS = 1) each column

*3_[NA,c,MFA_subs]*:

+ Center each column

+ MFA-normalize the table of each subject

*4_[NA,c-ss1,MFA_subs]*:

+ Center and scale (to SS = 1) each column

+ Then, MFA-normalize the table of each subject

*5_[NA,c,MFA_NetEdge]*:

+ Center each column

+ MFA-normalize the tables of different network-edges

*6_[NA,c-ss1,MFA_NetEdge]*:

+ Center and scale (to SS = 1) each column

+ Then, MFA-normalize the tables of different network-edges

---
Each folder contains two subfolders:

*sub0108*:

+ Data: 
  
  + MSC 01, MSC 08

 + Purpose: 
   
   + See how data will look with a very bad sub (MSC 08)

*sub0102*:

+ Data: 
   
  + MSC 01, MSC02
   
   + Purpose: 
   
   + See how data will look with a similar subjects, do subject-diff still dominate? 
