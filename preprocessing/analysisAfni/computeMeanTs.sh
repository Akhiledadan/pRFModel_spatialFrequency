#!/bin/bash

INPUTDIR=$1
OUTPUTDIR=$2

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

#mean_files=( pb02.**.volreg+orig**.BRIK )
#mean_files=( uw_Dino**.nii )
mean_files=( pRF**_S.nii )
#mean_files=( 2_pRF_**_ChangeBlindness2_WIP_2DEPI1.8iso1500TR_SENSE_**_1-d0248_deob.nii )
#mean_files=( test3_**.nii )


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




