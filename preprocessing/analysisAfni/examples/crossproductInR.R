setwd('/media/alessiofracasso/Seagate Expansion Drive/backup27082015/prfSizeDepth_2/V3814Serge/anatomy_CBS')
# 
# 
args <- c( 'leftV1.1D.roi', 'boundary00', 'boundary01', 'MPRAGE_al_epi.nii.gz' )
# 

source('/usr/lib/afni/bin/AFNIio.R')
source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/linearIndexFromCoordinate.r')
source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/coordinateFromLinearIndex.r')

wmBorderMask <- read.AFNI('surfVolWMRoi+orig')
gmLevelMask <- read.AFNI('DEPTH_al_epi.nii.gz')

maskData <- wmBorderMask$brk[,,,1]
gmData <- gmLevelMask$brk[,,,1]

emptyVol <- maskData
stepLimit <- 0.1
limit1 <- seq(0.1,1-stepLimit,by=stepLimit)
limit2 <- limit1 + stepLimit

for (lim in 1:length(limit1) ) {
  ind1 <- which( emptyVol==1 )
  ind2 <- which( gmData>limit1[lim] & gmData<=limit2[lim] )
  coordsWM <- matrix( t( coordinateFromLinearIndex( ind1, dim(emptyVol) ) ), ncol=3 )
  coordsGM <- matrix( t( coordinateFromLinearIndex( ind2, dim(emptyVol) ) ), ncol=3 )
  nSteps <- 30
  nXStep <- round( dim( coordsWM )[1] / nSteps )
  startArray <- seq( 1, dim( coordsWM )[1]-nXStep, by=nXStep )
  endArray <- startArray+nXStep
  endArray[ length(endArray) ] <- dim( coordsWM )[1]
  indexStore <- rep(0,nXStep)
  for (k in 1:length(startArray) ) {
    x1 <- coordsWM[ startArray[k]:endArray[k],  ]
    a <- dist2( x1, coordsGM )
    minVector <- apply(a, 1, min)
    for ( n in 1:dim(a)[1] ) {
      indexStore[n] <- which( minVector[n] == a[n,] )
    }  
    coords <- coordsGM[indexStore, ]
    for (l in 1:dim(coords)[1]) {
      emptyVol[ coords[l,1], coords[l,2], coords[l,3] ] <- 1
    }
  }
}

#wmBorderMask$brk[,,,1] <- emptyVol
#app <- array(0,c(192,192,35,4))
#app[,,,1] <- emptyVol
write.AFNI('roi8+orig',
           brk=emptyVol,
           label=NULL,
           view='+orig',
           orient=wmBorderMask$orient,
           origin=wmBorderMask$origin,
           delta=wmBorderMask$delta,
           defhead=wmBorderMask$NI_head )

3dclust -prefix roi9+orig 0 50 roi8+orig









write.AFNI("test_mask+orig",
           brk=testdata,
           label=NULL,
           note="Masked",
           orient=thedata$orient,
           view='+orig'
           , defhead=thedata$header)

image( emptyVol[,,15] )



thedata <- read.AFNI('vol+orig')
names(thedata)

image( gmLevelMask$brk[,,20,1]  )















library(AnalyzeFMRI)
fname <- 'amplitudeAnatomy.nii.gz'#args[4]
system( sprintf('gunzip %s', fname ) )
vol <- f.read.nifti.volume( 'amplitudeAnatomy.nii' )
head <- f.read.nifti.header( 'amplitudeAnatomy.nii' )
system('gzip amplitudeAnatomy.nii')



library(fmri)
vol <- read.AFNI( 'vol+orig', vol=c(1) )
names(vol)
volArray <- as.numeric( vol$ttt )
vol3d <- array( volArray, c(192,192,35,4) )
im <- vol3d[,,10,1]
image( vol3d[,,8,4] )







library(oro.nifti)
d <- readNIfTI(args[4])
x11()
image( d@.Data[,150,] )

vertex <- read.table( sprintf('%s_sm.1D.coord', args[2] ) )
face <- read.table( sprintf('%s_or.1D.topo', args[2] ) )
face <- face + 1

source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/compute_normal.r')
source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/linearIndexFromCoordinate.r')
source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/coordinateFromLinearIndex.r')
source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/normal_displacement.r')
library(fmri)


connectionRoi <- read.table( 'delme.dat' )
wmBoundary <- read.table( sprintf('%s_sm.1D.coord', args[2] ) )
csfBoundary <- read.table( sprintf('%s_sm.1D.coord', args[3] ) )

wmBoundaryRoi <- wmBoundary[ connectionRoi[,1], ]
csfBoundaryRoi <- csfBoundary[ connectionRoi[,2], ]

#csfBoundaryRoi <- surfToSurfData[ filt, 9:11 ]

vol <- read.AFNI(  'MPRAGE_afni+orig' )
tMat <- vol$header$IJK_TO_DICOM
tMat <- matrix( tMat, nrow=3, ncol=4, byrow=TRUE )
tMat <- rbind( tMat, c(0,0,0,1) )

