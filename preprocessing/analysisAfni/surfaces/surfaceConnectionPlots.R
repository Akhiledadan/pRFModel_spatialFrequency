rm( list=ls() )
library(abind)



participantArray <- c('SD', 'BH', 'VK', 'AF', 'AF01', 'RB' ) #SD BH VK AF AF01 RB
#participantArray <- c('SD', 'BH' ) #SD BH VK AF AF01 RB
boldAngleArray <- array( 0, c( length(participantArray), 10, 16, 7 ) )
depthArrayAngle <- array( 0, c( length(participantArray), 16, 3, 4  ) )
depthArray <- array( 0, c( length(participantArray), 16, 3  ) )
storeBold <- array( 0, c( length(participantArray), 16, 3, 3  ) )


mainDirSavePlots <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW'


for ( nPart in 1:length(participantArray) ) {
#for ( nPart in 1:1 ) {
  
  roiFlag <- 2
    
  #nPart <- 5
  participant <- participantArray[ nPart ]    
  
  graphics.off()
  if (participant=='BH') {
    mainDir <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW/V5029leftright_Ben_ph/results_CBS'
    statDir <- 'statsSingleShot+orig_interp_folder_smoothed_5'
    roiDirRight <- 'rightRoi_folder'
    roiDirLeft <- 'leftRoi_folder'
    curvatureDir <- 'curvature_interp_folder_smoothed_8'
    thicknessDir <- 'thickness_interp_folder'
    amplitudeDir <- 'amplitudeSingleShot+orig_interp_folder_smoothed_5'
    anatomyDir <- 'anatomy_interp_folder' 
    B0angleDir <- 'B0Angles_multiple/B0_angle_smoothed_5_1-2-1'  
    setwd(mainDir)
    if ( roiFlag==0 ) { load( 'BH_image_roi.RData' ) }
    if ( roiFlag==1 ) { load( 'BH_image_V1.RData' ) }
    if ( roiFlag==2 ) { load( 'BH_image_V1_no_smoothing.RData' ) }
    angleShift <- 20
  }
  
  if (participant=='VK') {
    mainDir <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW/V2699leftright_Vin/results_CBS'
    statDir <- 'statsSingleShotEPI_add_interp_folder_smoothed_5'
    roiDirRight <- 'rightRoi_folder'
    roiDirLeft <- 'leftRoi_folder'
    curvatureDir <- 'curvatureCopy_interp_folder_smoothed_8'
    thicknessDir <- 'thicknessCopy_interp_folder'
    amplitudeDir <- 'amplitudeAnatomyEPI_add_interp_folder_smoothed_5'
    anatomyDir <- 'anatomyCopy_interp_folder' 
    B0angleDir <- 'B0Angles_multiple/B0_angle_smoothed_5_00-1'  
    setwd(mainDir)
    if ( roiFlag==0 ) { load( 'VK_image_roi.RData' )  }
    if ( roiFlag==1 ) { load( 'VK_image_V1.RData' )  }
    if ( roiFlag==2 ) { load( 'VK_image_V1_no_smoothing.RData' )  }
    angleShift <- -10
  }
  
  if (participant=='AF') {
    mainDir <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW/V2678leftright_Ale/results_CBS'
    statDir <- 'statsSingleShotEPI_add+orig_interp_folder_smoothed_5'
    roiDirRight <- 'rightRoi_folder'
    roiDirLeft <- 'leftRoi_folder'
    curvatureDir <- 'curvature_interp_folder_smoothed_8'
    thicknessDir <- 'thickness_interp_folder'
    amplitudeDir <- 'amplitudeSingleShotEPI_add+orig_interp_folder_smoothed_5'
    anatomyDir <- 'anatomy_interp_folder' 
    B0angleDir <- 'B0Angles_multiple/B0_angle_smoothed_5_-1-1-1'  
    setwd(mainDir)
    if ( roiFlag==0 ) { load( 'AF_image_roi.RData' ) }
    if ( roiFlag==1 ) { load( 'AF_image_V1.RData' ) }
    if ( roiFlag==2 ) { load( 'AF_image_V1_no_smoothing.RData' ) }
    
    angleShift <- 0
  }
  
  if (participant=='AF01') {
    mainDir <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW/V4847leftright_Ale_ph/results_CBS'
    statDir <- 'statsSingleShotEPI_add_interp_folder_smoothed_5'
    roiDirRight <- 'rightRoi_folder'
    roiDirLeft <- 'leftRoi_folder'
    curvatureDir <- 'curvature_interp_folder_smoothed_8'
    thicknessDir <- 'thickness_interp_folder'
    amplitudeDir <- 'amplitudeSingleShotEPI_add_interp_folder_smoothed_5'
    anatomyDir <- 'anatomy_interp_folder' 
    B0angleDir <- 'B0Angles_multiple/B0_angle_smoothed_5_222'  
    setwd(mainDir)
    if ( roiFlag==0 ) { load( 'AF01_image_roi.RData' ) }
    if ( roiFlag==1 ) { load( 'AF01_image_V1.RData' ) }
    if ( roiFlag==2 ) { load( 'AF01_image_V1_no_smoothing.RData' ) }
    angleShift <- -30
  }
  
  
  if (participant=='SD') {
    mainDir <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW/V2676leftright_Ser/results_CBS'  
    statDir <- 'statsSingleShotEPI_add+orig_interp_folder_smoothed_5'
    roiDirRight <- 'rightRoi_folder'
    roiDirLeft <- 'leftRoi_folder'  
    curvatureDir <- 'curvatureCopy_interp_folder_smoothed_8'
    thicknessDir <- 'thicknessCopy_interp_folder'  
    amplitudeDir <- 'amplitudeSingleShotEPI_add+orig_interp_folder_smoothed_5'
    anatomyDir <- 'anatomyCopy_interp_folder'
    B0angleDir <- 'B0Angles_multiple/B0_angle_smoothed_5_-10-1'  
    setwd(mainDir)
    if ( roiFlag==0 ) { load( 'SD_image_roi.RData' )  }
    if ( roiFlag==1 ) { load( 'SD_image_V1.RData' )  }
    if ( roiFlag==2 ) { load( 'SD_image_V1_no_smoothing.RData' )  }
    angleShift <- 0
  }
  
  if (participant=='RB') {
    mainDir <- '/media/alessiofracasso/storage2/dataLaminar_leftVSrightNEW/V2677leftright_Ric/resultsCBS'  
    statDir <- 'statsSingleShotEPI_add_interp_folder_smoothed_5'
    roiDirRight <- 'rightRoi_folder'
    roiDirLeft <- 'leftRoi_folder'  
    curvatureDir <- 'curvatureCopy_interp_folder_smoothed_8'
    thicknessDir <- 'thicknessCopy_interp_folder'
    amplitudeDir <- 'amplitudeSingleShotEPI_add_interp_folder_smoothed_5'
    anatomyDir <- 'anatomyCopy_interp_folder'
    B0angleDir <- 'B0Angles_multiple/B0_angle_smoothed_5_-2-2-2'  
    setwd(mainDir)
    if ( roiFlag==0 ) { load( 'RB_image_roi.RData' ) }
    if ( roiFlag==1 ) { load( 'RB_image_V1.RData' ) }
    if ( roiFlag==2 ) { load( 'RB_image_V1_no_smoothing.RData' ) }
    angleShift <- 45
  }
  
  
  source('/home/alessiofracasso/Dropbox/analysisAfni/load1DData.R')
  source('/home/alessiofracasso/Dropbox/analysisAfni/generateProfiles.R')
  source('/home/alessiofracasso/Dropbox/analysisAfni/scaleData.R')
    
    
  delRows <- c( intensityRightStruct$unconnectedPoints, intensityLeftStruct$unconnectedPoints )
  filtRows <- which( delRows==0 )
  if ( length( filtRows ) > 0 ) { delRows <- delRows[-filtRows] }
  
  rm( naEl )
  if (length( delRows ) > 0) { naEl <- unique( c( which(is.na(rankProfiles)), delRows ) ) }
  if (length( delRows ) == 0) { naEl <- unique( c( which( is.na( rankProfiles ) ) ) )  }
  naEl
  
  surfValRight <- data.frame( surfValListRight[[10]] )
  surfValLeft <- data.frame( surfValListLeft[[10]] )
  surfVal <- c( surfValRight[,1], surfValLeft[,1] )
  
  dim(intensity)[1]
  length(rankProfiles)
  length(surfVal)
  
  xVar <- seq(2,17)
  
  boldMedian <- apply( intensity[,xVar,1], 1, median )  
  boldFilt <- which( boldMedian < quantile( boldMedian, c( 0.025 ) ) | boldMedian > quantile( boldMedian, c( 0.975 ) ) )
  curvMedian <- apply( intensity[ ,xVar, 3 ], 1, median  )
  curvFilt <- which( curvMedian < -0.7 | curvMedian > 0.7 )
  thickMedian <- apply( intensity[ ,xVar, 4 ], 1, median  )
  thickFilt <- which( thickMedian < 1 | thickMedian > quantile(thickMedian,0.975)   )
  anatMin <- apply( intensity[ ,xVar, 7 ], 1, min  )
  anatFilt <- which( anatMin <= 12000 | anatMin > 40000 )  
  tZero <- apply( intensity[,xVar,8], 1, median )
  tMeanFilt <- which( tZero<1.945 )
  
  storeAmp <- rep( 0, dim(intensity)[1] )
  for ( k in 1:dim(intensity)[1] ) {
    sCorPearAll <- cor( intensity[ k, xVar, 5 ], xVar, method = c('pearson') )
    storeAmp[ k ] <- sCorPearAll
  }
  ampFilt <- which( storeAmp < 0 )
  
  naElOut <- unique( c( naEl, anatFilt, thickFilt, curvFilt, tMeanFilt, ampFilt ) )
  length(naElOut)
  
  tZeroFilt <- tZero[ -naElOut ]
  intensityFilt <- intensity[-naElOut,,]
  rankProfilesFilt <- rankProfiles[-naElOut]
  surfValFilt <- surfVal[-naElOut]

  angles <- intensityFilt[,,9] + angleShift
  
  storeCoeff <- array( 0, c( dim(intensityFilt)[1], 6 ) )  
  storeResAngle <- array( 0, c( dim( angles )[1], length(xVar) ) )
  for ( k in 1:dim(intensityFilt)[1] ) {
    modBoldAngle <- summary( lm( intensityFilt[ k, xVar, 1 ] ~ angles[k,xVar]  ) )
    storeResAngle[k,] <- residuals( modBoldAngle ) 
      
    modBold <- summary( lm( intensityFilt[ k, xVar, 1 ] ~ xVar  ) )
        
    sCorSpear <- cor( intensityFilt[ k, xVar, 1 ], xVar, method = c('spearman') )
    sCorPear <- cor( intensityFilt[ k, xVar, 1 ], xVar, method = c('pearson') )
    
    sCorPearAmp <- cor( intensityFilt[ k, xVar, 5 ], xVar, method = c('spearman') )
    
    storeCoeff[k,] <- c( modBold$coefficients[1:2,1], modBold$r.squared, sCorSpear, sCorPear, sCorPearAmp )   
  }
  
  rankProfiles <- storeCoeff[,5]
  rankProfilesBin <- cut( rankProfiles, breaks=quantile( rankProfiles, probs=c(0,0.33,0.66,1) ), include.lowest=TRUE )
  rankProfilesBinNumeric <- as.numeric( rankProfilesBin )
    
  #plot(  )
  
  #aggData <- aggregate( storeResAngle, by=list(rankProfilesBinNumeric), FUN=mean)  
  #matplot( t( aggData[ , 2:dim(aggData)[2] ] ), bty='n', xlab='cortical depth', ylab='% BOLD (contra-lateral)', axes=FALSE, pch=19 )
  #axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  #axis(2, round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=3), 1 ), 
  #     round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=3), 1 ), las=1 )
  
  x11(height=9.5, width=6.5)
  par(mfrow=c(4,3))
  
  aggData <- apply( intensityFilt[,xVar,1], 2, FUN=mean)  
  plot( aggData, bty='n', xlab='cortical depth', ylab='% BOLD (contra-lateral)', axes=FALSE, pch=19, type='l', lwd=2, lty=1  )
  axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  axis(2, round( seq(min(aggData),max(aggData),length.out=3), 1 ), 
       round( seq(min(aggData),max(aggData),length.out=3), 1 ), las=1 )

  aggData <- apply( intensityFilt[,xVar,2], 2, FUN=mean)  
  plot( aggData, bty='n', xlab='cortical depth', ylab='% BOLD (ipsi-lateral)', axes=FALSE, pch=19, type='l', lwd=2, lty=1  )
  axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  axis(2, round( seq(min(aggData),max(aggData),length.out=3), 1 ), 
       round( seq(min(aggData),max(aggData),length.out=3), 1 ), las=1 )
  
  aggData <- apply( intensityFilt[,xVar,5], 2, FUN=mean)  
  plot( aggData, bty='n', xlab='cortical depth', ylab='raw BOLD', axes=FALSE, pch=19, type='l', lwd=2, lty=1  )
  axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  axis(2, round( seq(min(aggData),max(aggData),length.out=3), 1 ), 
       round( seq(min(aggData),max(aggData),length.out=3), 1 ), las=0 )  
  
  aggData <- aggregate( intensityFilt[,xVar,1], by=list(rankProfilesBinNumeric), FUN=mean)  
  matplot( t( aggData[ , 2:dim(aggData)[2] ] ), bty='n', xlab='cortical depth', ylab='% BOLD (contra-lateral)', axes=FALSE, pch=19, type='l', lwd=2, lty=1  )
  axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  axis(2, round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=3), 1 ), 
       round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=3), 1 ), las=1 )
  storeBold[nPart,,,1] <- t( aggData[,2:dim(aggData)[2]] )
  
  aggData <- aggregate( intensityFilt[,xVar,2], by=list(rankProfilesBinNumeric), FUN=mean)
  matplot( t( aggData[ , 2:dim(aggData)[2] ] ), bty='n', xlab='cortical depth', ylab='% BOLD (ipsi-lateral)', axes=FALSE, pch=19, type='l', lwd=2, lty=1  )
  axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  axis(2, round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=3), 1 ), 
       round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=3), 1 ), las=1 )
  storeBold[nPart,,,2] <- t( aggData[,2:dim(aggData)[2]] )
  
  aggData <- aggregate( intensityFilt[,xVar,5], by=list(rankProfilesBinNumeric), FUN=mean)
  matplot( t( aggData[ , 2:dim(aggData)[2] ] ), bty='n', xlab='cortical depth', ylab='raw BOLD', axes=FALSE, pch=19, type='l', lwd=2, lty=1  )
  axis(1, seq(1,length(xVar),length.out=3), seq(0,1,0.5) )
  axis(2, round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=2), 1 ), 
       round( seq(min(aggData[ , 2:dim(aggData)[2] ]),max(aggData[ , 2:dim(aggData)[2] ]),length.out=2), 1 ), las=0 )
  storeBold[nPart,,,3] <- t( aggData[,2:dim(aggData)[2]] )
        
  mydata <- intensityFilt[,xVar,7]
  library(cluster)  
  clust.out <- pam(mydata, 2)
  prop.table( table( clust.out$clustering ) )
  aggData <- aggregate(mydata,by=list(clust.out$clustering),FUN=mean)    
  bigAverage <- apply( mydata, 2, median )
  bigAverage <- bigAverage[2:length(bigAverage)]
  xValues <- seq(0,1,length.out=length(bigAverage))
  plot( bigAverage~xValues, 
        bty='n', las=1, xlab='cortical depth',
        ylab='T1 intensity', pch=20, cex=1.5, type='l', lwd=2, lty=1,
        axes=FALSE, xlim=c(0,1), ylim=c(min( bigAverage ), max( bigAverage ))   )
  axis( 1, c(0,0.5,1), c(0,0.5,1) )
  axis( 2, seq( min( bigAverage ), max( bigAverage ),length.out=3 ) )
  #plot( as.numeric( aggData[ 1, 3:dim(aggData)[2] ] )~xValues[2:length(xValues)], bty='n', las=1, xlab='cortical depth', ylab='T1 intensity', pch=20, cex=1.5, type='l', lwd=2, lty=1  )
  #plot( as.numeric( aggData[ 2, 3:dim(aggData)[2] ] )~xValues[2:length(xValues)], bty='n', las=1, xlab='cortical depth', ylab='T1 intensity', pch=20, cex=1.5, type='l', lwd=2, lty=1  )
  
  pSteps <- seq(0.35,0.99,0.01)
  posProfileMatrix <- array( 0, c( length( pSteps ), 25 ) )
  for ( k in 1:length( pSteps ) ) {
    rankThr <- quantile( rankProfiles, probs=pSteps[k] )
    splitVar <- ifelse( rankProfiles<=rankThr, 1, 2 )
    
    posProfileTemp <- apply( intensityFilt[ splitVar==1, xVar, 1 ], 2, mean )
    sp <- smooth.spline( posProfileTemp, spar=0.5 )
    xOut <- seq(1,14,length.out=25)
    spInt <- predict(sp,xOut)
    
    posProfileMatrix[k,] <- scaleData( spInt$y, 1, 0 )  
  }  
  image( t( posProfileMatrix ), col=rainbow(1000, start=0.2, end=0.85), las=1 )
  
  
  dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, participant ,'boldCorticalThicknessRank' ), height=9.5, width=6.5)
  dev.off()
  
  
  ## write out ROI as a map (to double check the mapping)
  nBins <- length( unique( rankProfilesBinNumeric ) )
  rankProfilesBinNumericFlag <- array( 0, c( length( rankProfilesBinNumeric ), nBins ) )
  for ( k in 1:nBins ) {
    rankProfilesBinNumericFlag[ rankProfilesBinNumeric==k, k ] <- 1
  }
  emptyMap <- array( 0, c( dim( mapValListStat[[10]] )[1], 5+nBins ) )
  emptyMap[,1] <- seq( 0, dim(emptyMap)[1]-1 )
  emptyMap[ surfValFilt+1, 2 ] <- 1
  emptyMap[ surfValFilt+1, 3 ] <- rankProfilesBinNumeric
  emptyMap[ surfValFilt+1, 4 ] <- rankProfiles
  emptyMap[ surfValFilt+1, 5 ] <- tZeroFilt
  emptyMap[ surfValFilt+1, seq(6,5+nBins) ] <- rankProfilesBinNumericFlag
  setwd(mainDir)
  write.table( emptyMap, file='storeMap01.1D', row.names=FALSE, col.names=FALSE )
  
  
  
  ## shift data accordingly

  angles <- intensityFilt[,,9] + angleShift
  angles <- ifelse( angles>180, angles-180, angles )
  angles <- ifelse( angles<0, angles+180, angles )  
    
  ## plot
  x11(height=7.5, width=7.5)
  par(mfrow=c(4,4))
  xValues <- seq(0,1,length.out=length(xVar))
  storeValues <- array(0,c(length(xVar),1))
  for (k in 1:length(xVar)) {
    surfNum <- k
    B0angleBreaks <- cut( angles[,surfNum], breaks = quantile( angles[,surfNum], seq(0,1,0.1) ), include.lowest=TRUE )
    #B0angleBreaks <- cut( intensityFilt[,surfNum,9], breaks = seq(0,180,30), include.lowest=TRUE )
    bold_angle <- tapply( intensityFilt[,surfNum,1], list( B0angleBreaks ), median  )
    B0_angle <- tapply( angles[,surfNum], list( B0angleBreaks ), median  )
    B0_angle2 <- B0_angle^2 
    cosPred <- cos( (B0_angle)*pi/180 )^2
    linPred <- seq( min(cosPred), max(cosPred), length.out=length(cosPred) )  
    modCos <- lm( bold_angle ~ cosPred ) 
    sModCos <- summary( modCos )
    predMod <- predict( modCos, data.frame( cosPred ) )
    
    #x01 <- cos( seq(40,170,length.out=length(cosPred))*pi/180 )^2
    #predMod01 <- predict( modCos, data.frame( x01 ) )  
    
    plot( bold_angle ~ B0_angle, xlim=c(0,180), bty='n', pch=15, cex=1 )    
    interpData <- spline( B0_angle, predMod, n=50, xout=seq(40,140,10) )
    
    #lines( B0_angle, predMod, lwd=2, col='red' )
    lines( interpData$x, interpData$y, lwd=2, col='red' )
    
    #lines( seq(40,170,length.out=length(cosPred)), predMod01, lwd=2, col='blue' )
    storeValues[k] <- sModCos$r.squared 
    
    boldAngleArray[ nPart, , k, 1 ] <- bold_angle
    boldAngleArray[ nPart, , k, 2 ] <- rep( sModCos$r.squared, length(bold_angle)  )
    
  }
  dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, participant ,'raw_bold_positive_angle' ), height=7.5, width=7.5)
  #dev.off()
  
  
  
  x11(height=7.5, width=7.5)
  par(mfrow=c(4,4))
  xValues <- seq(0,1,length.out=length(xVar))
  storeValues <- array(0,c(length(xVar),1))
  for (k in 1:length(xVar)) {
    surfNum <- k
    B0angleBreaks <- cut( angles[,surfNum], breaks = quantile( angles[,surfNum], seq(0,1,0.1) ), include.lowest=TRUE )
    #B0angleBreaks <- cut( intensityFilt[,surfNum,9], breaks = seq(0,180,30), include.lowest=TRUE )
    bold_angle <- tapply( intensityFilt[,surfNum,2], list( B0angleBreaks ), median  )
    B0_angle <- tapply( angles[,surfNum], list( B0angleBreaks ), median  )
    B0_angle2 <- B0_angle^2 
    cosPred <- cos( (B0_angle)*pi/180 )^2
    linPred <- seq( min(cosPred), max(cosPred), length.out=length(cosPred) )  
    modCos <- lm( bold_angle ~ cosPred ) 
    sModCos <- summary( modCos )
    predMod <- predict( modCos, data.frame( cosPred ) )
    
    #x01 <- cos( seq(40,170,length.out=length(cosPred))*pi/180 )^2
    #predMod01 <- predict( modCos, data.frame( x01 ) )  
    
    plot( bold_angle ~ B0_angle, xlim=c(0,180), bty='n', pch=15, cex=1 )    
    interpData <- spline( B0_angle, predMod, n=50, xout=seq(40,140,10) )
    
    #lines( B0_angle, predMod, lwd=2, col='red' )
    lines( interpData$x, interpData$y, lwd=2, col='red' )
    
    #lines( seq(40,170,length.out=length(cosPred)), predMod01, lwd=2, col='blue' )
    storeValues[k] <- sModCos$r.squared 
    
    boldAngleArray[ nPart, , k, 3 ] <- bold_angle    
    boldAngleArray[ nPart, , k, 4 ] <- rep( sModCos$r.squared, length(bold_angle)  )
  }
  dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, participant ,'raw_bold_negative_angle' ), height=7.5, width=7.5)
  #dev.off()
  
  
  
  x11(height=7.5, width=7.5)
  par(mfrow=c(4,4))
  xValues <- seq(0,1,length.out=length(xVar))
  storeValues <- array(0,c(length(xVar),1))
  for (k in 1:length(xVar)) {
    surfNum <- k
    B0angleBreaks <- cut( angles[,surfNum], breaks = quantile( angles[,surfNum], seq(0,1,0.1) ), include.lowest=TRUE )
    #B0angleBreaks <- cut( intensityFilt[,surfNum,9], breaks = seq(0,180,30), include.lowest=TRUE )
    bold_angle <- tapply( intensityFilt[,surfNum,5], list( B0angleBreaks ), median  )
    B0_angle <- tapply( angles[,surfNum], list( B0angleBreaks ), median  )
    B0_angle2 <- B0_angle^2 
    cosPred <- cos( (B0_angle)*pi/180 )^2
    linPred <- seq( min(cosPred), max(cosPred), length.out=length(cosPred) )  
    modCos <- lm( bold_angle ~ cosPred ) 
    sModCos <- summary( modCos )
    predMod <- predict( modCos, data.frame( cosPred ) )
    
    #x01 <- cos( seq(40,170,length.out=length(cosPred))*pi/180 )^2
    #predMod01 <- predict( modCos, data.frame( x01 ) )  
    
    plot( bold_angle ~ B0_angle, xlim=c(0,180), bty='n', pch=15, cex=1 )    
    interpData <- spline( B0_angle, predMod, n=50, xout=seq(40,140,10) )
    
    #lines( B0_angle, predMod, lwd=2, col='red' )
    lines( interpData$x, interpData$y, lwd=2, col='red' )
    
    #lines( seq(40,170,length.out=length(cosPred)), predMod01, lwd=2, col='blue' )
    storeValues[k] <- sModCos$r.squared 
    
    boldAngleArray[ nPart, , k, 5 ] <- bold_angle
    boldAngleArray[ nPart, , k, 6 ] <- scale( bold_angle, center=TRUE, scale=TRUE )
    boldAngleArray[ nPart, , k, 7 ] <- rep( sModCos$r.squared, length(bold_angle)  )
  }
  dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, participant ,'raw_bold_angle' ), height=7.5, width=7.5)
  #dev.off()
  
  
  
