suppressMessages(library(PTCA4CATA))

tictoc::tic()
BootCube.Comm.edge <- Boot4Mean(mean.fj,
                                parallelize = T,
                                design = mean.fj.label$edge,
                                niter = 100,
                                suppressProgressBar = TRUE)
tictoc::toc()