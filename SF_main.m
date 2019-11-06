% SF_main - main function to run the pRF models and perform the analysis
% 
% Needs to setup the mrVista session. 
% Steps for setting up mrVista session
% Folders for defining mrSESSION
% NP_init_directory_structure;
%
% mrInit;
% mrVista;
% Check spinozacentre.nl/dlwiki >> pRF Modelling steps for making a mrVista
% session. Once mrVista session is created, following steps can be run.
%
% Written by Akhil Edadan (a.edadan@uu.nl) and Demy Vermeij for pRFModel_spatialFrequency project
 
%% Run the model with hrf fit for both the conditions together

SF_prfFit_with_hrfFit;

%% Refined sigma fit for 3 Hz condition

condition = 'sf03';
SF_refinedSigmaFit(model_file_all, condition)

%% Refined sigma fit for 6 Hz condition

condition = 'sf06';
SF_refinedSigmaFit(model_file_all, condition)

%% Refined sigma fit for 12 Hz condition

condition = 'sf12';
SF_refinedSigmaFit(model_file_all, condition)


%% Analysis for all subject

SF_runAll;

% use combineMultipleRois to combine different rois

%% Stats -  repeated measures ANOVA
% parameters
paramsToCompare      = 'central';
paramsToCompare_type = 'absolute';
rois = 'V123';
        
fprintf('parameter: %s \t type: %s \t rois: %s',paramsToCompare,paramsToCompare_type,rois);

NP_stats(paramsToCompare,paramsToCompare_type,rois); 

%%