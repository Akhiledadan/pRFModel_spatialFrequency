############################################################################################## Resample segmentation to .7mm
#############################################################################################

# test 

#resample anatomy to 0.7 mm
3dresample -dxyz 0.7 0.7 0.7 -rmode Li -prefix anatomy_N3_07mm.nii.gz -input MPRAGE_N3.nii.gz


#cd in the subject folder and make a folder called seg_resampling. This folder should contain Anatomy at 0.7 mm and segmentation at 0.6 mm 

 mkdir seg_resampling

#make a label file only for left hemisphere
3dcalc -a t1_class_1.nii.gz -expr "within(a,4,4)*1 + within(a,3,3)*3  + within(a,0,0)*1 + within(a,1,1)*0" -prefix seg_filled_0_6mm_rlbl_gw_lt.nii.gz

#make a label file only for right hemisphere
3dcalc -a t1_class_1.nii.gz -expr "within(a,4,4)*4 + within(a,3,3)*1  + within(a,0,0)*1 + within(a,1,1)*0" -prefix seg_filled_0_6mm_rlbl_gw_rt.nii.gz 

#resample the segmentations to 0.7 mm given by the master dataset (anatomy)
#left
3dresample -master anatomy_N3_07mm.nii.gz -rmode Li -prefix seg_filled_0_7mm_rlbl_gw_lt_li.nii.gz -input seg_filled_0_6mm_rlbl_gw_lt.nii.gz 
#right
3dresample -master anatomy_N3_07mm.nii.gz -rmode Li -prefix seg_filled_0_7mm_rlbl_gw_rt_li.nii.gz -input seg_filled_0_6mm_rlbl_gw_rt.nii.gz

#relabel the segmentations by setting the threshold values
#left
3dcalc -a seg_filled_0_7mm_rlbl_gw_lt_li.nii.gz -expr "within(a,0,0.5)*0 + within(a,0.5,1.25)*1 + within(a,1.25,3)*3" -prefix seg_filled_0_7mm_rlbl_gw_lt_li_rlbl.nii.gz
#right
3dcalc -a seg_filled_0_7mm_rlbl_gw_rt_li.nii.gz -expr "within(a,0,0.5)*0 + within(a,0.5,1.25)*1 + within(a,1.25,4)*4" -prefix seg_filled_0_7mm_rlbl_gw_rt_li_rlbl.nii.gz

#Combine left and right segmentations 
3dcalc -a seg_filled_0_7mm_rlbl_gw_lt_li_rlbl.nii.gz -b seg_filled_0_7mm_rlbl_gw_rt_li_rlbl.nii.gz -expr "and(within(a,0,0),within(b,0,0))*0 + and(within(a,1,1),within(b,1,1))*1 + and(within(a,3,3),within(b,1,1))*3 + and(within(a,1,1),within(b,4,4))*4" -prefix seg_filled_0_7mm.nii.gz

#Set the white matter and gray matter labels to be mrVista compatible
3dcalc -a seg_filled_0_7mm.nii.gz -expr "within(a,0,0)*1 + within(a,1,1)*0 + within(a,4,4)*4 + within(a,3,3)*3" -prefix seg_filled_07mm_lr.nii.gz 

######################################################################################################
#CONVERT RAW DATA TO NIFTI, REFIT TR & DEOBLIQUE#

# folder with raw data; raw  (contains .PAR and .REC)

# Using r2agui to convert par recs to nifti can cause it to read the TRs differently. TRs can be reset and then each  (settings; batch on + use same output folder + 4d) (ptoa flipped functional data LR -> use r2agui and use refit to change the TR to 1.5)

# scan can be deobliqued by using the following two scripts

# create a folder called PARRECS and copy all the nifti files obtained as an output from r2agui to this folder.
# run the following lines of code from folder just outside this PARRECS/ folder 

# refit the functionals with a new TR (of 1.5)

refitTR.sh PARRECS/ 1.5

# check TRs using 3dinfo

# deoblique the refitted functionals
deobliqueScans.sh PARRECS/
# check if data axes tilt = plumb using 3dinfo