#   medianB0Angle <- apply( angles, 1, median )
#   rankProfilesBin <- cut( medianB0Angle, breaks=seq(0,180,45), include.lowest=TRUE )
#   rankProfilesBinNumeric <- as.numeric( rankProfilesBin )
#   
#   medianBold <- apply( intensityFilt[,,1], 1, median  )
#   tapply( medianBold, list(rankProfilesBinNumeric), median )
#   colList <- c('red','green','lightblue','orange')
#   
#   x11(width=6.5, height=2.5)
#   par(mfrow=c(1,2))
#   for (k in 1:length(unique(rankProfilesBinNumeric))) {
#     if (k==1) { plot( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 1 ], 2, median ),
#                       xlim=c( min(xVar),max(xVar) ), ylim=c(1,8), bty='n', col=colList[k], type='l', axes=FALSE,
#                       ylab='% BOLD (contralateral)', xlab='cortical depth')
#               axis( 1, seq( min(xVar),max(xVar), length.out=3 ),  seq(0,1,0.5) )
#               axis( 2,seq( 1, 8, length.out=3 ) ) }
#     if (k>1)  { lines( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 1 ], 2, median ), col=colList[k] ) }
#     depthArrayAngle[nPart,,1,k] <- apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 1 ], 2, median )
#   }
#   for (k in 1:length(unique(rankProfilesBinNumeric))) {
#     if (k==1) { plot( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 2 ], 2, median ),
#                       xlim=c(min(xVar),max(xVar)), ylim=c(-2,0.5), bty='n', col=colList[k], type='l', axes=FALSE,
#                       ylab='% BOLD (ipsilateral)', xlab='cortical depth')
#                 axis( 1, seq( min(xVar),max(xVar), length.out=3 ),  seq(0,1,0.5) )
#                 axis( 2,seq( -2, 0.5, length.out=3 ) ) }
#     if (k>1)  { lines( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 2 ], 2, median ), col=colList[k] ) }  
#     depthArrayAngle[nPart,,2,k] <- apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 2 ], 2, median )
#   }
#   for (k in 1:length(unique(rankProfilesBinNumeric))) {
#     if (k==1) { plot( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 6 ], 2, median ),
#                       xlim=c(min(xVar),max(xVar)), ylim=c(0,4), bty='n', col=colList[k], type='l', axes=FALSE,
#                       ylab='T stat (ipsilateral)', xlab='cortical depth')
#                 axis( 1, seq( min(xVar),max(xVar), length.out=3 ),  seq(0,1,0.5) )
#                 axis( 2,seq( 0, 4, length.out=3 ) ) }
#     if (k>1)  { lines( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 6 ], 2, median ), col=colList[k] ) }  
#     depthArrayAngle[nPart,,3,k] <- apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 6 ], 2, median )
#   }
#   dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, participant ,'bold_corticalThickness_angle' ), height=2.5, width=4.5)
#   dev.off()
#   
#   
#   rankProfilesBinNumeric <- rep(1,length(rankProfilesBinNumeric))
#   
#   x11(width=4.5, height=2.5)
#   par(mfrow=c(1,2))
#   for (k in 1:length(unique(rankProfilesBinNumeric))) {
#     if (k==1) { plot( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 1 ], 2, median ),
#                       xlim=c( min(xVar),max(xVar) ), ylim=c(1,8), bty='n', col=colList[k], type='l', axes=FALSE,
#                       ylab='% BOLD (contralateral)', xlab='cortical depth')
#                 axis( 1, seq( min(xVar),max(xVar), length.out=3 ),  seq(0,1,0.5) )
#                 axis( 2,seq( 1, 8, length.out=3 ) ) }
#     if (k>1)  { lines( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 1 ], 2, median ), col=colList[k] ) }  
#   }
#   for (k in 1:length(unique(rankProfilesBinNumeric))) {
#     if (k==1) { plot( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 2 ], 2, median ),
#                       xlim=c(min(xVar),max(xVar)), ylim=c(-2,0.5), bty='n', col=colList[k], type='l', axes=FALSE,
#                       ylab='% BOLD (ipsilateral)', xlab='cortical depth')
#                 axis( 1, seq( min(xVar),max(xVar), length.out=3 ),  seq(0,1,0.5) )
#                 axis( 2,seq( -2, 0.5, length.out=3 ) ) }
#     if (k>1)  { lines( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 2 ], 2, median ), col=colList[k] ) }  
#   }
#   for (k in 1:length(unique(rankProfilesBinNumeric))) {
#     if (k==1) { plot( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 6 ], 2, median ),
#                       xlim=c(min(xVar),max(xVar)), ylim=c(0,4), bty='n', col=colList[k], type='l', axes=FALSE,
#                       ylab='T stat (ipsilateral)', xlab='cortical depth')
#                 axis( 1, seq( min(xVar),max(xVar), length.out=3 ),  seq(0,1,0.5) )
#                 axis( 2,seq( 0, 4, length.out=3 ) ) }
#     if (k>1)  { lines( xVar, apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 6 ], 2, median ), col=colList[k] ) }  
#   }
#   depthArray[nPart,,1] <- apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 1 ], 2, median )
#   depthArray[nPart,,2] <- apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 2 ], 2, median )
#   depthArray[nPart,,3] <- apply( intensityFilt[ rankProfilesBinNumeric==k, xVar, 6 ], 2, median )
#   
#   dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, participant ,'bold_corticalThickness' ), height=2.5, width=4.5)
#   dev.off()
  
  
  
      
}