lOut <- 15
out1 <- array(0, c( dim(wmBoundaryRoi)[1], lOut  ) )
out2 <- array(0, c( dim(wmBoundaryRoi)[1], lOut  ) )
out3 <- array(0, c( dim(wmBoundaryRoi)[1], lOut  ) )
emptyVol <- array( 0, vol$header$DATASET_DIMENSIONS[1:3]  )
for (k in 1:dim(wmBoundaryRoi)[1] ) {
  out1 <- seq( wmBoundaryRoi[k,1], csfBoundaryRoi[k,1], length.out=lOut )
  out2 <- seq( wmBoundaryRoi[k,2], csfBoundaryRoi[k,2], length.out=lOut )
  out3 <- seq( wmBoundaryRoi[k,3], csfBoundaryRoi[k,3], length.out=lOut )
  coords <- cbind( out1, out2, out3, rep( 1, length(out1) ) )
  coords1 <- solve( tMat )  %*% t( coords ) 
  for (n in 1:dim(coords1)[2]) {
    emptyVol[ round( coords1[1,n] ), round( coords1[2,n] ), round( coords1[3,n] ) ] <- 1
  }
  #indexVol <- round( linearIndexFromCoordinate( coords1[1:3,], vol$header$DATASET_DIMENSIONS[1:3] ) )
  #emptyVol[ indexVol ] <- 1
}

write.AFNI( 'delme1_afni+orig', emptyVol, h=vol$header )

## or compute_normals x 3, invert, select voxels in gray till 0, eliminate the rest;


coords1 <- solve( tMat )  %*% rbind( t( wmBoundaryRoi ), rep(1, dim(wmBoundaryRoi)[1] ) ) 
indexVol <- round( linearIndexFromCoordinate( coords1[1:3,] , vol$header$DATASET_DIMENSIONS[1:3] ) )
emptyVol <- array( 0, vol$header$DATASET_DIMENSIONS[1:3]  )
for (k in 1:dim(coords1)[2]) {
  emptyVol[ round( coords1[1,k] ), round( coords1[2,k] ), round( coords1[3,k] ) ] <- 1
}
#emptyVol[ indexVol ] <- 1
write.AFNI( 'delme1_afni+orig', emptyVol, h=vol$header )




source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/compute_normal.r')
source('/home/alessiofracasso/Dropbox/analysisAfni/surfaces/normal_displacement.r')
library(fmri)

roi <- scan('delRoi.niml.roi', comment.char='#')
connectionRoi <- read.table( 'delme.dat' )
#seg <- read.AFNI( 'SEG_afni+orig' )

emptyVol <- array( 0, seg$header$DATASET_DIMENSIONS[1:3]  )
tMat <- seg$header$IJK_TO_DICOM
tMat <- matrix( tMat, nrow=3, ncol=4, byrow=TRUE )
tMat <- rbind( tMat, c(0,0,0,1) )
vertices <- read.table( sprintf('%s_sm.1D.coord', args[2] ) )
faces <- read.table( sprintf('%s_or.1D.topo', args[2] ) )
faces <- faces + 1
normals <- compute_normal(vertices,faces)
stepArray <- seq( 0,3,length.out=6)
storeGray <- array( 0, c( length(connectionRoi[,1]), length(stepArray) ) )
for (k in 1:length(stepArray) ) {
  #vert <- normal_displacement( vertices, faces,  stepArray[k] )  
  vert <- vertices+normals*stepArray[k]
  #selVert <- vert[ connectionRoi[,1], ]
  selVert <- vert[ roi, ]
  coords <- solve( tMat )  %*% rbind( t( selVert ), rep(1, dim(selVert)[1] ) )
  
  for (n in 1:dim(coords)[2]) {
    emptyVol[ round( coords[1,n] ), round( coords[2,n] ), round( coords[3,n] ) ] <- 1
  }
  
}
write.AFNI( 'delme5_afni+orig', emptyVol, h=seg$header )

image( emptyVol[,,18] )

#try to work with depth measure and use nearpoints within R
# octave....

vert1 <- vertices+normals/2;
vert2 <- vertices+normals;
vert3 <- vertices+normals*3/2;
vert4 <- vertices+normals*2;











image( emptyVol[,,12] )

indexVol <- round( linearIndexFromCoordinate( round( coords1[1:3,] ), vol$header$DATASET_DIMENSIONS[1:3] ) )
coorsOut <- coordinateFromLinearIndex( indexVol, vol$header$DATASET_DIMENSIONS[1:3] )


coords <- cbind( out1[,1], out2[,1], out3[,1], rep(1,dim(out1)[1]) )
coords1 <- solve( tMat )  %*% t( coords ) 



linearIndexFromCoordinate <- function( coords, dims ) {
  indices <- coords[1,]
  for ( d in 2:length(dims) ) {
    indices <- indices + (coords[d,]-1) * prod(dims[1:d-1]);
  }
  return(indices)
}