# create folders EPI (bold.deob.nii) and TOPUP (topup.deob.nii)

# Copy the functionals to a folder called EPI and continue with the analysis

# Rename functionals to 01_dlsub..._date_SF.._scannr_ (check; data1/projects/dumoulinlab/Lab_members/Akhil/SF/data/functionals/dlsub123/Obsolete_0608/session1/obsolete/EPI/)



#####################################################################################################

# TOP UP + MOTION CORRECTION

run . startAfniToolbox

module load afni
module load matlab
module load matlab/toolbox/vistasoft/20170523
module load R

# These steps are not required now siince you're not opening matlab anymore######################################################
Matlab -nodesktop -nosplash 													#
																#					
addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/pRF-comparison-Spatial-frequency/AFNI_preprocessing/'))  #
                														#			
#set main directory;														#
mainDir = '/data1/projects/dumoulinlab/Lab_members/Akhil/SF/data/functionals/dlsub127/Session_1/'				#
cd(mainDir)															#
																#
### dont need to run in matlab (?) previous steps not needed; run directly from folder with functionals. 			#
#################################################################################################################################

# 8th input how much to blur the data for Qwarp.
# QWarp (higher is more strict)
# keep the 1's. the 1-2-3-4-5-6-7 are the runs you want to use for the correction
# from the EPIs (first numbers) and TOPUP (2nd set).

motionCorrect.afni.blip.sh EPI/ TOPUP/ 1 1 1-2-3-4-5-6-7-8-9-10 1-2-3-4-5-6-7-8-9-10 5 -1

# Creates new folder; topUpDir

# Motion correct and motion correct + top up the original EPI data
# Last input is the EPI number used for the previous step. 

motionCorrectEPI.with.topUp.sh EPI/ topUpDir/ 1

# Creates folders; motionCorrectEpi and motionCorrect_topUp_Epi
# Does the motion correction, with Fourier interpolation
# Then apply top up transform from previous step
# Last input is which volume to allign everything to. 


#####################################################################################################

# Compute amplitude anatomy (average over all timepoints over all runs, used as an inplane anatomy)
computeAmplitudeAnatomy.sh motionCorrect_topUp_Epi/
# This can be used as the inplane anatomy file (creates amplitudeAnatomy.nii -> change into inplane.nii.gz to use in mrVista)


# Mask the amplitudeAnatomy to reduce the volume size.
3dAutomask -apply_prefix amplitudeAnatomy_deob_mask.nii.gz amplitudeAnatomy.nii

# Zeropad the amplitudeAnatomy to allow for shifting it around in the next steps.
3dZeropad -A 20 -P 20 -S 20 -I 20 -prefix amplitudeAnatomy_deob_mask_zp.nii.gz amplitudeAnatomy_deob_mask.nii.gz


# Now align the centers of mass of the amplitudeAnatomy and anatomy, so they are in the same space
# USE MIPAV N3_anatomy at .7! 

@Align_Centers -base MP2RAGE_ss_N3.nii.gz -dset amplitudeAnatomy_deob_mask_zp.nii.gz -cm

dlsub133:@Align_Centers -base sub-01_desc-preproc_T1w.nii.gz -dset amplitudeAnatomy_deob_mask_zp.nii.gz -cm 