x11( height=2.5, width=7 )
par(mfrow=c(1,3))
mVal <- apply( storeBold[,,,1], c(2,3), mean )
#mVal <- mVal[,c(3,2,1)]
seVal <- apply( storeBold[,,,1], c(2,3), sd ) / sqrt( length(participantArray) )
matplot( xVar, mVal, bty='n', pch=19, axes=FALSE, xlab='cortical depth', ylab='%BOLD (contra-lateral)', type='l', lwd=2, lty=1 )
segments( xVar+0.15, mVal[,1]-seVal[,1], xVar+0.18, mVal[,1]+seVal[,1], col=c('black')  )
segments( xVar, mVal[,2]-seVal[,2], xVar, mVal[,2]+seVal[,2], col=c('red')  )
segments( xVar-0.15, mVal[,3]-seVal[,3], xVar-0.18, mVal[,3]+seVal[,3], col=c('green')  )
axis(1, seq(min(xVar),max(xVar),length.out=3), seq(0,1,0.5) )
axis(2, round( seq(min(mVal),max(mVal),length.out=3), 0 ), 
     round( seq(min(mVal),max(mVal),length.out=3), 0 ), las=1 )

predQuad <- seq(-1,1,length.out=length(xVar))^2
predLin <- seq(-1,1,length.out=length(xVar))
summary( lm( mVal[,1] ~ predQuad + predLin ) )
summary( lm( mVal[,2] ~ predQuad + predLin ) )
summary( lm( mVal[,3] ~ predQuad + predLin ) )


