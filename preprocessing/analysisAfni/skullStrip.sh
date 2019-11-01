#!/bin/bash

#MPRAGE=$1
#PD=$2
#res=$3

MPRAGE='anatomy.nii'
PD='pd.nii'
res='0.8'

3dresample -dxyz $res $res $res -inset ${MPRAGE} -prefix MPRAGE+orig

3dresample -dxyz $res $res $res -inset ${PD} -prefix PD+orig
	
#3dcopy ${MPRAGE} MPRAGE+orig
#3dcopy ${PD} PD+orig

3dUniformize -anat PD+orig -prefix PD_uniform+orig

align_epi_anat.py -dset1 PD_uniform+orig \
		  -dset2 MPRAGE+orig \
		  -dset1to2 \
		  -dset1_strip None \
		  -dset2_strip None \
		  -anat_has_skull yes \
		  -cost lpc \
		  -Allineate_opts \
		  -final linear \
		  -warp shift_rotate \
		  -suffix _al \
		  -child_dset1 PD+orig

#3dresample -master MPRAGE+orig -prefix PD_uniform_al_upsampled -inset PD_uniform_al+orig

#3dresample -master MPRAGE+orig -prefix PD_al_upsampled -inset PD_al+orig

3dSkullStrip -prefix PD_uniform_al_upsampled_SS+orig -input PD_uniform_al_upsampled+orig

3dcalc -a MPRAGE+orig -b PD_uniform_al_upsampled_SS+orig -expr 'a*ispositive(b)' -prefix MPRAGE_SS+orig

#3dresample -dxyz $res $res $res -inset MPRAGE_SS+orig -prefix MPRAGE_SS_iso+orig

#3dresample -dxyz $res $res $res -inset PD_al_upsampled+orig -prefix PD_al_iso+orig

3dAFNItoNIFTI MPRAGE_SS_iso+orig

3dAFNItoNIFTI PD_al_iso+orig

rm *.BRIK

rm *.HEAD

rm *.1D

