%% Script to do regular resolution (> 1 mm with TOPUP) preprocessing in AFNI

% Author: Jelle van Dijk, j.a.vandijk@uu.nl
% Edited by Carlien Roelofzen, c.roelofzen@spinozacentre.nl
% Called functions/scripts by: Alessio Fracasso, Wietske van der Zwaag & Jelle van Dijk

% ALWAYS CHECK YOUR OUTPUTS! 
% in the command line: use '3dinfo nameOfVolume' to get info about TR, space etc.or visually check by opening e.g. afni. 

% Run startAfniToolbox_git in the terminal
    % module load purge
    % module load afni/17.0.13
    % module load matlab
    % module load matlab/toolboxes/vistasoft
    
%% Prepare
clear all
close all

% Add AFNI scripts
addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/pRF-comparison-Spatial-frequency/AFNI_preprocessing/'));

% Set main directory:
mainDir = '/data1/projects/dumoulinlab/Lab_members/Akhil/SF/data/functionals/';
cd(mainDir)

% Convert PAR and REC files to .nii
system(['python /data1/projects/dumoulinlab/Lab_members/Carlien/AFNI_preprocessing/convert2niigz.py ' mainDir ' dcm2niix']);

% Unzip the files
system('gunzip *.nii.gz');

% Setup the correct directory structure for the rest of the analysis
setupDirectories_highRes 
anatDir = [mainDir, '/Anatomy/'];
coregDir = [mainDir, '/Coregistration/'];
mkdir Segmentation
segDir = [mainDir, '/Segmentation/'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 	       Anatomical data	        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Combine INV1 and INV2 of the MP2RAGE 
% Make sure that all files are called the same stem, with suffixes _INV1, _INV1ph, _INV2, INV2ph 
% for the appropriate files. INV2 (echo01) is the proton density volume

% Copy and rename files
cd(anatDir)
system(['cp *INV1*[^ph].nii MP2RAGE_INV1.nii']);     % T1
system(['cp *INV1*ph.nii MP2RAGE_INV1ph.nii']);

system(['cp *e1.nii MP2RAGE_INV2.nii']);        % proton density volume
system(['cp *e1_ph.nii MP2RAGE_INV2ph.nii']);

mp2rageB('MP2RAGE',100,1); % stem string, threshold (play around with this!), movie yes/no

%% Skull stripping
system('skullStrip01.sh MP2RAGE.nii MP2RAGE_INV2.nii 0.7 0'); 
    % Example call: system('skullStrip01.sh T1_uncorrected.nii PD.nii 1 1')
    % MPRAGE = name of T1 file, PD = name of PD file, 
	% res = output resolution (mm), coregFlag = 0 or 1: 0 for MP2RAGE data 
	% (as T1 and PD are inherently coregistered), 1 for MPRAGE data
    
% Rename MPRAGE_ss to MP2RAGE_ss 
system('3dcopy MPRAGE_ss.nii MP2RAGE_ss.nii');

%% ACPC alignment
% Setup
addpath(genpath('/packages/matlab/R2018b/toolbox/images/iptformats'));
addpath(genpath('/packages/matlab/toolbox'));

% Define the base t1 directory
t1_dir = anatDir; 

% Define the location and name of the (unaligned) T1 file
t1FileDir = fullfile(t1_dir,'MP2RAGE_ss.nii'); 

% Define the location and name of the (ACPC-aligned) T1 file (to be created)
t1AcpcName = fullfile(t1_dir,'MP2RAGE_ss_acpc.nii'); 

% Define the location of your ACPC-aligned reference T1 volume
acpcReference = '/data1/projects/dumoulinlab/Lab_members/Carlien/AFNI_preprocessing/acpc_alignment/t1_acpc_ref_0.65mm_s073.nii.gz'; 

% Run
t1 = niftiread(t1FileDir);
mrAnatAverageAcpcNifti(t1FileDir,t1AcpcName,acpcReference,[0.7 0.7 0.7],[],[],'true', []); % resample to 0.7mm isotropic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 		     Segmentation	        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CBStools
% Use MIPAV with the CBStools plugin
% Use layout: brain-segmentation-08.LayoutXML
% Make sure the input file (MP2RAGE_ss_acpc.nii.gz) and the processing + output folders are correct
cd(segDir)
mkdir 'MIPAV_processing';
mkdir 'MIPAV_output';
MIPAV_outputDir = [segDir, 'MIPAV_output/'];

%% Split segmentation into left and right hemisphere 
cd(segDir)
mkdir 'hemisphereSeparation';
hemisphereFolder = ([segDir, 'hemisphereSeparation/']);
cd(MIPAV_outputDir)
copyfile('anatomy_N3.nii.gz', hemisphereFolder);
copyfile('segmentation.nii.gz', hemisphereFolder);
cd(hemisphereFolder)

% Example call: system(['hemisphereSeparation.sh anat seg atlaspath nonlinflag']);
    % anat = anatomy, seg = segmentation, atlaspath = full path to afni atlas you want to register to
    % (necessary). If possible, use the TT_icbm+tlrc atlas. example: /usr/share/afni/atlases/TT_icbm452+tlrc 
	% nonlinflag = 0 linear, use when the border between hemispheres is straight, 1 nonlinear. 
system(['hemisphereSeparation.sh anatomy_N3.nii.gz segmentation.nii.gz /packages/afni/17.0.13/TT_icbm452+tlrc 1']);

% Make the segmentation ready to be installed in mrVista
system(['3dcalc -a segmentation.nii.gz -b leftSeg.nii.gz -c rightSeg.nii.gz -expr ''and( within(a,3,3), '...
 	'within(b,3,3) )*3 + and( within(a,3,3), within(c,3,3) )*4 + within(a,0,0)*1 + within(a,1,1)*0'' -prefix segmentation_mrVista.nii.gz'])
copyfile('segmentation_mrVista.nii.gz', segDir);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%resampling the segmentation to 0.7 mm 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% resample anatomy to 0.7 mm
3dresample -dxyz 0.7 0.7 0.7 -rmode Li -prefix anatomy_N3_0_7mm.nii.gz -input anatomy_N3.nii.g

% cd in the subject folder and make a folder called seg_resampling. This folder should contain Anatomy at 0.7 mm and segmentation at 0.6 mm 

 mkdir seg_resampling

% make a label file only for left hemisphere
3dcalc -a t1_seg.nii.gz -expr "within(a,4,4)*1 + within(a,3,3)*3  + within(a,0,0)*1 + within(a,1,1)*0" -prefix seg_filled_0_6mm_rlbl_gw_lt.nii.gz

% make a label file only for right hemisphere
3dcalc -a t1_seg.nii.gz -expr "within(a,4,4)*4 + within(a,3,3)*1  + within(a,0,0)*1 + within(a,1,1)*0" -prefix seg_filled_0_6mm_rlbl_gw_rt.nii.gz 

% resample the segmentations to 0.7 mm given by the master dataset (anatomy)
% left
3dresample -master anatomy_N3_0_7mm.nii.gz -rmode Li -prefix seg_filled_0_7mm_rlbl_gw_lt_li.nii.gz -input seg_filled_0_6mm_rlbl_gw_lt.nii.gz 
% right
3dresample -master anatomy_N3_0_7mm.nii.gz -rmode Li -prefix seg_filled_0_7mm_rlbl_gw_rt_li.nii.gz -input seg_filled_0_6mm_rlbl_gw_rt.nii.gz

% relabel the segmentations by setting the threshold values
% left
3dcalc -a seg_filled_0_7mm_rlbl_gw_lt_li.nii.gz -expr "within(a,0,0.5)*0 + within(a,0.5,1.25)*1 + within(a,1.25,3)*3" -prefix seg_filled_0_7mm_rlbl_gw_lt_li_rlbl.nii.gz
% right
3dcalc -a seg_filled_0_7mm_rlbl_gw_rt_li.nii.gz -expr "within(a,0,0.5)*0 + within(a,0.5,1.25)*1 + within(a,1.25,4)*4" -prefix seg_filled_0_7mm_rlbl_gw_rt_li_rlbl.nii.gz

% Combine left and right segmentations 
3dcalc -a seg_filled_0_7mm_rlbl_gw_lt_li_rlbl.nii.gz -b seg_filled_0_7mm_rlbl_gw_rt_li_rlbl.nii.gz -expr "and(within(a,0,0),within(b,0,0))*0 + and(within(a,1,1),within(b,1,1))*1 + and(within(a,3,3),within(b,1,1))*3 + and(within(a,1,1),within(b,4,4))*4" -prefix seg_filled_0_7mm.nii.gz

% Set the white matter and gray matter labels to be mrVista compatible
3dcalc -a seg_filled_0_7mm.nii.gz -expr "within(a,0,0)*1 + within(a,1,1)*0 + within(a,4,4)*4 + within(a,3,3)*3" -prefix seg_filled_0_7mm_lr.nii.gz 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 		    Functional data	        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Compute topup field, creates topUpDir, 7th input is maxlev setting for Qwarp
cd(mainDir)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Using r2agui to convert par recs to nifti can cause it to read the TRs differently. TRs can be reset and then each 
% scan can be deobliqued by using the following two scripts

% create a folder called PARRECS and copy all the nifti files obtained as an output from r2agui to this folder.
% run the following lines of code from folder just outside this PARRECS/ folder 

% refit the functionals with a new TR (of 1.5)
refitTR.sh PARRECS/ 1.5

% check file info using 3dinfo before and after resetting the TR. Eg: 3dinfo **.nii (to do it for all the files at once)

% deoblique the refitted functionals
deobliqueScans.sh PARRECS/

% check if the deoblique happened using 3dinfo (if yes, data axis tilt should be "plumb")

copy the deobliqued functionals to a folder called EPI and continue with the analysis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 8th input how much to blur the data for Qwarp.
% QWarp (higher is more strict)
% keep the 1's. the 1-2-3-4 are the runs you want to use for the correction
% from the EPIs (first numbers) and TOPUP (2nd set).
system('motionCorrect.afni.blip.sh EPI/ TOPUP/ 1 1 1-2-3-4-5-6-7 1-2-3-4-5-6-7 5 -1')

%% Motion correct and motion correct + top up the original EPI data
% Last input is the EPI number used for the previous step. 
system('motionCorrectEPI.with.topUp.sh EPI/ topUpDir/ 1');
% Does the motion correction, with Fourier interpolation
% Then apply top up transform from previous step
% Last input is which volume to allign everything to. 

%% Compute mean timeseries from motion corrected EPI only
% Make sure you only have the functional runs for 1 of the conditions in
% the motionCorrectEpi folder when you run the next command.
% Copy around files to do the next condition. 
system('. computeMeanTs.sh motionCorrectEpi/');
system('3dresample -orient RAI -input meanTs.nii -prefix meanTs_RAI.nii.gz' ) % reorients the axes (sometimes needed)
% no real resampling, just reorienting (if needed). 

%% Compute amplitude anatomy (average over all timepoints over all runs, used as an inplane anatomy)
system('computeAmplitudeAnatomy.sh motionCorrect_topUp_Epi/') % inplane


%% mrVista
% Now use the meanTs_RAI.nii.gz files as your functional data for mrVista, the amplitudeAnatomy.nii as your inplane anatomy
% and initiate a mr Vista session with this

% Now do your favorite analysis in the mrVista inplane view, get the model data out of mrVista and into a .nii.gz file.  
saveRmModelAsNifti % some fiddling in the code may be required to make the last volume (the original EPI)
% line up with the polar angle etc maps.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 		    Co-registration         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Co-register the functional volume(s) to the anatomy and check the size and origin of the anatomy using 3dinfo
% Run all this from the Coregistration directory, and keep checking using AFNI via the command line! 

% Copy anatomy_N3.nii.gz + amplitudeAnatomy.nii to the Coregistration folder
cd(MIPAV_outputDir);
copyfile('anatomy_N3.nii.gz', coregDir);
cd(mainDir);
copyfile('amplitudeAnatomy.nii', coregDir);

cd(coregDir)
% OPTIONAL: if some volume is in the +orig format, this is a way to convert it to .nii/ .nii.gz
% system('3dcopy file+orig file.nii.gz') ; 

% Mask the amplitudeAnatomy to reduce the volume size.
system('3dAutomask -apply_prefix amplitudeAnatomy_deob_mask.nii.gz amplitudeAnatomy.nii');

% Zeropad the amplitudeAnatomy to allow for shifting it around in the next steps.
system('3dZeropad -A 20 -P 20 -S 20 -I 20 -prefix amplitudeAnatomy_deob_mask_zp.nii.gz amplitudeAnatomy_deob_mask.nii.gz');

% Now align the centers of mass of the amplitudeAnatomy and anatomy, so they are in the same space
% USE MIPAV N3_anatomy! 
system('@Align_Centers -base anatomy_N3.nii.gz -dset amplitudeAnatomy_mask_zp.nii.gz -cm');

% Now use the Nudge datasets plugin in AFNI to get a good start for the coregistration
% 1. Open a terminal and cd into the coregistration folder
% 2. Start AFNI
% 3. Underlay: anatomy_N3.nii.gz
% 4. Overlay: amplitudeAnatomy_mask_zp.nii.gz (select only positive values)
% 5. Select Define Datamode > Plugins > Nudge Dataset
% 6. Choose dataset: amplitudeAnatomy_mask_zp.nii.gz
% 7. Move and rotate the amplitudeAnatomy_mask_zp.nii.gz (click Nudge)
% 8. Once the volume is in the right place, click 'Print' and copy paste the 3drotate parameters below

% system(['3drotate -quintic -clipit -rotate 1.12I -17.96R 2.35A -ashift 12.00S 3.00L -7.00P -prefix ' ...
%  'amplitudeAnatomy_mask_zp_shft_rot.nii.gz amplitudeAnatomy_mask_zp_shft.nii.gz']);

% system(['3drotate -quintic -clipit -rotate -2.33I -18.99R -0.76A -ashift 19.41S 0.29L 38.20P -prefix ' ...
% 'amplitudeAnatomy_mask_zp_shft_rot.nii.gz amplitudeAnatomy_mask_zp_shft.nii.gz']);
system(['3drotate -quintic -clipit -rotate 2.11I -28.00R 0.28A -ashift 13.23S -5.00L 41.65P -prefix ' ...
 'amplitudeAnatomy_mask_zp_shft_rot.nii.gz amplitudeAnatomy_mask_zp_shft.nii.gz']);

% Get the rotation matrix out as a .1D file
system(['cat_matvec ''amplitudeAnatomy_deob_mask_zp_shft_rot.nii.gz::ROTATE_MATVEC_000000'' -I -ONELINE > rotateMat.1D']); 

% Now refine the co-registration automatically
system(['align_epi_anat.py -anat anatomy_N3_0_7mm.nii.gz ' ...
	'-epi amplitudeAnatomy_deob_mask_zp_shft_rot.nii.gz ' ...
	'-epi_base 0 ' ... %the how manieth volume is the amplitudeAnatomy (usually 0, as AFNI starts at 0).
	'-epi2anat ' ...
	'-cost lpc ' ... %cost function. see the help (in the command line) for more info
	'-anat_has_skull no ' ...
	'-epi_strip None '...
    '-Allineate_opts -maxrot 10 -maxshf 10']);

% Combine all transformation matrices into one.
% system('cat_matvec -ONELINE amplitudeAnatomy_deob_mask_zp_shft.1D rotateMat.1D amplitudeAnatomy_deob_mask_zp_shft_rot_al_reg_mat.aff12.1D > combined.1D');
system('cat_matvec -ONELINE rotateMat.1D amplitudeAnatomy_deob_mask_zp_shft_rot_al_reg_mat.aff12.1D amplitudeAnatomy_deob_mask_zp_shft.1D > combined.1D');

% Apply the combined co-registration to the amplitudeAnatomy in one resampling step. 
% At the same time, this is a check to see whether the combination of the matrices worked. 
% If not, play around with the order in the previous command. 
system(['3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig ' ...
 '-source amplitudeAnatomy.nii ' ...
 '-1Dmatrix_apply combined.1D ' ...
 '-final wsinc5 ' ...
 '-prefix amplitudeAnatomy_deob_Coreg.nii.gz']); 


% Apply the coregistration for all the EPIs.
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob_coreg.nii 


%dlsub127 session1
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/02_dlsub127_02072019_SF6_1_bold_1_8_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/02_dlsub127_02072019_SF6_1_bold_1_8_1-d0224_deob_coreg.nii 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/03_dlsub127_02072019_SF6_2_bold_1_16_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/03_dlsub127_02072019_SF6_2_bold_1_16_1-d0224_deob_coreg.nii 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/04_dlsub127_02072019_SF12_1_bold_1_6_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/04_dlsub127_02072019_SF12_1_bold_1_6_1-d0224_deob_coreg.nii 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/05_dlsub127_02072019_SF12_2_bold_2_14_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/05_dlsub127_02072019_SF12_2_bold_2_14_1-d0224_deob_coreg.nii 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/06_dlsub127_02072019_SF18_1_bold_1_4_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/06_dlsub127_02072019_SF18_1_bold_1_4_1-d0224_deob_coreg.nii 
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob_coreg.nii 

%dlsub127 session2
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/01_dlsub127_20190708_SF3_2_bold_1_10_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/01_dlsub127_20190708_SF3_2_bold_1_10_1-d0224_deob_coreg2.nii

%dlsub120 session1
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/01_dlsub120_19062019_SF3_1_bold_9_1-d0225_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/01_dlsub120_19062019_SF3_1_bold_9_1-d0225_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/02_dlsub120_19062019_SF6_1_bold_15_1-d0225_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/02_dlsub120_19062019_SF6_1_bold_15_1-d0225_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/03_dlsub120_19062019_SF12_1_bold_13_1-d0225_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/03_dlsub120_19062019_SF12_1_bold_13_1-d0225_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/04_dlsub120_19062019_SF18_1_bold_11_1-d0225_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/04_dlsub120_19062019_SF18_1_bold_11_1-d0225_deob_coreg.nii

%dlsub120 session2
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/01_dlsub120_20190704_SF3_2_bold_1_10_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/01_dlsub120_20190704_SF3_2_bold_1_10_1-d0224_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/02_dlsub120_20190704_SF6_2_bold_1_8_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/02_dlsub120_20190704_SF6_2_bold_1_8_1-d0224_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/03_dlsub120_20190704_SF12_2_bold_1_6_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/03_dlsub120_20190704_SF12_2_bold_1_6_1-d0224_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/04_dlsub120_20190704_SF12_3_bold_1_14_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/04_dlsub120_20190704_SF12_3_bold_1_14_1-d0224_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/05_dlsub120_20190704_SF18_2_bold_1_4_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/05_dlsub120_20190704_SF18_2_bold_1_4_1-d0224_deob_coreg.nii
3dAllineate -master amplitudeAnatomy_deob_mask_zp_shft_rot_al+orig -source EPI/06_dlsub120_20190704_SF18_3_bold_2_12_1-d0224_deob.nii -1Dmatrix_apply combined.1D -final NN -prefix EPI/06_dlsub120_20190704_SF18_3_bold_2_12_1-d0224_deob_coreg.nii




% resample scans to same resolution
%session1 sub127
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/01_dlsub127_02072019_SF6_1_bold_1_10_1-d0224_deob_coreg_res.nii -inset 02_dlsub127_02072019_SF6_1_bold_1_8_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/03_dlsub127_02072019_SF6_2_bold_1_16_1-d0224_deob_coreg_res.nii -inset 03_dlsub127_02072019_SF6_2_bold_1_16_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/04_dlsub127_02072019_SF12_1_bold_1_6_1-d0224_deob_coreg_res.nii -inset 04_dlsub127_02072019_SF12_1_bold_1_6_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/05_dlsub127_02072019_SF12_2_bold_2_14_1-d0224_deob_coreg_res.nii -inset 05_dlsub127_02072019_SF12_2_bold_2_14_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/06_dlsub127_02072019_SF18_1_bold_1_4_1-d0224_deob_coreg_res.nii -inset 06_dlsub127_02072019_SF18_1_bold_1_4_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob_coreg_res.nii -inset 07_dlsub127_02072019_SF18_2_bold_1_12_1-d0224_deob_coreg.nii -rmode NN

%session2 sub127
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/03_dlsub127_20190708_SF6_3_bold_1_8_1-d0224_deob_coreg_res.nii -inset 03_dlsub127_20190708_SF6_3_bold_1_8_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/04_dlsub127_20190708_SF12_3_bold_1_6_1-d0224_deob_coreg_res.nii -inset 04_dlsub127_20190708_SF12_3_bold_1_6_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/05_dlsub127_20190708_SF12_4_bold_2_14_1-d0224_deob_coreg_res.nii -inset 05_dlsub127_20190708_SF12_4_bold_2_14_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/01_dlsub127_20190708_SF3_2_bold_1_10_1-d0224_deob_coreg_res.nii -inset 01_dlsub127_20190708_SF3_2_bold_1_10_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/02_dlsub127_20190708_SF3_3_bold_2_18_1-d0224_deob_coreg_res.nii -inset 02_dlsub127_20190708_SF3_3_bold_2_18_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/06_dlsub127_20190708_SF18_3_bold_1_4_1-d0224_deob_coreg_res.nii -inset 06_dlsub127_20190708_SF18_3_bold_1_4_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/07_dlsub127_20190708_SF18_4_bold_2_12_1-d0224_deob_coreg_res.nii -inset 07_dlsub127_20190708_SF18_4_bold_2_12_1-d0224_deob_coreg.nii -rmode NN
3dresample -master 01_dlsub127_02072019_SF3_1_bold_1_10_1-d0224_deob_coreg.nii -prefix res_coreg_EPI/08_dlsub127_20190708_SF18_5_bold_3_16_1-d0224_deob_coreg_res.nii -inset 08_dlsub127_20190708_SF18_5_bold_3_16_1-d0224_deob_coreg.nii -rmode NN

% Compute the mean timeseries for different spatial frequencies
3dMean -prefix meanTs_SF3_deob_coreg_res.nii.gz *SF3*.nii
3dMean -prefix meanTs_SF6_deob_coreg_res.nii.gz *SF6*.nii
3dMean -prefix meanTs_SF12_deob_coreg_res.nii.gz *SF12*.nii
3dMean -prefix meanTs_SF18_deob_coreg_res.nii.gz *SF18*.nii

% NOW GO AND DOUBLE CHECK ALL THE STEPS!

cd(mainDir)
% Apply the coregistration matrix to each mean timeseries
system(['3dAllineate -master ./Coregistration/amplitudeAnatomy_mask_zp_shft_rot_al+orig ' ...
 '-source ./Functional/meanTs.nii ' ... % replace with the meanTs file for a specific condition
 '-1Dmatrix_apply ./Coregistration/combined.1D ' ...
 '-final NN ' ... % final interpolation. change to desired way.
 '-prefix meanTs_Coreg.nii.gz']); 

%% mrVista
% Load the co-registered volumes from the coregistration folder into mrVista
mrInit
% Inplane: amplitudeAnatomy_Coreg.nii.gz (Coregistration folder)
% Functionals: meanTs_Coreg.nii.gz (mainDir)
% Anatomy: anatomy_N3.nii.gz (Coregistration folder

rxAlign
% The angulation is now perfect, but you will need to shift/flip it manually. 
% This is an unfortunate effect of mrVista not reading the .nii headers correctly.

% Rotations: 0, 90, -90
% Axial, sagittal + coronal flip

mrVista
% Gray > Gray/White segmentation > Install or Reinstall Segmentation > Use segmentation_mrVista.nii.gz (Coregistration folder)

% Quick analysis mean time series:
% Edit > Edit Datatype > 8 cycles
% Analysis > Travelling Wave Analysis > Compute corAnal > Compute corAnal (current scan)
% View > Coherence map (cothresh 0.20)
% View > Phase map 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 		   Surface analysis         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This bit assumes that you have done the segmentation using mipave and cbs tools.
% for more info on the inputs, type the function name without inputs in the command line.

% define boundaries
system('defineBoundaries.sh anatomy/boundaries.nii.gz 1 2 1')

% REMOVE?
system('3dcalc -a boundariesThr.nii.gz -b Layering/rightHemi.nii.gz -expr ''a*step(b)'' -prefix boundariesThr_clip.nii.gz')

system('rm boundariesThr.nii.gz')
system('mv boundariesThr_clip.nii.gz boundariesThr.nii.gz')
% check the number of boundaries with 3dinfo, number of time steps = num
% surfaces = num for generating surfaces (first numeric argument)

% generate surfaces
system('generateSurfaces.sh 6 4 1200 3') % 6 = number of surfaces, 4 = smoothing, 1200 = inflation iterations,
% 3 = inflation index, aka which layer you want to inflate.

% surface project results, RUN FROM TERMINAL, as this may otherwise cause unexpected behaviour. 
% anatomy.nii.gz is the name of the skullstripped anatomy here.
afniSurface.sh anatomy.nii.gz 

% r-click on the brain mesh, then press 't' to link the 2D and 3D views. 
% use the draw ROI menu to draw ROIS.
% SAVE AS .1D.roi files! 

% Grow the ROIs over all layers
lst = dir('*.roi');
for iN = 1:length(lst)
    system(['surf2vol.sh ' lst(iN).name ' boundary03 depth_shft_box.nii.gz 100']) 
end

% Combine ROIs (examples)
system('3dcopy V1_lh.1D.roi_clust+orig V1_lh+orig')
system('3dcalc -a V1_lh+orig -b V2v_lh.1D.roi_clust+orig -c V2d_lh.1D.roi_clust+orig -expr ''(b+c)-(a*(b+c))'' -prefix V2_lh+orig')
system('3dcalc -a V2_lh+orig -b V3v_lh.1D.roi_clust+orig -c V3d_lh.1D.roi_clust+orig -expr ''(b+c)-(a*(b+c))'' -prefix V3_lh+orig')
system('3dcopy V1_rh.1D.roi_clust+orig V1_rh+orig')
system('3dcalc -a V1_rh+orig -b V2v_rh.1D.roi_clust+orig -c V2d_rh.1D.roi_clust+orig -expr ''(b+c)-(a*(b+c))'' -prefix V2_rh+orig')
system('3dcalc -a V2_rh+orig -b V3v_rh.1D.roi_clust+orig -c V3d_rh.1D.roi_clust+orig -expr ''(b+c)-(a*(b+c))'' -prefix V3_rh+orig')
