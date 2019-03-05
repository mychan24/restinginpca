# install.packages("magick")
library(magick)
library(pals)
library(superheat)
img <- image_graph(800, 1000)
out <- lapply(6:10, function(session.count){
  hmap <- superheat(cubes$zcube[,,session.count],
                    membership.cols = vox.des$Comm.rcd,
                    membership.rows = vox.des$Comm.rcd,
                    smooth.heat = T,
                    smooth.heat.type = 'mean',
                    clustering.method = NULL,
                    heat.lim = c(0,0.6), 
                    heat.pal = parula(20),
                    heat.pal.values = c(0, 0.5, 1),
                    left.label.size = 0.08,
                    bottom.label.size = 0.05,
                    y.axis.reverse = TRUE,
                    left.label.col = Comm.col$gc[order(rownames(Comm.col$gc))], # order by community name
                    bottom.label.col = Comm.col$gc[order(rownames(Comm.col$gc))],
                    left.label.text.size = 3,
                    bottom.label.text.size = 2,
                    left.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
                    bottom.label.text.col = c(rep("black",8),rep("white",2),rep("black",3),"white",rep("black",3),rep("white",2)),
                    left.label.text.alignment = "left",
                    title = sprintf("Correlation matrix of #%s session",session.count))
  print(hmap$plot)
})
dev.off()
sess.animate <- image_animate(img, fps = 4)
# print(sess.animate)
image_write(sess.animate, "subj_1(6-10)_mean.gif")