mVal <- apply( storeBold[,,,2], c(2,3), mean ) 
seVal <- apply( storeBold[,,,2], c(2,3), sd ) / sqrt( length(participantArray) )
matplot( xVar, mVal, bty='n', pch=19, axes=FALSE, xlab='cortical depth', ylab='%BOLD (ipsi-lateral)', type='l', lwd=2, lty=1 )
segments( xVar+0.18, mVal[,1]-seVal[,1], xVar+0.18, mVal[,1]+seVal[,1], col=c('black')  )
segments( xVar, mVal[,2]-seVal[,2], xVar, mVal[,2]+seVal[,2], col=c('red')  )
segments( xVar-0.18, mVal[,3]-seVal[,3], xVar-0.18, mVal[,3]+seVal[,3], col=c('green')  )
axis(1, seq(min(xVar),max(xVar),length.out=3), seq(0,1,0.5) )
axis(2, c(0, -0.4, -0.8), c(0, -0.4, -0.8), las=1 )

predQuad <- seq(-1,1,length.out=length(xVar))^2
predLin <- seq(-1,1,length.out=length(xVar))
summary( lm( mVal[,1] ~ predQuad + predLin ) )
summary( lm( mVal[,2] ~ predQuad + predLin ) )
summary( lm( mVal[,3] ~ predQuad + predLin ) )