coordinateFromLinearIndex <- function(indices, dims) {  
  coords <- array( 0, c( length(dims), length(indices) ) )
  dArray <- seq( length(dims), 1)
  for ( n in 1:length(dims) ) {
    d <- dArray[n]
    coords[d,] <- floor( (indices-1) / prod( dims[1:d-1] ) ) + 1;
    indices <- indices - (coords[d,]-1) * prod( dims[1:d-1] );
  }
  return( coords )
}




dims <- c(192,192,35)
indices <- round( indexVol )
coords <- array( 0, c( 3, length(indexVol) ) )
d <- 1
coords[d,] <- floor( (indices-1) / prod( dims[1:d-1] ) ) + 1;
indices <- indices - ( coords[d,]-1)*prod( dims[1:d-1] );















library(oro.nifti)

d <- readNIfTI( args[4] )
tMat <- rbind( -1*d@srow_x, -1*d@srow_y, d@srow_z, c(0,0,0,1) )
coords <- cbind( out1[,1], out2[,1], out3[,1], rep(1,dim(out1)[1]) )
coords1 <- solve( tMat )  %*% t( coords ) 
coords1[,1:5]

library(AnalyzeFMRI)
fname <- 'amplitudeAnatomy.nii.gz'#args[4]
system( sprintf('gunzip %s', fname ) )
d <- f.read.nifti.volume( 'amplitudeAnatomy.nii' )
h <- f.read.nifti.header( 'amplitudeAnatomy.nii' )
system('gzip amplitudeAnatomy.nii')
coords <- cbind( out3[,1], out2[,1], out1[,1] )
xyz2ijk( t( wmBoundaryRoi[5,] ), method=2, h )

fname <- 'amplitudeAnatomy.nii.gz'#args[4]
system( sprintf('gunzip %s', fname ) )





#cbind( nodesInstr1Filt, surfToSurfDataFilt )
cbind( wmBoundary[ surfToSurfDataFilt1[,1], ] , gmBoundary[ surfToSurfDataFilt2, ] )
wmCoordsRoi <- wmBoundary[ surfToSurfDataFilt1[,1], ]
csfCoordsRoi <- gmBoundary[ surfToSurfDataFilt2, ]

wmCoordsRoi[1,1]
csfCoordsRoi[1,1]

wms <- wmCoordsRoi[1:10,1]
csf <- csfCoordsRoi[1:10,1]

vecSeq <- function(minVal, maxVal, nEl) { seq(minVal, maxVal, length.out=nEl)  }
vecSeq(0,5,10)

sapply( wms, seq( wms, csf, length.out=5 ) )



gmBoundary <- read.table( sprintf('%s_sm.1D.coord', args[3] ) )


crossp <- function(x,y) {
  z <- x
  z[1,:] = x[2,:].*y[3,:] - x[3,:].*y[2,:]
  z[2,:] = x[3,:].*y[1,:] - x[1,:].*y[3,:]
  z[3,:] = x[1,:].*y[2,:] - x[2,:].*y[1,:] 
}


vertex <- as.matrix( read.table( sprintf('%s_sm.1D.coord', args[2] ), as.is=TRUE ) )
face <- as.matrix( read.table( sprintf('%s_or.1D.topo', args[2] ), as.is=TRUE ) )
face <- face + 1
nface <- dim(face)[1]
nvert <- dim(vertex)[1]
normal <- array( 0, c( nvert, 3 ) )
x <- vertex[ face[ ,2], ]-vertex[ face[ ,1], ]
y <- vertex[ face[ ,3], ]-vertex[ face[ ,1], ]
normalf <- crossprod( t( x ), t( y ) );
d <- sqrt( sum(normalf^2,1) ); 
d(d<eps)=1;
normalf = normalf ./ repmat( d, 3,1 );


% unit normals to the faces
normalf = crossp( vertex(:,face(2,:))-vertex(:,face(1,:)), ...
                  vertex(:,face(3,:))-vertex(:,face(1,:)) );
d = sqrt( sum(normalf.^2,1) ); d(d<eps)=1;
normalf = normalf ./ repmat( d, 3,1 );

% unit normal to the vertex
normal = zeros(3,nvert);
for i=1:nface
f = face(:,i);
for j=1:3
normal(:,f(j)) = normal(:,f(j)) + normalf(:,i);
end
end
% normalize
d = sqrt( sum(normal.^2,1) ); d(d<eps)=1;
normal = normal ./ repmat( d, 3,1 );

% enforce that the normal are outward
v = vertex - repmat(mean(vertex,1), 3,1);
s = sum( v.*normal, 2 );
if sum(s>0)<sum(s<0)
% flip
normal = -normal;
normalf = -normalf;
end



setwd('/home/alessiofracasso/Dropbox/analysisAfni/examples')
library(Rcpp)
Sys.setenv("PKG_CXXFLAGS"="-fopenmp")
Sys.setenv("PKG_LIBS"="-fopenmp")
sourceCpp("parad.cpp")
sourceCpp("nearpoints.cpp")

a=rnorm(1000,0,1)
b=rnorm(1000,0,1)
c=parad(a,b)






