#!/bin/bash

INPUTDIR=$1
newTR=$2

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
    echo ${bold_files[i]}
    3drefit -TR $2 ${bold_files[i]}
done	