# Rotate the shifted amplitude anatomy using nudge dataset and apply the resulting transformation
# Open afni - underlay; anatomy overlay; AmplitudeAnatomy_deob_mask_zp_shft.nii
# Define datamode - plugins - Nudge dataset
# Print transformation matrix 
# dlsub127_session1; 3drotate -quintic -clipit -rotate 0.00I -4.00R 0.00A -ashift 9.98S 0.00L 0.90P -prefix ???  inputdataset
# dlsub127_session2; 3drotate -quintic -clipit -rotate 2.00I 4.07R 1.86A -ashift 13.21S 2.50L -0.25P -prefix ???  inputdataset
# dlsub120_session1; 3drotate -quintic -clipit -rotate -5.03I 5.98R 0.52A -ashift 12.70S 2.97L 11.73P -prefix ???  inputdataset
# dlsub120_session2; 3drotate -quintic -clipit -rotate -3.00I -2.00R 0.07A -ashift 11.99S 1.53L 0.94P -prefix ???  inputdataset
# dlsub099_session1; 3drotate -quintic -clipit -rotate 0.00I -3.00R 0.00A -ashift 12.50S 0.00L -0.65P -prefix ???  inputdataset</pre>
# dlsub099_session2; <pre>3drotate -quintic -clipit -rotate 0.00I -3.00R 0.00A -ashift 12.91S 0.00L 3.32P -prefix ???  inputdataset</pre>
#dlsub123_ses1 3drotate -quintic -clipit -rotate -7.03I -7.91R 3.15A -ashift 4.80S 2.11L 1.67P -prefix ???  inputdataset 
#dlsub123_ses2 3drotate -quintic -clipit -rotate -7.93I 0.08R -0.95A -ashift 9.55S 0.07L -1.60P -prefix ???  inputdataset
#dlsub120_ses3 3drotate -quintic -clipit -rotate -4.00I -1.00R 0.00A -ashift 13.16S 0.00L -1.21P -prefix ???  inputdataset
#dlsub003_session1 <pre>3drotate -quintic -clipit -rotate -4.00I 0.00R 0.14A -ashift 12.15S 1.36L 2.61P -prefix ???  inputdataset
#dlsub128 3drotate -quintic -clipit -rotate -8.04I 5.96R 0.63A -ashift 13.95S 2.87L -0.06P -prefix ???  inputdataset
#dlsub131 3drotate -quintic -clipit -rotate 4.06I 9.98R -1.20A -ashift 26.22S -1.97L -5.52P -prefix ???  inputdataset
#dlsub133   3drotate -quintic -clipit -rotate -4.09I 11.97R 0.80A -ashift 19.27S 1.01L -2.69P -prefix ???  inputdataset 
#dlsub134 <pre>3drotate -quintic -clipit -rotate 0.00I 12.00R 0.00A -ashift 13.00S 0.00L -3.07P -prefix ???  inputdataset</pre>



3drotate -quintic -clipit -rotate -6.05I 7.96R 1.26A -ashift 18.49S 1.94L 5.98P -prefix amplitudeAnatomy_deob_mask_zp_shft_rot.nii.gz amplitudeAnatomy_deob_mask_zp_shft.nii.gz

# get the rotation matricx as a 1D file
cat_matvec ''amplitudeAnatomy_deob_mask_zp_shft_rot.nii.gz::ROTATE_MATVEC_000000'' -I -ONELINE > rotateMat.1D


# Now refine the co-registration automatically
align_epi_anat.py -anat MP2RAGE_ss_N3.nii.gz -epi amplitudeAnatomy_deob_mask_zp_shft_rot.nii.gz -epi_base 0 -epi2anat -cost lpc -anat_has_skull no -epi_strip None -Allineate_opts -maxrot 10 -maxshf 10

cat_matvec -ONELINE rotateMat.1D amplitudeAnatomy_deob_mask_zp_shft_rot_al_reg_mat.aff12.1D amplitudeAnatomy_deob_mask_zp_shft.1D > combined.1D

# Apply the combined co-registration to the amplitudeAnatomy in one resampling step. 
# At the same time, this is a check to see whether the combination of the matrices worked. 
# If not, play around with the order in the previous command. 

3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source amplitudeAnatomy.nii -1Dmatrix_apply combined.1D -final wsinc5 -prefix amplitudeAnatomy_deob_Coreg.nii.gz 

#####################################################################################################
#####################################################################################################
#####################################################################################################
# Average tseries - 
# All (sf3,6,12,18) and individual ones separately



# make a folder names Functionals
mkdir Functionals

#dlsub127_session 1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub127_02072019_SF6_1_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub127_02072019_SF6_2_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub127_02072019_SF12_1_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub127_02072019_SF12_2_bold_2_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub127_02072019_SF18_1_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_1.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_2.nii