mVal <- scale( apply( storeBold[,,,3], c(2,3), mean ) ) 
seVal <- scale( apply( storeBold[,,,3], c(2,3), sd ) ) / sqrt( length(participantArray) )
matplot( xVar, mVal, bty='n', pch=19, axes=FALSE, xlab='cortical depth', ylab='raw BOLD', type='l', lwd=2, lty=1 )
segments( xVar+0.15, mVal[,1]-seVal[,1], xVar+0.18, mVal[,1]+seVal[,1], col=c('black')  )
segments( xVar, mVal[,2]-seVal[,2], xVar, mVal[,2]+seVal[,2], col=c('red')  )
segments( xVar-0.15, mVal[,3]-seVal[,3], xVar-0.18, mVal[,3]+seVal[,3], col=c('green')  )
axis(1, seq(min(xVar),max(xVar),length.out=3), seq(0,1,0.5) )
axis(2, c(-2, 0, 1.5), c(-2, 0, 1.5), las=1 )

predQuad <- seq(-1,1,length.out=length(xVar))^2
predLin <- seq(-1,1,length.out=length(xVar))
summary( lm( mVal[,1] ~ predQuad + predLin ) )
summary( lm( mVal[,2] ~ predQuad + predLin ) )
summary( lm( mVal[,3] ~ predQuad + predLin ) )

