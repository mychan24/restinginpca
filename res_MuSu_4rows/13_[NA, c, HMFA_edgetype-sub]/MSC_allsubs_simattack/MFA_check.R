library(pander)
library(psych)
library(DistatisR)
library(RColorBrewer)
library(tidyverse)
library(magrittr)
library(PTCA4CATA)
library(ExPosition)
library(InPosition)
library(MExPosition)
library(superheat)
library(gridExtra)
library(ggplotify)
library(grid)
library(pals)

load("C:/Users/juchi/Box Sync/Abdi_lab/Colaborations/restinginpca/res_MuSu_4rows/7_[NA, c, HMFA]/MSC_allsubs_simattack/MuSu_simattack_4rows_7_HMFA-edgeteyp.RData")
load("C:/Users/juchi/Box Sync/Abdi_lab/Colaborations/restinginpca/res_MuSu_4rows/7_[NA, c, HMFA]/MSC_allsubs_simattack/MuSu_simattack_4rows_7_HMFA-edge.RData")

# session
mfa_preproc %*% t(mfa_preproc)
mfa.check_bwsq <- scale(mfa_preproc %*% t(mfa_preproc))
dev.new()
superheat(mfa.check_bwsq, 
          y.axis.reverse = T,
          heat.lim = c(-2,2),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200)
          )

# edgetype
mfa.check <- mfa_preproc %*% makeNominalData(as.matrix(gtlabel$subjects_wb))
mfa.check_bwsq <- t(mfa.check) %*% mfa.check
dev.new()
superheat(mfa.check_bwsq, 
          y.axis.reverse = T,
          heat.lim = c(-6000,6000),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          bottom.label.text.angle = 90, 
          bottom.label.text.alignment = 'center',
          bottom.label.text.size = 3)

# arranged with pretty columns/rows
dev.new()
superheat(mfa.check_bwsq, 
          pretty.order.rows = T,
          pretty.order.cols = T,
          y.axis.reverse = T,
          heat.lim = c(-6000,6000),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          bottom.label.text.angle = 90, 
          bottom.label.text.alignment = 'center',
          bottom.label.text.size = 3)

# edge
mfa.check <- mfa_preproc %*% makeNominalData(as.matrix(gtlabel$edges_label))
mfa.check.order <- mfa.check[,order(colnames(mfa.check))]
mfa.check_bwsq <- t(mfa.check.order) %*% mfa.check.order
mfa.check_bwsq.scale <- scale(mfa.check_bwsq) # double centered
mfa.check_bwsq.scale <- scale(t(mfa.check_bwsq)) # double centered

# non-scaled XtX
superheat(mfa.check_bwsq, 
          #heat.lim = c(-1*max(mfa.check_bwsq.scale), max(mfa.check_bwsq.scale)),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          y.axis.reverse = T,
          left.label.text.size = 2,
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          bottom.label.text.angle = 90, 
          bottom.label.text.alignment = 'center',
          bottom.label.text.size = 3)

# scaled XtX
superheat(mfa.check_bwsq.scale, 
          heat.lim = c(-1*max(mfa.check_bwsq.scale), max(mfa.check_bwsq.scale)),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          y.axis.reverse = T,
          left.label.text.size = 2,
          bottom.label.text.angle = 90, 
          bottom.label.text.alignment = 'center',
          bottom.label.text.size = 3)

# non-scaled XtX with pretty order for columns and rows
superheat(mfa.check_bwsq.scale, 
          heat.lim = c(-1*max(mfa.check_bwsq.scale), max(mfa.check_bwsq.scale)),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          y.axis.reverse = T,
          left.label.text.size = 2,
          bottom.label.text.angle = 90, 
          bottom.label.text.alignment = 'center',
          bottom.label.text.size = 3, 
          pretty.order.cols = T, 
          pretty.order.rows = T)

# scaled XtX with pretty order for columns and rows
dev.new()
superheat(mfa.check_bwsq.scale, 
          heat.lim = c(-1*max(mfa.check_bwsq.scale), max(mfa.check_bwsq.scale)),
          heat.pal = kovesi.diverging_bwr_40_95_c42(200),
          heat.pal.values = c(0,0.35,0.5,0.65,1),
          y.axis.reverse = T,
          left.label.text.size = 2,
          bottom.label.text.angle = 90, 
          bottom.label.text.alignment = 'center',
          bottom.label.text.size = 3, 
          pretty.order.cols = T, 
          pretty.order.rows = T)



