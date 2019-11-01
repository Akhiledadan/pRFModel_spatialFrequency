args <- commandArgs(T)
print( args )

tempNameVolInstr1 <- sprintf( '%sWM.vol.temp', args[1] ) 
roiData <- read.table( args[1], comment.char='#' )
write.table(  roiData[,1], file=tempNameVolInstr1, col.names=FALSE, row.names=FALSE )