dev.copy2pdf(file = sprintf('%s/%s_%s.pdf', mainDirSavePlots, 'average' ,'bold_corticalThickness' ), height=2.5, width=7)
dev.off()



x11(height=7.5, width=7.5)
par(mfrow=c(4,4))
xValues <- seq(0,1,length.out=length(xVar))
storeValues <- array(0,c(length(xVar),1))
for (k in 1:length(xVar)) {
  surfNum <- k
  #B0angleBreaks <- cut( intensityFilt[,surfNum,9], breaks = seq(0,180,30), include.lowest=TRUE )
  bold_angle <- apply( boldAngleArray[,,k,1], c(2), mean )
  bold_angle_se <- apply( boldAngleArray[,,k,1], c(2), sd ) / sqrt( length(participantArray) )
  B0_angle <- seq( 0, 180, length.out=length(bold_angle) )
  B0_angle2 <- B0_angle^2 
  cosPred <- cos( (B0_angle)*pi/180 )^2
  linPred <- seq( min(cosPred), max(cosPred), length.out=length(cosPred) )  
  modCos <- lm( bold_angle ~ cosPred ) 
  sModCos <- summary( modCos )
  predMod <- predict( modCos, data.frame( cosPred ) )
  
  #x01 <- cos( seq(40,170,length.out=length(cosPred))*pi/180 )^2
  #predMod01 <- predict( modCos, data.frame( x01 ) )  
  
  plot( bold_angle ~ B0_angle, xlim=c(0,180), bty='n', pch=15, cex=1, ylab='% BOLD', xlab=expression(paste(phi)), axes=FALSE,
        ylim=c( round( min(bold_angle), 1 ), round( max(bold_angle), 1 ) ), cex.lab=1.25 )    
  axis( 1, seq(0,180,length.out=3), cex.axis=1.25 )
  axis( 2, seq( round( min(bold_angle), 1 ), round( max(bold_angle), 1 ), length.out=3), cex.axis=1.25 )
  segments( B0_angle, bold_angle-bold_angle_se/2, B0_angle, bold_angle+bold_angle_se/2 )
  
  interpData <- spline( B0_angle, predMod, n=50, xout=seq(20,160,10) )
  
  #lines( B0_angle, predMod, lwd=2, col='red' )
  lines( interpData$x, interpData$y, lwd=2, col='red' )
    
}
dev.copy2pdf(file = sprintf('%s/%s.pdf', mainDirSavePlots, 'average_B0Angle_percent_BOLD' ), height=6, width=9)
dev.off()