#dlsub127_session 2
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub127_20190708_SF3_2_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub127_20190708_SF3_3_bold_2_18_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub127_20190708_SF6_3_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub127_20190708_SF12_3_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub127_20190708_SF12_4_bold_2_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub127_20190708_SF18_3_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_3.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub127_20190708_SF18_4_bold_2_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_4.nii
3dTcat motionCorrect_topUp_Epi/pb.08_dlsub127_20190708_SF18_5_bold_3_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_5.nii

#dlsub120_session_1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub120_19062019_SF3_1_bold_9_1-d0225_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub120_19062019_SF6_1_bold_15_1-d0225_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub120_19062019_SF12_1_bold_13_1-d0225_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub120_19062019_SF18_1_bold_11_1-d0225_deob.volreg+orig -prefix Functionals/pRF_SF18_1.nii

#dlsub120_session_2
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub120_20190704_SF3_2_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub120_20190704_SF6_2_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub120_20190704_SF12_2_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub120_20190704_SF12_3_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub120_20190704_SF18_2_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub120_20190704_SF18_3_bold_2_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_3.nii

#dlsub099_session_1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub099_20190815_SF3_1_bold_1_11_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub099_20190815_SF6_1_bold_1_9_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub099_20190815_SF12_1_bold_1_7_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub099_20190815_SF12_2_bold_1_15_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub099_20190815_SF18_1_bold_1_5_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_1.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub099_20190815_SF18_2_bold_1_13_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_2.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub099_20190815_SF18_3_bold_1_17_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_3.nii

#dlsub099_session 2
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub099_20190815_2_SF3_2_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub099_20190815_2_SF3_3_bold_1_11_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub099_20190815_2_SF6_2_bold_1_7_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub099_20190815_2_SF6_3_bold_1_13_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub099_20190815_2_SF12_3_bold_1_9_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub099_20190815_2_SF12_4_bold_1_17_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub099_20190815_2_SF18_4_bold_1_15_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF18_4.nii

#dlsub123_session_1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub123_250819_SF3_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub123_250819_SF3_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub123_250819_SF6_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub123_250819_SF6_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub123_250819_SF12_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub123_250819_SF12_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub123_250819_SF12_bold_1_17_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii

#dlsub123_session_2
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub123_2_SF03_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub123_2_SF06_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub123_2_SF12_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub120_session_3
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub120_3_2_SF3_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub120_3_2_SF6_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub120_3_2_SF12_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub003_session1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsubj003_SF3_1_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsubj003_SF3_2_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsubj003_SF3_3_bold_1_22_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsubj003_SF6_1_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsubj003_SF6_2_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsubj003_SF6_3_bold_1_20_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsubj003_SF12_1_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.08_dlsubj003_SF12_2_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.09_dlsubj003_SF12_3_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.10_dlsubj003_SF12_4_bold_1_18_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub126_session1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub126_24092019_SF3_1_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub126_24092019_SF3_2_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub126_24092019_SF3_3_bold_1_18_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub126_24092019_SF6_1_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub126_24092019_SF6_2_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub126_24092019_SF6_3_bold_1_20_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub126_24092019_SF12_1_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.08_dlsub126_24092019_SF12_2_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.09_dlsub126_24092019_SF12_3_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.10_dlsub126_24092019_SF12_4_bold_1_22_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub128_session1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub128_1_SF3_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub128_1_SF3_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub128_1_SF3_bold_1_18_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub128_1_SF6_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub128_1_SF6_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub128_1_SF6_bold_1_20_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub128_1_SF12_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.08_dlsub128_1_SF12_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.09_dlsub128_1_SF12_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.10_dlsub128_1_SF12_bold_1_22_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub134_session1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub134_SF3_1_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub134_SF3_2_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub134_SF3_3_bold_1_21_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub134_SF6_1_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub134_SF6_2_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub134_SF6_3_bold_1_23_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub134_SF12_1_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.08_dlsub134_SF12_2_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.09_dlsub134_SF12_3_bold_1_18_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.10_dlsub134_SF12_4_bold_1_25_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub133_session1
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF3_bold_1_10_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF3_bold_1_14_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF3_bold_1_18_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF6_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF6_bold_1_12_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF6_bold_1_21_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF12_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF12_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF12_bold_1_16_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.dlsub133_1_SF12_bold_1_23_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii

