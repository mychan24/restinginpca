MuSu\_(NA, c, NA)
================

> This is an SVD with centered
columns.

##### Data:

###### The data are from the morning scan club (MSC) resting-state data where each of the 10 participants were scanned 10 times. The data that are analyzed here are the z-transformed coefficients of correlation between regions. These regions can be categorized into 12 networks:

| Comm |         Community         | CommLabel.short |
| :--: | :-----------------------: | :-------------: |
|  0   |         UnAssign          |      00Bd       |
|  1   |          Default          |      01DMN      |
|  2   |      lateral Visual       |     02lVis      |
|  3   |      Frontoparietal       |      03FPN      |
|  4   |       medial Visual       |     04mVis      |
|  5   |     dorsal Attention      |      05DAN      |
|  6   |         Premotor          |      06PMo      |
|  7   |     ventral Attention     |      07VAN      |
|  8   |         Salience          |      08SLC      |
|  9   |    Cingular opercular     |      09CON      |
|  10  |    Sensorimotor - hand    |     10hSMN      |
|  11  |    Sensorimotor - face    |     11fSMN      |
|  12  |         Auditory          |      12Aud      |
|  13  | anterior Medial temporal  |     13aMTL      |
|  14  | posterior Medial temporal |     14pMTL      |
|  15  |      Parietal memory      |      15PMN      |
|  16  |          Context          |      16CAN      |
|  17  |    Sensorimotor - foot    |     17fSMN      |
|  29  |          Unknown          |      18UN       |

###### As a result, the correlation matrix of each session of each subject will look like this:

![](MuSu__NA,_c,_NA__files/figure-gfm/data-1.png)<!-- -->

###### This correlation matrix were then turned into a rectangular matrix

#### Rectangular data:

  - Rows: 5 sessions

  - Columns: Different edges (e.g, *within DMN*, *between DMN & CON*,
    *between DMN & FPN*, etc.) of different subjects

*Note: The data was transformed from the upper triangle of the
correlation matrices. From the correlation matrix of each session, its
upper triangle are reshape as a vector. These sessions are concatenated
on the rows and these of different subjects are concatenated on the
columns.*

##### Method:

  - Centering: across sessions (rows) (i.e., the columns are centered)

  - Normalizing: none
