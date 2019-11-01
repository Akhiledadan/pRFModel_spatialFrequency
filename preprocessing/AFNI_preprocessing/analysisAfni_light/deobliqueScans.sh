#!/bin/bash

INPUTDIR=$1

if [ -z "$1" ]
then
echo 'computes despike and motion corrected epi data'
echo 'Inputs:'
echo 'EPIDIR=$1, input directory, where the EPI lives'
echo 'TOPDIR=$2, new TR which should be set'
exit 1
fi

cd $INPUTDIR

bold_files=(**.nii)


for ((i=0; i<${#bold_files[@]}; i++));
do 
	IN=${bold_files[i]}
    bold_files_name=(${IN//./ })

    echo $bold_files_name
    3dWarp -deoblique -prefix ${bold_files_name}'_deob.nii' ${bold_files[i]} 
done	


