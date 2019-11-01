#!/bin/bash

cd originalNifti

nifti_files=( *.nii )

for ((i=1; i<${#nifti_files[@]}; i++)); do

   outputFileName[i]=$(printf '%s%s' ${nifti_files[i]%%.???} '_al+orig.HEAD')
   echo ${nifti_files[0]}
   echo ${nifti_files[i]}   
   echo ${outputFileName[i]}

   align_epi_anat.py -dset2 ${nifti_files[0]} \
		-dset1 ${nifti_files[i]} \
		-dset1_strip None \
		-dset2_strip None \
		-anat_has_skull yes \
		-Allineate_opts -final NN -warp shift_rotate

   3dAFNItoNIFTI ${outputFileName[i]}
   
done

cd ..
