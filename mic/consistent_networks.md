Extract Consistent Networks
================

### Find consistent networks across subjects

``` r
nsub <- 10
# Load all parcel-list
parcel <- list()
comm <- list()
for(i in 1:nsub){
  parcel[[i]] <- read.table(sprintf("../data/parcel_community/sub-MSC%02d_node_parcel_comm.txt", i), sep=",")
  comm[[i]] <- unique(parcel[[i]]$V3)
  
  if(i==1){
    consistent_comm <- comm[[i]]
  }else{
    consistent_comm <- consistent_comm[is.element(consistent_comm, comm[[i]])]
  }
}
consistent_comm <- sort(consistent_comm) 
consistent_comm <- consistent_comm[2:length(consistent_comm)] # Take out 0 (bad network)
```

### Which are the consistent networks?

``` r
syslabel <- read.csv("../data/parcel_community/systemlabel.txt", header=F)
consistent_syslabel <- syslabel[is.element(syslabel$V1, consistent_comm),]

kableExtra::kable(consistent_syslabel)
```

<table>
<thead>
<tr>
<th style="text-align:left;">
</th>
<th style="text-align:right;">
V1
</th>
<th style="text-align:left;">
V2
</th>
<th style="text-align:left;">
V3
</th>
<th style="text-align:left;">
V4
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
2
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:left;">
01\_Default
</td>
<td style="text-align:left;">
\#FF0000
</td>
<td style="text-align:left;">
01DMN
</td>
</tr>
<tr>
<td style="text-align:left;">
3
</td>
<td style="text-align:right;">
2
</td>
<td style="text-align:left;">
02\_LatVis
</td>
<td style="text-align:left;">
\#0000FF
</td>
<td style="text-align:left;">
02lVis
</td>
</tr>
<tr>
<td style="text-align:left;">
4
</td>
<td style="text-align:right;">
3
</td>
<td style="text-align:left;">
03\_FrontoPar
</td>
<td style="text-align:left;">
\#FFFF00
</td>
<td style="text-align:left;">
03FPN
</td>
</tr>
<tr>
<td style="text-align:left;">
6
</td>
<td style="text-align:right;">
5
</td>
<td style="text-align:left;">
05\_DorsAttn
</td>
<td style="text-align:left;">
\#00FF00
</td>
<td style="text-align:left;">
05DAN
</td>
</tr>
<tr>
<td style="text-align:left;">
7
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:left;">
06\_Premotor
</td>
<td style="text-align:left;">
\#FF99FF
</td>
<td style="text-align:left;">
06PMo
</td>
</tr>
<tr>
<td style="text-align:left;">
10
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:left;">
09\_CingOperc
</td>
<td style="text-align:left;">
\#800080
</td>
<td style="text-align:left;">
09CON
</td>
</tr>
<tr>
<td style="text-align:left;">
11
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:left;">
10\_HandSM
</td>
<td style="text-align:left;">
\#00FFFF
</td>
<td style="text-align:left;">
10hSMN
</td>
</tr>
<tr>
<td style="text-align:left;">
12
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:left;">
11\_FaceSM
</td>
<td style="text-align:left;">
\#FF8000
</td>
<td style="text-align:left;">
11faSMN
</td>
</tr>
<tr>
<td style="text-align:left;">
13
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:left;">
12\_Auditory
</td>
<td style="text-align:left;">
\#9933FF
</td>
<td style="text-align:left;">
12Aud
</td>
</tr>
<tr>
<td style="text-align:left;">
14
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:left;">
13\_AntMTL
</td>
<td style="text-align:left;">
\#004C99
</td>
<td style="text-align:left;">
13aMTL
</td>
</tr>
<tr>
<td style="text-align:left;">
16
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:left;">
15\_ParMemory
</td>
<td style="text-align:left;">
\#0080FF
</td>
<td style="text-align:left;">
15PMN
</td>
</tr>
</tbody>
</table>
### How many nodes per network in each sub

``` r
tally <- data.frame(matrix(NA, nsub, length(consistent_comm)))
colnames(tally) <- consistent_syslabel$V2
tally$sub <- sapply(X = c(1:10), FUN = function(x){sprintf("sub%02d", x)})
tally <- tally[,c(ncol(tally), 1:(ncol(tally)-1))]

for(i in 1:nsub){
  tally[i,2:ncol(tally)]<- unlist(lapply(X = consistent_comm, FUN = function(x){sum(parcel[[i]]$V3==x)}))
}

kableExtra::kable(tally, caption = "How many nodes are in each consistent network per subject")
```