#dlsub131_session1
3dTcat motionCorrect_topUp_Epi/pb.01_dlsub131_SF3_1_bold_1_11_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_1.nii
3dTcat motionCorrect_topUp_Epi/pb.02_dlsub131_SF3_2_bold_1_15_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_2.nii
3dTcat motionCorrect_topUp_Epi/pb.03_dlsub131_SF3_3_bold_1_19_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF03_3.nii
3dTcat motionCorrect_topUp_Epi/pb.04_dlsub131_SF6_1_bold_1_6_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_1.nii
3dTcat motionCorrect_topUp_Epi/pb.05_dlsub131_SF6_2_bold_1_13_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_2.nii
3dTcat motionCorrect_topUp_Epi/pb.06_dlsub131_SF6_3_bold_1_21_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF06_3.nii
3dTcat motionCorrect_topUp_Epi/pb.07_dlsub131_SF12_1_bold_1_4_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_1.nii
3dTcat motionCorrect_topUp_Epi/pb.08_dlsub131_SF12_2_bold_1_8_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_2.nii
3dTcat motionCorrect_topUp_Epi/pb.09_dlsub131_SF12_3_bold_1_17_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_3.nii
3dTcat motionCorrect_topUp_Epi/pb.10_dlsub131_SF12_4_bold_1_23_1-d0224_deob.volreg+orig -prefix Functionals/pRF_SF12_4.nii


mkdir Functionals/Average # Within Functionals