x11(height=7.5, width=7.5)
par(mfrow=c(4,4))
xValues <- seq(0,1,length.out=length(xVar))
storeValues <- array(0,c(length(xVar),1))
for (k in 1:length(xVar)) {
  surfNum <- k
  #B0angleBreaks <- cut( intensityFilt[,surfNum,9], breaks = seq(0,180,30), include.lowest=TRUE )
  bold_angle <- apply( boldAngleArray[,,k,5], c(2), mean )
  
  B0_angle <- seq( 0, 180, length.out=length(bold_angle) )
  B0_angle2 <- B0_angle^2 
  cosPred <- cos( (B0_angle)*pi/180 )^2
  linPred <- seq( min(cosPred), max(cosPred), length.out=length(cosPred) )  
  modCos <- lm( bold_angle ~ cosPred ) 
  sModCos <- summary( modCos )
  predMod <- predict( modCos, data.frame( cosPred ) )
  
  #x01 <- cos( seq(40,170,length.out=length(cosPred))*pi/180 )^2
  #predMod01 <- predict( modCos, data.frame( x01 ) )  
  
  plot( bold_angle ~ B0_angle, xlim=c(0,180), bty='n', pch=15, cex=1, ylab='raw BOLD', xlab=expression(paste(phi)), axes=FALSE,
  ylim=c( floor( min(bold_angle) ), floor( max(bold_angle) ) ), cex.lab=1.25 )    
  axis( 1, seq(0,180,length.out=3), cex.axis=1.25  )
  axis( 2, seq( floor( min(bold_angle)  ), floor( max(bold_angle) ), length.out=2), cex.axis=1.25  )
  
  interpData <- spline( B0_angle, predMod, n=50, xout=seq(20,160,10) )
  
  #lines( B0_angle, predMod, lwd=2, col='red' )
  lines( interpData$x, interpData$y, lwd=2, col='red' )
  
}
dev.copy2pdf(file = sprintf('%s/%s.pdf', mainDirSavePlots, 'average_B0Angle_raw_BOLD' ), height=7.5, width=7.5)
dev.off()

x11(height=7.5, width=7.5)
par(mfrow=c(4,4))
xValues <- seq(0,1,length.out=length(xVar))
storeValues <- array(0,c(length(xVar),1))
for (k in 1:length(xVar)) {
  surfNum <- k
  #B0angleBreaks <- cut( intensityFilt[,surfNum,9], breaks = seq(0,180,30), include.lowest=TRUE )
  bold_angle <- apply( boldAngleArray[,,k,5], c(2), mean )
  bold_angle_se <- apply( boldAngleArray[,,k,5], c(2), sd ) / sqrt( length(participantArray) )
  B0_angle <- seq( 0, 180, length.out=length(bold_angle) )
  B0_angle2 <- B0_angle^2 
  cosPred <- cos( (B0_angle)*pi/180 )^2
  linPred <- seq( min(cosPred), max(cosPred), length.out=length(cosPred) )  
  modCos <- lm( bold_angle ~ cosPred ) 
  sModCos <- summary( modCos )
  predMod <- predict( modCos, data.frame( cosPred ) )
  
  #x01 <- cos( seq(40,170,length.out=length(cosPred))*pi/180 )^2
  #predMod01 <- predict( modCos, data.frame( x01 ) )  
  
  plot( bold_angle ~ B0_angle, xlim=c(0,180), bty='n', pch=15, cex=1, ylab='normalized BOLD', xlab=expression(paste(phi)), axes=FALSE,
        ylim=c( round( min(bold_angle), 1 ), round( max(bold_angle), 1 ) ), cex.lab=1.25  )    
  axis( 1, seq(0,180,length.out=3), cex.axis=1.25  )
  axis( 2, seq( round( min(bold_angle), 1 ), round( max(bold_angle), 1 ), length.out=3), cex.axis=1.25  )
  segments( B0_angle, bold_angle-bold_angle_se/2, B0_angle, bold_angle+bold_angle_se/2 )
  interpData <- spline( B0_angle, predMod, n=50, xout=seq(20,160,10) )
  
  #lines( B0_angle, predMod, lwd=2, col='red' )
  lines( interpData$x, interpData$y, lwd=2, col='red' )
  
}
dev.copy2pdf(file = sprintf('%s/%s.pdf', mainDirSavePlots, 'average_B0Angle_raw_BOLD_zscore' ), height=7.5, width=7.5)
dev.off()






x11(height=3.5, width=6)
par(mfrow=c(1,2))
xValues <- seq(0,1,length.out=length(xVar))
y <- apply( depthArray[,,1], 2, mean )
y_se <- apply( depthArray[,,1], 2, sd ) / sqrt( length(participantArray)  )
plot( y~xValues, axes=FALSE, ylab='% BOLD (contra-lateral)', xlab='cortical depth', las=1,
      ylim=c( min(y-y_se)-0.1*min(y-y_se), max(y+y_se)+0.1*max(y+y_se) ), cex.lab=1.25, pch=15  )
