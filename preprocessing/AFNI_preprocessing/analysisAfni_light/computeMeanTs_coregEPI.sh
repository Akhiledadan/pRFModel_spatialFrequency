#!/bin/bash

SF=$1
INPUTDIR=$2
OUTPUTDIR=$3


if [ -z "$1" ]
then
echo 'computes amplitude anatomy (mean ts)'
echo 'reads .volreg files processed by motionCorrect.afni.sh'
echo 'Inputs:'
echo 'INPUTDIR=$1, input directory'
echo 'OUTPUTDIR=$2, output directory'
exit 1
fi

cd $INPUTDIR

echo 'computes mean timeseries for spatial frequency' $SF

mean_files=( *SF$SF*.nii )

outputFileName=$(printf '3dMean -prefix meanTs+orig %s' ${mean_files[0]} )

for ((i=1; i<=${#mean_files[@]}; i++)); do
     
    outputFileName=$(printf '%s %s ' ${outputFileName} ${mean_files[i]} )
   
done

echo ${outputFileName}

${outputFileName}

3dAFNItoNIFTI meanTs+orig

rm meanTs+orig.BRIK
rm meanTs+orig.HEAD

mv meanTs.nii ../$OUTPUTDIR

cd ..