<table>
<caption>
How many nodes are in each consistent network per subject
</caption>
<thead>
<tr>
<th style="text-align:left;">
sub
</th>
<th style="text-align:right;">
01\_Default
</th>
<th style="text-align:right;">
02\_LatVis
</th>
<th style="text-align:right;">
03\_FrontoPar
</th>
<th style="text-align:right;">
05\_DorsAttn
</th>
<th style="text-align:right;">
06\_Premotor
</th>
<th style="text-align:right;">
09\_CingOperc
</th>
<th style="text-align:right;">
10\_HandSM
</th>
<th style="text-align:right;">
11\_FaceSM
</th>
<th style="text-align:right;">
12\_Auditory
</th>
<th style="text-align:right;">
13\_AntMTL
</th>
<th style="text-align:right;">
15\_ParMemory
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
sub01
</td>
<td style="text-align:right;">
78
</td>
<td style="text-align:right;">
53
</td>
<td style="text-align:right;">
99
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
7
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
15
</td>
</tr>
<tr>
<td style="text-align:left;">
sub02
</td>
<td style="text-align:right;">
69
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
26
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
6
</td>
</tr>
<tr>
<td style="text-align:left;">
sub03
</td>
<td style="text-align:right;">
95
</td>
<td style="text-align:right;">
54
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
60
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
11
</td>
</tr>
<tr>
<td style="text-align:left;">
sub04
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
20
</td>
<td style="text-align:right;">
19
</td>
<td style="text-align:right;">
88
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
70
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
15
</td>
</tr>
<tr>
<td style="text-align:left;">
sub05
</td>
<td style="text-align:right;">
89
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
90
</td>
<td style="text-align:right;">
38
</td>
<td style="text-align:right;">
14
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
23
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
8
</td>
<td style="text-align:right;">
8
</td>
</tr>
<tr>
<td style="text-align:left;">
sub06
</td>
<td style="text-align:right;">
106
</td>
<td style="text-align:right;">
63
</td>
<td style="text-align:right;">
52
</td>
<td style="text-align:right;">
47
</td>
<td style="text-align:right;">
6
</td>
<td style="text-align:right;">
123
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
15
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
3
</td>
</tr>
<tr>
<td style="text-align:left;">
sub07
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
79
</td>
<td style="text-align:right;">
81
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
62
</td>
<td style="text-align:right;">
51
</td>
<td style="text-align:right;">
18
</td>
<td style="text-align:right;">
59
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
12
</td>
</tr>
<tr>
<td style="text-align:left;">
sub08
</td>
<td style="text-align:right;">
111
</td>
<td style="text-align:right;">
96
</td>
<td style="text-align:right;">
46
</td>
<td style="text-align:right;">
64
</td>
<td style="text-align:right;">
11
</td>
<td style="text-align:right;">
84
</td>
<td style="text-align:right;">
58
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
34
</td>
<td style="text-align:right;">
28
</td>
</tr>
<tr>
<td style="text-align:left;">
sub09
</td>
<td style="text-align:right;">
71
</td>
<td style="text-align:right;">
42
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
57
</td>
<td style="text-align:right;">
25
</td>
<td style="text-align:right;">
17
</td>
<td style="text-align:right;">
21
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
82
</td>
<td style="text-align:right;">
16
</td>
<td style="text-align:right;">
16
</td>
</tr>
<tr>
<td style="text-align:left;">
sub10
</td>
<td style="text-align:right;">
100
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:right;">
100
</td>
<td style="text-align:right;">
28
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:right;">
92
</td>
<td style="text-align:right;">
12
</td>
<td style="text-align:right;">
73
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:right;">
11
</td>
</tr>
</tbody>
</table>
### Extract parcels that belong to consistent community export

``` r
# consistent_parcel <- lapply(parcel, FUN = function(x){x[is.element(x$V3, consistent_comm),]})
# 
# for(i in 1:nsub){
#   write.table(x = consistent_parcel[[i]], file = sprintf("../data/parcel_community/bignetwork/sub-MSC%02d_node_parcel_bigcomm.txt",i), sep = ",", quote = F, col.names = F)
# }
# 
# write.table(consistent_syslabel, file="../data/parcel_community/bignetwork/systemlabel_bigcomm.txt",sep=",", quote = F, col.names = F)
```