segments( xValues, y-y_se, xValues, y+y_se )
axis( 1, seq(0,1,0.5), cex.axis=1.25 )
axis( 2, seq( round( min(y), 1 ), round( max(y), 0 ), length.out=3 ), cex.axis=1.25 )

y <- apply( depthArray[,,2], 2, mean )
y_se <- ( apply( depthArray[,,2], 2, sd ) / sqrt( length(participantArray)  ) ) 
plot( y~xValues, axes=FALSE, ylab='% BOLD (ipsi-lateral)', xlab='cortical depth', las=1,
      ylim=c( -1, 0 ), cex.lab=1.25, pch=15 )
segments( xValues, y-y_se, xValues, y+y_se )
axis( 1, seq(0,1,0.5), cex.axis=1.25 )
axis( 2, seq( -1, 0, length.out=3 ), cex.axis=1.25 )

# y <- apply( depthArray[,,3], 2, mean )
# y_se <- apply( depthArray[,,3], 2, sd ) / sqrt( length(participantArray)  )
# plot( y~xValues, axes=FALSE, ylab='T stat (ipsi-lateral)', xlab='cortical depth', las=1,
#       ylim=c( 0, 1.5 ), cex.lab=1.25, pch=15 )
# segments( xValues, y-y_se, xValues, y+y_se )
# axis( 1, seq(0,1,0.5), cex.axis=1.25 )
# axis( 2, seq( 0, 1.5, length.out=3 ), cex.axis=1.25 )

dev.copy2pdf(file = sprintf('%s/%s.pdf', mainDirSavePlots, 'average_acrossDepth_percent_BOLD' ), height=3.5, width=6)
dev.off()



x11(height=3.5, width=6)
par(mfrow=c(1,2))
xValues <- seq(0,1,length.out=length(xVar))
colArray <- c('orange','blue','lightblue','red')
dataPlot <- t( apply( depthArrayAngle[,,1,], c(3,2), mean ) )
dataPlot_sd <- t( apply( depthArrayAngle[,,1,], c(3,2), sd ) ) / sqrt( length( participantArray ) )
seq(0,180,45)
matplot( xValues, dataPlot, axes=FALSE, ylab='% BOLD (contra-lateral)',
         xlab='cortical depth', las=1, cex.lab=1.25, pch=15, ylim=c(2,7), col=colArray  )
segments( xValues, dataPlot[,1]-dataPlot_sd[,1], xValues, dataPlot[,1]+dataPlot_sd[,1],
          col=colArray[1] )
segments( xValues, dataPlot[,2]-dataPlot_sd[,2], xValues, dataPlot[,2]+dataPlot_sd[,2],
          col=colArray[2] )
segments( xValues, dataPlot[,3]-dataPlot_sd[,3], xValues, dataPlot[,3]+dataPlot_sd[,3],
          col=colArray[3] )
segments( xValues, dataPlot[,4]-dataPlot_sd[,4], xValues, dataPlot[,4]+dataPlot_sd[,4],
          col=colArray[4] )
legend("bottomright", legend = c('(0,45]','(45,90]','(90,135]','(135,180]'), col=colArray, pch=15, bty='n')
axis( 1, seq(0,1,0.5), cex.axis=1.25 )
axis( 2, seq( 2, 7, length.out=3 ), cex.axis=1.25 )

dataPlot <- t( apply( depthArrayAngle[,,2,], c(3,2), mean ) )
dataPlot_sd <- t( apply( depthArrayAngle[,,2,], c(3,2), sd ) ) / sqrt( length( participantArray ) )
matplot( xValues, dataPlot, axes=FALSE, ylab='% BOLD (contra-lateral)',
         xlab='cortical depth', las=1, cex.lab=1.25, pch=15, ylim=c(-1.1,0), col=colArray  )
segments( xValues, dataPlot[,1]-dataPlot_sd[,1], xValues, dataPlot[,1]+dataPlot_sd[,1],
          col=colArray[1] )
segments( xValues, dataPlot[,2]-dataPlot_sd[,2], xValues, dataPlot[,2]+dataPlot_sd[,2],
          col=colArray[2] )
segments( xValues, dataPlot[,3]-dataPlot_sd[,3], xValues, dataPlot[,3]+dataPlot_sd[,3],
          col=colArray[3] )
segments( xValues, dataPlot[,4]-dataPlot_sd[,4], xValues, dataPlot[,4]+dataPlot_sd[,4],
          col=colArray[4] )
axis( 1, seq(0,1,0.5), cex.axis=1.25 )
axis( 2, seq( -1.1, 0, length.out=3 ), cex.axis=1.25 )

dev.copy2pdf(file = sprintf('%s/%s.pdf', mainDirSavePlots, 'average_acrossDepth_angle_percent_BOLD' ), height=3.5, width=6)
dev.off()


# dataPlot <- t( apply( depthArrayAngle[,,3,], c(3,2), mean ) )
# dataPlot_sd <- t( apply( depthArrayAngle[,,3,], c(3,2), sd ) ) / sqrt( length( participantArray ) )
# matplot( xValues, dataPlot, axes=FALSE, ylab='% BOLD (contra-lateral)',
#          xlab='cortical depth', las=1, cex.lab=1.25, pch=15, ylim=c(0,2), col=colArray  )
# segments( xValues, dataPlot[,1]-dataPlot_sd[,1], xValues, dataPlot[,1]+dataPlot_sd[,1],
#           col=colArray[1] )
# segments( xValues, dataPlot[,2]-dataPlot_sd[,2], xValues, dataPlot[,2]+dataPlot_sd[,2],
#           col=colArray[2] )
# segments( xValues, dataPlot[,3]-dataPlot_sd[,3], xValues, dataPlot[,3]+dataPlot_sd[,3],
#           col=colArray[3] )
# segments( xValues, dataPlot[,4]-dataPlot_sd[,4], xValues, dataPlot[,4]+dataPlot_sd[,4],
#           col=colArray[4] )
# axis( 1, seq(0,1,0.5), cex.axis=1.25 )
# axis( 2, seq( 0, 2, length.out=3 ), cex.axis=1.25 )
 
 
