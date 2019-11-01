%% Prepare
clear all
close all

% Add AFNI scripts
addpath(genpath('/data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/pRF-comparison-Spatial-frequency/AFNI_preprocessing/'));

% Set main directory:
mainDir = pwd;
cd(mainDir)

% Convert PAR and REC files to .nii
system(['python /data1/projects/dumoulinlab/Lab_members/Akhil/SF/code/pRF-comparison-Spatial-frequency/AFNI_preprocessing/convert2niigz.py ' mainDir ' dcm2niix']);



% Unzip the files
system('gunzip *.nii.gz');

%%

% a = load_nifti('mp2rage.nii.gz');
% 
% figure;imagesc(a.vol(:,:,100)) % set the color bar on to check the values
% 
% new_img = (a.vol+0.5).*4000; % scale the values
% 
% anew = a;
% 
% anew.vol = new_img;
% 
% anew.scl_inter = 0; % interset value should be set to 0
% 
% anew.scl_slope = 0; % slope value should be set to 0 too
% 
% save_nifti(anew,'mp2rage_norm.nii')