3dMean -prefix Functionals/Average/meanTs_all_deob.nii.gz Functionals/*.nii
3dMean -prefix Functionals/Average/meanTs_sf03_deob.nii.gz Functionals/*SF03*.nii
3dMean -prefix Functionals/Average/meanTs_sf06_deob.nii.gz Functionals/*SF06*.nii
3dMean -prefix Functionals/Average/meanTs_sf12_deob.nii.gz Functionals/*SF12*.nii
3dMean -prefix Functionals/Average/meanTs_sf18_deob.nii.gz Functionals/*SF18*.nii

mkdir Functionals/Average/coreg

# coregister functionals with the anatomy (same script for different sessions/subjects)
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source Functionals/Average/meanTs_all_deob.nii.gz -1Dmatrix_apply combined.1D -final NN -prefix Functionals/coreg/meanTs_all_deob_coreg.nii.gz 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source Functionals/Average/meanTs_sf03_deob.nii.gz -1Dmatrix_apply combined.1D -final NN -prefix Functionals/coreg/meanTs_sf03_deob_coreg.nii.gz 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source Functionals/Average/meanTs_sf06_deob.nii.gz -1Dmatrix_apply combined.1D -final NN -prefix Functionals/coreg/meanTs_sf06_deob_coreg.nii.gz 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source Functionals/Average/meanTs_sf12_deob.nii.gz -1Dmatrix_apply combined.1D -final NN -prefix Functionals/coreg/meanTs_sf12_deob_coreg.nii.gz 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source Functionals/Average/meanTs_sf18_deob.nii.gz -1Dmatrix_apply combined.1D -final NN -prefix Functionals/coreg/meanTs_sf18_deob_coreg.nii.gz 


# remove the zeros which are not required (for the first session; second session use clip file of first session as a master)
3dAutobox -noclust -input Functionals/coreg/meanTs_all_deob_coreg.nii.gz -prefix Functionals/coreg/meanTs_all_deob_coreg_clip.nii

# dlsub127_session 1; for session 2 use the same master
# resample all the functionals to same resolution as the average of all the scans
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_all_deob_coreg_clip_res.nii.gz -inset Functionals/coreg/meanTs_all_deob_coreg_clip.nii -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf03_deob_coreg_clip_res.nii.gz -inset Functionals/coreg/meanTs_sf03_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf06_deob_coreg_clip_res.nii.gz -inset Functionals/coreg/meanTs_sf06_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf12_deob_coreg_clip_res.nii.gz -inset Functionals/coreg/meanTs_sf12_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf18_deob_coreg_clip_res.nii.gz -inset Functionals/coreg/meanTs_sf18_deob_coreg.nii.gz -rmode NN

#use the same master as in session 1
# dlsub127_session 2
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_all_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_all_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf03_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf03_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf06_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf06_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf12_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf12_deob_coreg.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf18_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf18_deob_coreg.nii.gz -rmode NN



# for sub120 session 1; remove last TR; (in session 1; 225 TRs and in session 2; 224 TRs)
3dTcat -prefix Functionals/coreg/meanTs_all_deob_coreg_224.nii.gz Functionals/coreg/meanTs_all_deob_coreg.nii.gz[0..223]
3dTcat -prefix Functionals/coreg/meanTs_sf03_deob_coreg_224.nii.gz Functionals/coreg/meanTs_sf03_deob_coreg.nii.gz[0..223]
3dTcat -prefix Functionals/coreg/meanTs_sf06_deob_coreg_224.nii.gz Functionals/coreg/meanTs_sf06_deob_coreg.nii.gz[0..223]
3dTcat -prefix Functionals/coreg/meanTs_sf12_deob_coreg_224.nii.gz Functionals/coreg/meanTs_sf12_deob_coreg.nii.gz[0..223]
3dTcat -prefix Functionals/coreg/meanTs_sf18_deob_coreg_224.nii.gz Functionals/coreg/meanTs_sf18_deob_coreg.nii.gz[0..223]

# resampling of data sub120 session 1; after removing last TR; (use clip file from session 2)
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_all_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_all_deob_coreg_224.nii.gz -rmode NNcf 
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf03_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf03_deob_coreg_224.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf06_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf06_deob_coreg_224.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf12_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf12_deob_coreg_224.nii.gz -rmode NN
3dresample -master Functionals/coreg/meanTs_all_deob_coreg_clip.nii -prefix Functionals/coreg/meanTs_sf18_deob_coreg_clip_res_s02.nii.gz -inset Functionals/coreg/meanTs_sf18_deob_coreg_224.nii.gz -rmode NN


# Do all the above for session 2 also and average the resampled data from all the condition 

# compute mean for the two different sessions

3dMean -prefix meanTs_all_deob_s1_2_3.nii.gz *all*.nii.gz
3dMean -prefix meanTs_sf03_deob_s1_2_3.nii.gz *sf03*.nii.gz
3dMean -prefix meanTs_sf06_deob_s1_2_3.nii.gz *sf06*.nii.gz
3dMean -prefix meanTs_sf12_deob_s1_2_3.nii.gz *sf12*.nii.gz
3dMean -prefix meanTs_sf18_deob_s1_2_3.nii.gz *sf18*.nii.gz

# copy all meanTs in new folder; meanTs


#####################################################################################################
# MRVISTA ANALYSIS

# Create new folder; vistaSession
# inside create; functionals, Stimuli and anatomy
# functionals contains meanTs
# anatomy contains .7 anatomy, segmentation and inplane

# Inplane;


3dTcat meanTs_sf03_deob_coreg_clip_res.nii.gz[0] -prefix inplane+orig

3dAFNItoNIFTI inplane+orig -prefix inplane.nii

module load matlab
Matlab

# addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/vistasoft/))
# cd vistaSession; mrInit
# This opens a GUI dialog box that has the options to upload 1) Inplane anatomy 2) Functional data 
# Inplane anatomy = inplane.nii  
# Functionals; all the mean Ts; in correct order (3-6-12-18); loading them one by one; rename them SF03 and SF06 
# Volume anatomy; 07_N3.nii 
# Select: Clip frames from time series (first 21 sec; first 14TRs) 
# Total of 210TRs + 14TRs ---> remove the first 14TRs 
# Subject dlsub127 
# Description; sf03, sf06, sf12, sf18 
# Skip 14 (+keep all frames after that) 

# creates; mrSESSION.mat file and inplane directory

MrVista (mrVista) 
# Edit – datatype – group scans into data type – choose ie sf3 – new data type – name sf03 
# Create a new data type  
# Do it for every sf; creates a folder inside inplane 


# The next step is the alignment of the functional and anatomical images

RxAlign

# Opens alignment GUI
# Align functional and anatomy
# Check alignment; window - open rx/ref comparison window    comparison prefs; compare all slices

# Save; xfrom settings + mrVista alignment



# load the segmentation file using the drop down menu in the Inplane GUI, Gray | Gray/ White segmentation | Install or Reinstall segmentation

   
# Open inplane and volume view both datatype; sf03  
# Xform | Inplane->Volume | tSeries (all scans) | trilinear interpolation 
# Analysis | Mean Map | Mean Map (all scans) 


# SET PARAMETERS FOR STIMULUS FOR EVERY CONDITION 

# From the volume view, go to Analysis | Retinotopic model | Set Parameter to load the stimuli parameters. 
# Select class | stimFromscan
# Stimulus radius = 5
# Set the detrending fMax to 1
# Remove frames = 0  (already removed)
# Select HRF model as Two gamma
# Set image filter to binary
# Select save to dataTYPES option


# PRF MODEL
# make sure that the inplane/volume view is opened with the condition you want to analyse
# Tmp = load('Stimuli/20190619T145128.mat’) 
# Addpath(genpath(‘data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/prfModelRun’)) 

runModel

# VISUALIZE MODEL
# Gray | Surface mesh | build new mesh
# To inflate mesh, navigate to Gray | Inflate (set Params). This opens the Set Mesh Build Parameters. Set the smooth iterations to 128 and smooth relaxation to 1.
#  With the model loaded, navigate to Gray | Update Mesh to display the model on the surface. By default it loads the eccentricity map. 
# To load the polar angle maps, select Color Map | Phase Mode | Wedge map for pRF (left - for left Hemisphere). Update the mesh always when you make any changes in the VOLUME view. (the polar angle shows the relation between the brain and the visual space (stimulus)


##############################################################################################
refined model


# Run the pRF model for all  voxels for ALL (average) condition (also run the hrf fit)
roiFileName = [];
searchType  = 5;
VOLUME{1} = rmMain(VOLUME{1},[],5);

#use this model in the next step;

# Select the original model
[model_fname, model_fpath] = uigetfile('*.mat','Select model');
model_all = (fullfile(model_fpath, model_fname));

# run this model for all the different conditions by changing the datatype to the different conditions and run;
# in the gray view, change dataType = sf03

# Load the pRF model 
VOLUME{1} = rmSelect(VOLUME{1},1,model_all);
hrf = cell(1,2);
hrf{1} = VOLUME{1}.rm.retinotopyParams.stim.hrfType;
hrf{2} = VOLUME{1}.rm.retinotopyParams.stim.hrfParams(2); 

# Run the model fit for only sigma alone
VOLUME{1} = rmMain(VOLUME{1},[],7,'matFileName','sfall_refined_','hrf',hrf,'refine','sigma');



###################################################################################################
Define your ROI: 

# Press 'd' to enter the drawing mode. 
# Click on the cortical surface where you would like the borders of the ROI to be. 
# Press 'u' to undo the changes. 
# Press 'delete' to delete the drawn ROI, when starting to draw a new ROI to clear any memory buffer. 
# Press 'c' to close the ROI shape. 
# Press 'f' and click inside the ROI to fill it. 
# After drawing the ROI on the surface, navigate to VOLUME view and select Gray | Mesh ROIs | Get ROI From Mesh (drawn with "d" key, All Layers) --> save as V1_left / V1_right (shared) 
# ROIs  - select/edit/combine - combine ROIs – select V1_left + V1_right --> V1 


###################################################################################################

run DoG model:
%% Difference of gaussians model 
mrVista 3;

roiFileName = [];
searchType  = 'coarse to fine';
outFileName = 'DoGs_all_';
prfModels = {'difference of gaussians'};
VOLUME{1} = rmMain(VOLUME{1},roiFileName,searchType,'matFileName', outFileName,'model',prfModels);


##################################################################################################








